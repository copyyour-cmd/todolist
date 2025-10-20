// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_tasks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayTasksHash() => r'8bdf7b671b60387189d74b78e386ab9d6ef7a2d4';

/// See also [todayTasks].
@ProviderFor(todayTasks)
final todayTasksProvider = AutoDisposeStreamProvider<List<Task>>.internal(
  todayTasks,
  name: r'todayTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todayTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TodayTasksRef = AutoDisposeStreamProviderRef<List<Task>>;
String _$overdueTasksHash() => r'ac74dfa3ce5061fe6de4cd51e9458a0f97d9096d';

/// See also [overdueTasks].
@ProviderFor(overdueTasks)
final overdueTasksProvider = AutoDisposeStreamProvider<List<Task>>.internal(
  overdueTasks,
  name: r'overdueTasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$overdueTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OverdueTasksRef = AutoDisposeStreamProviderRef<List<Task>>;
String _$upcomingTasksHash() => r'b4f9913c2a5c806218b8fe5c9aa544d0e2906ad6';

/// See also [upcomingTasks].
@ProviderFor(upcomingTasks)
final upcomingTasksProvider = AutoDisposeStreamProvider<List<Task>>.internal(
  upcomingTasks,
  name: r'upcomingTasksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$upcomingTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UpcomingTasksRef = AutoDisposeStreamProviderRef<List<Task>>;
String _$filteredTasksHash() => r'139e1f4055c04073889ca33a619e3f6ff9602532';

/// See also [filteredTasks].
@ProviderFor(filteredTasks)
final filteredTasksProvider = AutoDisposeStreamProvider<List<Task>>.internal(
  filteredTasks,
  name: r'filteredTasksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredTasksRef = AutoDisposeStreamProviderRef<List<Task>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
