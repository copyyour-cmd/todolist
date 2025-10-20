// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$habitsHash() => r'e701e20b19117003e6bf5ebda8585e2aa8190d22';

/// See also [habits].
@ProviderFor(habits)
final habitsProvider = AutoDisposeStreamProvider<List<Habit>>.internal(
  habits,
  name: r'habitsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$habitsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HabitsRef = AutoDisposeStreamProviderRef<List<Habit>>;
String _$habitServiceHash() => r'e36ea8b7bea1ac060174f666f09feae28d497ea2';

/// See also [habitService].
@ProviderFor(habitService)
final habitServiceProvider = AutoDisposeProvider<HabitService>.internal(
  habitService,
  name: r'habitServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$habitServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HabitServiceRef = AutoDisposeProviderRef<HabitService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
