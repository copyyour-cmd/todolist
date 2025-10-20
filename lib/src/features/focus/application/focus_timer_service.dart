import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/src/core/utils/clock.dart';
import 'package:todolist/src/core/utils/id_generator.dart';
import 'package:todolist/src/domain/entities/focus_session.dart';
import 'package:todolist/src/domain/entities/task.dart';
import 'package:todolist/src/domain/repositories/task_repository.dart';
import 'package:todolist/src/features/focus/application/focus_audio_service.dart';
import 'package:todolist/src/features/focus/application/focus_notification_service.dart';
import 'package:todolist/src/infrastructure/repositories/focus_session_repository.dart';

enum TimerState {
  idle,
  running,
  paused,
  completed,
}

class FocusTimerState {
  const FocusTimerState({
    required this.state,
    required this.remainingSeconds,
    required this.totalSeconds,
    this.currentSession,
  });

  final TimerState state;
  final int remainingSeconds;
  final int totalSeconds;
  final FocusSession? currentSession;

  double get progress {
    if (totalSeconds == 0) return 0;
    return (totalSeconds - remainingSeconds) / totalSeconds;
  }

  bool get isRunning => state == TimerState.running;
  bool get isPaused => state == TimerState.paused;
  bool get isCompleted => state == TimerState.completed;
  bool get isIdle => state == TimerState.idle;
}

class FocusTimerService extends StateNotifier<FocusTimerState> {
  FocusTimerService(
    this._repository,
    this._clock,
    this._idGenerator,
    this._notificationService,
    this._taskRepository,
    this._audioService,
  ) : super(const FocusTimerState(
          state: TimerState.idle,
          remainingSeconds: 0,
          totalSeconds: 0,
        ));

  final FocusSessionRepository _repository;
  final Clock _clock;
  final IdGenerator _idGenerator;
  final FocusNotificationService _notificationService;
  final TaskRepository _taskRepository;
  final FocusAudioService _audioService;

  Timer? _timer;
  FocusSession? _currentSession;
  DateTime? _pauseStartTime;
  int _totalPausedSeconds = 0;
  List<Interruption> _interruptions = [];

  Future<void> startTimer({
    required int durationMinutes,
    String? taskId,
  }) async {
    _timer?.cancel();
    _resetInterruptionTracking();

    final totalSeconds = durationMinutes * 60;
    final now = _clock.now();

    _currentSession = FocusSession(
      id: _idGenerator.generate(),
      taskId: taskId,
      durationMinutes: durationMinutes,
      startedAt: now,
    );

    state = FocusTimerState(
      state: TimerState.running,
      remainingSeconds: totalSeconds,
      totalSeconds: totalSeconds,
      currentSession: _currentSession,
    );

    // Show start notification
    Task? task;
    if (taskId != null) {
      task = await _taskRepository.getById(taskId);
    }
    await _notificationService.showStartNotification(
      durationMinutes: durationMinutes,
      taskTitle: task?.title,
    );

    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds > 0) {
        state = FocusTimerState(
          state: TimerState.running,
          remainingSeconds: state.remainingSeconds - 1,
          totalSeconds: state.totalSeconds,
          currentSession: state.currentSession,
        );
      } else {
        _completeSession();
      }
    });
  }

  Future<void> pauseTimer({String reason = 'Paused'}) async {
    if (state.state != TimerState.running) return;

    _timer?.cancel();
    _pauseStartTime = _clock.now();

    // Record interruption
    _interruptions.add(Interruption(
      timestamp: _pauseStartTime!,
      reason: reason,
    ));

    state = FocusTimerState(
      state: TimerState.paused,
      remainingSeconds: state.remainingSeconds,
      totalSeconds: state.totalSeconds,
      currentSession: state.currentSession,
    );

    // Show pause notification
    await _notificationService.showPauseNotification();
  }

  Future<void> resumeTimer() async {
    if (state.state != TimerState.paused) return;

    // Calculate pause duration
    if (_pauseStartTime != null) {
      final pauseDuration = _clock.now().difference(_pauseStartTime!);
      _totalPausedSeconds += pauseDuration.inSeconds;

      // Update last interruption with resume time
      if (_interruptions.isNotEmpty) {
        final lastInterruption = _interruptions.last;
        _interruptions[_interruptions.length - 1] = lastInterruption.copyWith(
          resumedAfterSeconds: pauseDuration.inSeconds,
        );
      }

      _pauseStartTime = null;
    }

    state = FocusTimerState(
      state: TimerState.running,
      remainingSeconds: state.remainingSeconds,
      totalSeconds: state.totalSeconds,
      currentSession: state.currentSession,
    );

    // Show resume notification
    await _notificationService.showResumeNotification();

    _startCountdown();
  }

  Future<void> _completeSession() async {
    _timer?.cancel();

    if (_currentSession != null) {
      final completedSession = _currentSession!.copyWith(
        isCompleted: true,
        completedAt: _clock.now(),
        interruptions: _interruptions,
        pausedSeconds: _totalPausedSeconds,
      );

      await _repository.save(completedSession);

      // Update task actual time if associated
      if (completedSession.taskId != null) {
        await _updateTaskActualTime(
          completedSession.taskId!,
          completedSession.durationMinutes,
        );
      }

      // Show notification
      Task? task;
      if (completedSession.taskId != null) {
        task = await _taskRepository.getById(completedSession.taskId!);
      }
      await _notificationService.showCompletionNotification(
        durationMinutes: completedSession.durationMinutes,
        taskTitle: task?.title,
      );

      // Play completion sound
      await _audioService.playCompletionSound();

      state = FocusTimerState(
        state: TimerState.completed,
        remainingSeconds: 0,
        totalSeconds: state.totalSeconds,
        currentSession: completedSession,
      );
    }
  }

  Future<void> cancelSession() async {
    _timer?.cancel();

    if (_currentSession != null) {
      final cancelledSession = _currentSession!.copyWith(
        wasCancelled: true,
        completedAt: _clock.now(),
        interruptions: _interruptions,
        pausedSeconds: _totalPausedSeconds,
      );

      await _repository.save(cancelledSession);
    }

    _resetInterruptionTracking();

    state = const FocusTimerState(
      state: TimerState.idle,
      remainingSeconds: 0,
      totalSeconds: 0,
    );

    _currentSession = null;
  }

  void resetTimer() {
    _timer?.cancel();
    _resetInterruptionTracking();

    state = const FocusTimerState(
      state: TimerState.idle,
      remainingSeconds: 0,
      totalSeconds: 0,
    );

    _currentSession = null;
  }

  void _resetInterruptionTracking() {
    _interruptions = [];
    _totalPausedSeconds = 0;
    _pauseStartTime = null;
  }

  Future<void> _updateTaskActualTime(String taskId, int minutes) async {
    final task = await _taskRepository.getById(taskId);
    if (task == null) return;

    final updatedTask = task.copyWith(
      actualMinutes: task.actualMinutes + minutes,
      focusSessionCount: task.focusSessionCount + 1,
    );

    await _taskRepository.save(updatedTask);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
