import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:todolist/src/domain/entities/smart_reminder.dart';

/// Service for managing location-based reminders
class LocationReminderService {
  LocationReminderService();

  StreamSubscription<Position>? _positionStream;
  final List<SmartReminder> _activeLocationReminders = [];
  final _triggerController = StreamController<SmartReminder>.broadcast();

  Stream<SmartReminder> get triggerStream => _triggerController.stream;

  /// Check and request location permissions
  Future<bool> checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Start monitoring location for active reminders
  Future<void> startMonitoring(List<SmartReminder> reminders) async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) return;

    // Filter only active location-based reminders
    _activeLocationReminders.clear();
    _activeLocationReminders.addAll(
      reminders.where(
        (r) => r.isActive && r.type == ReminderType.location && r.locationTrigger != null,
      ),
    );

    if (_activeLocationReminders.isEmpty) {
      stopMonitoring();
      return;
    }

    // Start position stream
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.medium,
      distanceFilter: 50, // Only update every 50 meters
    );

    _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      _onPositionUpdate,
      onError: (Object error) {
        print('Location error: $error');
      },
    );
  }

  /// Stop monitoring location
  void stopMonitoring() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  /// Handle position updates
  void _onPositionUpdate(Position position) {
    for (final reminder in _activeLocationReminders) {
      final trigger = reminder.locationTrigger;
      if (trigger == null) continue;

      // Calculate distance to target location
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        trigger.latitude,
        trigger.longitude,
      );

      // Check if within radius
      if (distance <= trigger.radiusMeters) {
        _triggerController.add(reminder);
        // Remove from active list to prevent duplicate triggers
        _activeLocationReminders.remove(reminder);
        break;
      }
    }
  }

  /// Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      print('Error getting position: $e');
      return null;
    }
  }

  /// Calculate distance between two points
  double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  void dispose() {
    stopMonitoring();
    _triggerController.close();
  }
}
