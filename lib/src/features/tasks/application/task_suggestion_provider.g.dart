// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_suggestion_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskSuggestionHash() => r'a2a23fc304dfa9fad3db36b36148ef673ea353fe';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for getting task suggestions based on list and tags
///
/// Copied from [taskSuggestion].
@ProviderFor(taskSuggestion)
const taskSuggestionProvider = TaskSuggestionFamily();

/// Provider for getting task suggestions based on list and tags
///
/// Copied from [taskSuggestion].
class TaskSuggestionFamily extends Family<AsyncValue<TaskSuggestion?>> {
  /// Provider for getting task suggestions based on list and tags
  ///
  /// Copied from [taskSuggestion].
  const TaskSuggestionFamily();

  /// Provider for getting task suggestions based on list and tags
  ///
  /// Copied from [taskSuggestion].
  TaskSuggestionProvider call({
    required String? listId,
    required List<String> tagIds,
  }) {
    return TaskSuggestionProvider(
      listId: listId,
      tagIds: tagIds,
    );
  }

  @override
  TaskSuggestionProvider getProviderOverride(
    covariant TaskSuggestionProvider provider,
  ) {
    return call(
      listId: provider.listId,
      tagIds: provider.tagIds,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'taskSuggestionProvider';
}

/// Provider for getting task suggestions based on list and tags
///
/// Copied from [taskSuggestion].
class TaskSuggestionProvider
    extends AutoDisposeFutureProvider<TaskSuggestion?> {
  /// Provider for getting task suggestions based on list and tags
  ///
  /// Copied from [taskSuggestion].
  TaskSuggestionProvider({
    required String? listId,
    required List<String> tagIds,
  }) : this._internal(
          (ref) => taskSuggestion(
            ref as TaskSuggestionRef,
            listId: listId,
            tagIds: tagIds,
          ),
          from: taskSuggestionProvider,
          name: r'taskSuggestionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$taskSuggestionHash,
          dependencies: TaskSuggestionFamily._dependencies,
          allTransitiveDependencies:
              TaskSuggestionFamily._allTransitiveDependencies,
          listId: listId,
          tagIds: tagIds,
        );

  TaskSuggestionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.listId,
    required this.tagIds,
  }) : super.internal();

  final String? listId;
  final List<String> tagIds;

  @override
  Override overrideWith(
    FutureOr<TaskSuggestion?> Function(TaskSuggestionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TaskSuggestionProvider._internal(
        (ref) => create(ref as TaskSuggestionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        listId: listId,
        tagIds: tagIds,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TaskSuggestion?> createElement() {
    return _TaskSuggestionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskSuggestionProvider &&
        other.listId == listId &&
        other.tagIds == tagIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, listId.hashCode);
    hash = _SystemHash.combine(hash, tagIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TaskSuggestionRef on AutoDisposeFutureProviderRef<TaskSuggestion?> {
  /// The parameter `listId` of this provider.
  String? get listId;

  /// The parameter `tagIds` of this provider.
  List<String> get tagIds;
}

class _TaskSuggestionProviderElement
    extends AutoDisposeFutureProviderElement<TaskSuggestion?>
    with TaskSuggestionRef {
  _TaskSuggestionProviderElement(super.provider);

  @override
  String? get listId => (origin as TaskSuggestionProvider).listId;
  @override
  List<String> get tagIds => (origin as TaskSuggestionProvider).tagIds;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
