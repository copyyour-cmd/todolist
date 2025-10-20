// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allTemplatesHash() => r'a682294f9197c111177ab86a2a86dfff13836e51';

/// Provider for all templates
///
/// Copied from [allTemplates].
@ProviderFor(allTemplates)
final allTemplatesProvider =
    AutoDisposeFutureProvider<List<TaskTemplate>>.internal(
  allTemplates,
  name: r'allTemplatesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllTemplatesRef = AutoDisposeFutureProviderRef<List<TaskTemplate>>;
String _$templatesByCategoryHash() =>
    r'b11ff2ac825bc2a11ce2b2c807cb0bbc066add0d';

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

/// Provider for templates by category
///
/// Copied from [templatesByCategory].
@ProviderFor(templatesByCategory)
const templatesByCategoryProvider = TemplatesByCategoryFamily();

/// Provider for templates by category
///
/// Copied from [templatesByCategory].
class TemplatesByCategoryFamily extends Family<AsyncValue<List<TaskTemplate>>> {
  /// Provider for templates by category
  ///
  /// Copied from [templatesByCategory].
  const TemplatesByCategoryFamily();

  /// Provider for templates by category
  ///
  /// Copied from [templatesByCategory].
  TemplatesByCategoryProvider call(
    TemplateCategory category,
  ) {
    return TemplatesByCategoryProvider(
      category,
    );
  }

  @override
  TemplatesByCategoryProvider getProviderOverride(
    covariant TemplatesByCategoryProvider provider,
  ) {
    return call(
      provider.category,
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
  String? get name => r'templatesByCategoryProvider';
}

/// Provider for templates by category
///
/// Copied from [templatesByCategory].
class TemplatesByCategoryProvider
    extends AutoDisposeFutureProvider<List<TaskTemplate>> {
  /// Provider for templates by category
  ///
  /// Copied from [templatesByCategory].
  TemplatesByCategoryProvider(
    TemplateCategory category,
  ) : this._internal(
          (ref) => templatesByCategory(
            ref as TemplatesByCategoryRef,
            category,
          ),
          from: templatesByCategoryProvider,
          name: r'templatesByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$templatesByCategoryHash,
          dependencies: TemplatesByCategoryFamily._dependencies,
          allTransitiveDependencies:
              TemplatesByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  TemplatesByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final TemplateCategory category;

  @override
  Override overrideWith(
    FutureOr<List<TaskTemplate>> Function(TemplatesByCategoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TemplatesByCategoryProvider._internal(
        (ref) => create(ref as TemplatesByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TaskTemplate>> createElement() {
    return _TemplatesByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TemplatesByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TemplatesByCategoryRef
    on AutoDisposeFutureProviderRef<List<TaskTemplate>> {
  /// The parameter `category` of this provider.
  TemplateCategory get category;
}

class _TemplatesByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<TaskTemplate>>
    with TemplatesByCategoryRef {
  _TemplatesByCategoryProviderElement(super.provider);

  @override
  TemplateCategory get category =>
      (origin as TemplatesByCategoryProvider).category;
}

String _$templateHash() => r'c6b37a7cba0f6932cf6b47481359dbe972de5fbe';

/// Provider for a specific template
///
/// Copied from [template].
@ProviderFor(template)
const templateProvider = TemplateFamily();

/// Provider for a specific template
///
/// Copied from [template].
class TemplateFamily extends Family<AsyncValue<TaskTemplate?>> {
  /// Provider for a specific template
  ///
  /// Copied from [template].
  const TemplateFamily();

  /// Provider for a specific template
  ///
  /// Copied from [template].
  TemplateProvider call(
    String id,
  ) {
    return TemplateProvider(
      id,
    );
  }

  @override
  TemplateProvider getProviderOverride(
    covariant TemplateProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'templateProvider';
}

/// Provider for a specific template
///
/// Copied from [template].
class TemplateProvider extends AutoDisposeFutureProvider<TaskTemplate?> {
  /// Provider for a specific template
  ///
  /// Copied from [template].
  TemplateProvider(
    String id,
  ) : this._internal(
          (ref) => template(
            ref as TemplateRef,
            id,
          ),
          from: templateProvider,
          name: r'templateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$templateHash,
          dependencies: TemplateFamily._dependencies,
          allTransitiveDependencies: TemplateFamily._allTransitiveDependencies,
          id: id,
        );

  TemplateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<TaskTemplate?> Function(TemplateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TemplateProvider._internal(
        (ref) => create(ref as TemplateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TaskTemplate?> createElement() {
    return _TemplateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TemplateProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TemplateRef on AutoDisposeFutureProviderRef<TaskTemplate?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _TemplateProviderElement
    extends AutoDisposeFutureProviderElement<TaskTemplate?> with TemplateRef {
  _TemplateProviderElement(super.provider);

  @override
  String get id => (origin as TemplateProvider).id;
}

String _$templateActionsHash() => r'9dec9439c2997dfbcb1537f41db8cf9bb6624881';

/// Provider for template actions (use, delete, etc.)
///
/// Copied from [TemplateActions].
@ProviderFor(TemplateActions)
final templateActionsProvider =
    AutoDisposeAsyncNotifierProvider<TemplateActions, void>.internal(
  TemplateActions.new,
  name: r'templateActionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$templateActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TemplateActions = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
