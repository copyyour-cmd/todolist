// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notesHash() => r'3d79e670a015deaa8b68e9b366817b10fdb2087b';

/// 所有笔记流
///
/// Copied from [notes].
@ProviderFor(notes)
final notesProvider = AutoDisposeStreamProvider<List<Note>>.internal(
  notes,
  name: r'notesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$notesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotesRef = AutoDisposeStreamProviderRef<List<Note>>;
String _$noteByIdHash() => r'1df048c8f0f99f561db120d106122af816c83e69';

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

/// 根据ID获取笔记流
///
/// Copied from [noteById].
@ProviderFor(noteById)
const noteByIdProvider = NoteByIdFamily();

/// 根据ID获取笔记流
///
/// Copied from [noteById].
class NoteByIdFamily extends Family<AsyncValue<Note?>> {
  /// 根据ID获取笔记流
  ///
  /// Copied from [noteById].
  const NoteByIdFamily();

  /// 根据ID获取笔记流
  ///
  /// Copied from [noteById].
  NoteByIdProvider call(
    String noteId,
  ) {
    return NoteByIdProvider(
      noteId,
    );
  }

  @override
  NoteByIdProvider getProviderOverride(
    covariant NoteByIdProvider provider,
  ) {
    return call(
      provider.noteId,
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
  String? get name => r'noteByIdProvider';
}

/// 根据ID获取笔记流
///
/// Copied from [noteById].
class NoteByIdProvider extends AutoDisposeStreamProvider<Note?> {
  /// 根据ID获取笔记流
  ///
  /// Copied from [noteById].
  NoteByIdProvider(
    String noteId,
  ) : this._internal(
          (ref) => noteById(
            ref as NoteByIdRef,
            noteId,
          ),
          from: noteByIdProvider,
          name: r'noteByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$noteByIdHash,
          dependencies: NoteByIdFamily._dependencies,
          allTransitiveDependencies: NoteByIdFamily._allTransitiveDependencies,
          noteId: noteId,
        );

  NoteByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.noteId,
  }) : super.internal();

  final String noteId;

  @override
  Override overrideWith(
    Stream<Note?> Function(NoteByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NoteByIdProvider._internal(
        (ref) => create(ref as NoteByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        noteId: noteId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Note?> createElement() {
    return _NoteByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NoteByIdProvider && other.noteId == noteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, noteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NoteByIdRef on AutoDisposeStreamProviderRef<Note?> {
  /// The parameter `noteId` of this provider.
  String get noteId;
}

class _NoteByIdProviderElement extends AutoDisposeStreamProviderElement<Note?>
    with NoteByIdRef {
  _NoteByIdProviderElement(super.provider);

  @override
  String get noteId => (origin as NoteByIdProvider).noteId;
}

String _$notesByCategoryHash() => r'f4e4a10c057f8194d07eaa5cdcaf2f9a4c0849cf';

/// 根据分类获取笔记
///
/// Copied from [notesByCategory].
@ProviderFor(notesByCategory)
const notesByCategoryProvider = NotesByCategoryFamily();

/// 根据分类获取笔记
///
/// Copied from [notesByCategory].
class NotesByCategoryFamily extends Family<AsyncValue<List<Note>>> {
  /// 根据分类获取笔记
  ///
  /// Copied from [notesByCategory].
  const NotesByCategoryFamily();

  /// 根据分类获取笔记
  ///
  /// Copied from [notesByCategory].
  NotesByCategoryProvider call(
    NoteCategory category,
  ) {
    return NotesByCategoryProvider(
      category,
    );
  }

  @override
  NotesByCategoryProvider getProviderOverride(
    covariant NotesByCategoryProvider provider,
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
  String? get name => r'notesByCategoryProvider';
}

/// 根据分类获取笔记
///
/// Copied from [notesByCategory].
class NotesByCategoryProvider extends AutoDisposeFutureProvider<List<Note>> {
  /// 根据分类获取笔记
  ///
  /// Copied from [notesByCategory].
  NotesByCategoryProvider(
    NoteCategory category,
  ) : this._internal(
          (ref) => notesByCategory(
            ref as NotesByCategoryRef,
            category,
          ),
          from: notesByCategoryProvider,
          name: r'notesByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notesByCategoryHash,
          dependencies: NotesByCategoryFamily._dependencies,
          allTransitiveDependencies:
              NotesByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  NotesByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final NoteCategory category;

  @override
  Override overrideWith(
    FutureOr<List<Note>> Function(NotesByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NotesByCategoryProvider._internal(
        (ref) => create(ref as NotesByCategoryRef),
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
  AutoDisposeFutureProviderElement<List<Note>> createElement() {
    return _NotesByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotesByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NotesByCategoryRef on AutoDisposeFutureProviderRef<List<Note>> {
  /// The parameter `category` of this provider.
  NoteCategory get category;
}

class _NotesByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Note>>
    with NotesByCategoryRef {
  _NotesByCategoryProviderElement(super.provider);

  @override
  NoteCategory get category => (origin as NotesByCategoryProvider).category;
}

String _$favoriteNotesHash() => r'fa3947c5f6cb8bbbdb956264f705415cd976c536';

/// 收藏的笔记
///
/// Copied from [favoriteNotes].
@ProviderFor(favoriteNotes)
final favoriteNotesProvider = AutoDisposeFutureProvider<List<Note>>.internal(
  favoriteNotes,
  name: r'favoriteNotesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteNotesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FavoriteNotesRef = AutoDisposeFutureProviderRef<List<Note>>;
String _$pinnedNotesHash() => r'b3c44f5ec1c7fa8d1defde12cdec24605bdf4d26';

/// 置顶的笔记
///
/// Copied from [pinnedNotes].
@ProviderFor(pinnedNotes)
final pinnedNotesProvider = AutoDisposeFutureProvider<List<Note>>.internal(
  pinnedNotes,
  name: r'pinnedNotesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pinnedNotesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PinnedNotesRef = AutoDisposeFutureProviderRef<List<Note>>;
String _$archivedNotesHash() => r'0d809e283b005ab0e377d2e36677475c03b66560';

/// 归档的笔记
///
/// Copied from [archivedNotes].
@ProviderFor(archivedNotes)
final archivedNotesProvider = AutoDisposeFutureProvider<List<Note>>.internal(
  archivedNotes,
  name: r'archivedNotesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$archivedNotesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ArchivedNotesRef = AutoDisposeFutureProviderRef<List<Note>>;
String _$recentlyViewedNotesHash() =>
    r'eabd21b3abdf6a7498bc448b054e9284db2e402d';

/// 最近查看的笔记
///
/// Copied from [recentlyViewedNotes].
@ProviderFor(recentlyViewedNotes)
const recentlyViewedNotesProvider = RecentlyViewedNotesFamily();

/// 最近查看的笔记
///
/// Copied from [recentlyViewedNotes].
class RecentlyViewedNotesFamily extends Family<AsyncValue<List<Note>>> {
  /// 最近查看的笔记
  ///
  /// Copied from [recentlyViewedNotes].
  const RecentlyViewedNotesFamily();

  /// 最近查看的笔记
  ///
  /// Copied from [recentlyViewedNotes].
  RecentlyViewedNotesProvider call({
    int limit = 10,
  }) {
    return RecentlyViewedNotesProvider(
      limit: limit,
    );
  }

  @override
  RecentlyViewedNotesProvider getProviderOverride(
    covariant RecentlyViewedNotesProvider provider,
  ) {
    return call(
      limit: provider.limit,
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
  String? get name => r'recentlyViewedNotesProvider';
}

/// 最近查看的笔记
///
/// Copied from [recentlyViewedNotes].
class RecentlyViewedNotesProvider
    extends AutoDisposeFutureProvider<List<Note>> {
  /// 最近查看的笔记
  ///
  /// Copied from [recentlyViewedNotes].
  RecentlyViewedNotesProvider({
    int limit = 10,
  }) : this._internal(
          (ref) => recentlyViewedNotes(
            ref as RecentlyViewedNotesRef,
            limit: limit,
          ),
          from: recentlyViewedNotesProvider,
          name: r'recentlyViewedNotesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recentlyViewedNotesHash,
          dependencies: RecentlyViewedNotesFamily._dependencies,
          allTransitiveDependencies:
              RecentlyViewedNotesFamily._allTransitiveDependencies,
          limit: limit,
        );

  RecentlyViewedNotesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<Note>> Function(RecentlyViewedNotesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecentlyViewedNotesProvider._internal(
        (ref) => create(ref as RecentlyViewedNotesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Note>> createElement() {
    return _RecentlyViewedNotesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentlyViewedNotesProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RecentlyViewedNotesRef on AutoDisposeFutureProviderRef<List<Note>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _RecentlyViewedNotesProviderElement
    extends AutoDisposeFutureProviderElement<List<Note>>
    with RecentlyViewedNotesRef {
  _RecentlyViewedNotesProviderElement(super.provider);

  @override
  int get limit => (origin as RecentlyViewedNotesProvider).limit;
}

String _$recentlyUpdatedNotesHash() =>
    r'8cf01d5172d5d7c26831637901377907531288ef';

/// 最近更新的笔记
///
/// Copied from [recentlyUpdatedNotes].
@ProviderFor(recentlyUpdatedNotes)
const recentlyUpdatedNotesProvider = RecentlyUpdatedNotesFamily();

/// 最近更新的笔记
///
/// Copied from [recentlyUpdatedNotes].
class RecentlyUpdatedNotesFamily extends Family<AsyncValue<List<Note>>> {
  /// 最近更新的笔记
  ///
  /// Copied from [recentlyUpdatedNotes].
  const RecentlyUpdatedNotesFamily();

  /// 最近更新的笔记
  ///
  /// Copied from [recentlyUpdatedNotes].
  RecentlyUpdatedNotesProvider call({
    int limit = 10,
  }) {
    return RecentlyUpdatedNotesProvider(
      limit: limit,
    );
  }

  @override
  RecentlyUpdatedNotesProvider getProviderOverride(
    covariant RecentlyUpdatedNotesProvider provider,
  ) {
    return call(
      limit: provider.limit,
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
  String? get name => r'recentlyUpdatedNotesProvider';
}

/// 最近更新的笔记
///
/// Copied from [recentlyUpdatedNotes].
class RecentlyUpdatedNotesProvider
    extends AutoDisposeFutureProvider<List<Note>> {
  /// 最近更新的笔记
  ///
  /// Copied from [recentlyUpdatedNotes].
  RecentlyUpdatedNotesProvider({
    int limit = 10,
  }) : this._internal(
          (ref) => recentlyUpdatedNotes(
            ref as RecentlyUpdatedNotesRef,
            limit: limit,
          ),
          from: recentlyUpdatedNotesProvider,
          name: r'recentlyUpdatedNotesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recentlyUpdatedNotesHash,
          dependencies: RecentlyUpdatedNotesFamily._dependencies,
          allTransitiveDependencies:
              RecentlyUpdatedNotesFamily._allTransitiveDependencies,
          limit: limit,
        );

  RecentlyUpdatedNotesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<Note>> Function(RecentlyUpdatedNotesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecentlyUpdatedNotesProvider._internal(
        (ref) => create(ref as RecentlyUpdatedNotesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Note>> createElement() {
    return _RecentlyUpdatedNotesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentlyUpdatedNotesProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RecentlyUpdatedNotesRef on AutoDisposeFutureProviderRef<List<Note>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _RecentlyUpdatedNotesProviderElement
    extends AutoDisposeFutureProviderElement<List<Note>>
    with RecentlyUpdatedNotesRef {
  _RecentlyUpdatedNotesProviderElement(super.provider);

  @override
  int get limit => (origin as RecentlyUpdatedNotesProvider).limit;
}

String _$notesByFolderHash() => r'27ab2df90584fefd61c513d9d823fa1a06659972';

/// 根据文件夹获取笔记
///
/// Copied from [notesByFolder].
@ProviderFor(notesByFolder)
const notesByFolderProvider = NotesByFolderFamily();

/// 根据文件夹获取笔记
///
/// Copied from [notesByFolder].
class NotesByFolderFamily extends Family<AsyncValue<List<Note>>> {
  /// 根据文件夹获取笔记
  ///
  /// Copied from [notesByFolder].
  const NotesByFolderFamily();

  /// 根据文件夹获取笔记
  ///
  /// Copied from [notesByFolder].
  NotesByFolderProvider call(
    String? folderPath,
  ) {
    return NotesByFolderProvider(
      folderPath,
    );
  }

  @override
  NotesByFolderProvider getProviderOverride(
    covariant NotesByFolderProvider provider,
  ) {
    return call(
      provider.folderPath,
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
  String? get name => r'notesByFolderProvider';
}

/// 根据文件夹获取笔记
///
/// Copied from [notesByFolder].
class NotesByFolderProvider extends AutoDisposeFutureProvider<List<Note>> {
  /// 根据文件夹获取笔记
  ///
  /// Copied from [notesByFolder].
  NotesByFolderProvider(
    String? folderPath,
  ) : this._internal(
          (ref) => notesByFolder(
            ref as NotesByFolderRef,
            folderPath,
          ),
          from: notesByFolderProvider,
          name: r'notesByFolderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notesByFolderHash,
          dependencies: NotesByFolderFamily._dependencies,
          allTransitiveDependencies:
              NotesByFolderFamily._allTransitiveDependencies,
          folderPath: folderPath,
        );

  NotesByFolderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.folderPath,
  }) : super.internal();

  final String? folderPath;

  @override
  Override overrideWith(
    FutureOr<List<Note>> Function(NotesByFolderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NotesByFolderProvider._internal(
        (ref) => create(ref as NotesByFolderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        folderPath: folderPath,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Note>> createElement() {
    return _NotesByFolderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotesByFolderProvider && other.folderPath == folderPath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, folderPath.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NotesByFolderRef on AutoDisposeFutureProviderRef<List<Note>> {
  /// The parameter `folderPath` of this provider.
  String? get folderPath;
}

class _NotesByFolderProviderElement
    extends AutoDisposeFutureProviderElement<List<Note>> with NotesByFolderRef {
  _NotesByFolderProviderElement(super.provider);

  @override
  String? get folderPath => (origin as NotesByFolderProvider).folderPath;
}

String _$notesByTagHash() => r'9d33c80fb689c946504dd8cc55528b4f7e48e37d';

/// 根据标签获取笔记
///
/// Copied from [notesByTag].
@ProviderFor(notesByTag)
const notesByTagProvider = NotesByTagFamily();

/// 根据标签获取笔记
///
/// Copied from [notesByTag].
class NotesByTagFamily extends Family<AsyncValue<List<Note>>> {
  /// 根据标签获取笔记
  ///
  /// Copied from [notesByTag].
  const NotesByTagFamily();

  /// 根据标签获取笔记
  ///
  /// Copied from [notesByTag].
  NotesByTagProvider call(
    String tag,
  ) {
    return NotesByTagProvider(
      tag,
    );
  }

  @override
  NotesByTagProvider getProviderOverride(
    covariant NotesByTagProvider provider,
  ) {
    return call(
      provider.tag,
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
  String? get name => r'notesByTagProvider';
}

/// 根据标签获取笔记
///
/// Copied from [notesByTag].
class NotesByTagProvider extends AutoDisposeFutureProvider<List<Note>> {
  /// 根据标签获取笔记
  ///
  /// Copied from [notesByTag].
  NotesByTagProvider(
    String tag,
  ) : this._internal(
          (ref) => notesByTag(
            ref as NotesByTagRef,
            tag,
          ),
          from: notesByTagProvider,
          name: r'notesByTagProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$notesByTagHash,
          dependencies: NotesByTagFamily._dependencies,
          allTransitiveDependencies:
              NotesByTagFamily._allTransitiveDependencies,
          tag: tag,
        );

  NotesByTagProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tag,
  }) : super.internal();

  final String tag;

  @override
  Override overrideWith(
    FutureOr<List<Note>> Function(NotesByTagRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NotesByTagProvider._internal(
        (ref) => create(ref as NotesByTagRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tag: tag,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Note>> createElement() {
    return _NotesByTagProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NotesByTagProvider && other.tag == tag;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tag.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NotesByTagRef on AutoDisposeFutureProviderRef<List<Note>> {
  /// The parameter `tag` of this provider.
  String get tag;
}

class _NotesByTagProviderElement
    extends AutoDisposeFutureProviderElement<List<Note>> with NotesByTagRef {
  _NotesByTagProviderElement(super.provider);

  @override
  String get tag => (origin as NotesByTagProvider).tag;
}

String _$searchNotesHash() => r'32268fb44bce027a965af100ff6d3efed81bce11';

/// 搜索笔记
///
/// Copied from [searchNotes].
@ProviderFor(searchNotes)
const searchNotesProvider = SearchNotesFamily();

/// 搜索笔记
///
/// Copied from [searchNotes].
class SearchNotesFamily extends Family<AsyncValue<List<Note>>> {
  /// 搜索笔记
  ///
  /// Copied from [searchNotes].
  const SearchNotesFamily();

  /// 搜索笔记
  ///
  /// Copied from [searchNotes].
  SearchNotesProvider call(
    String query,
  ) {
    return SearchNotesProvider(
      query,
    );
  }

  @override
  SearchNotesProvider getProviderOverride(
    covariant SearchNotesProvider provider,
  ) {
    return call(
      provider.query,
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
  String? get name => r'searchNotesProvider';
}

/// 搜索笔记
///
/// Copied from [searchNotes].
class SearchNotesProvider extends AutoDisposeFutureProvider<List<Note>> {
  /// 搜索笔记
  ///
  /// Copied from [searchNotes].
  SearchNotesProvider(
    String query,
  ) : this._internal(
          (ref) => searchNotes(
            ref as SearchNotesRef,
            query,
          ),
          from: searchNotesProvider,
          name: r'searchNotesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchNotesHash,
          dependencies: SearchNotesFamily._dependencies,
          allTransitiveDependencies:
              SearchNotesFamily._allTransitiveDependencies,
          query: query,
        );

  SearchNotesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<Note>> Function(SearchNotesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchNotesProvider._internal(
        (ref) => create(ref as SearchNotesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Note>> createElement() {
    return _SearchNotesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchNotesProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchNotesRef on AutoDisposeFutureProviderRef<List<Note>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchNotesProviderElement
    extends AutoDisposeFutureProviderElement<List<Note>> with SearchNotesRef {
  _SearchNotesProviderElement(super.provider);

  @override
  String get query => (origin as SearchNotesProvider).query;
}

String _$noteStatisticsHash() => r'604a5071ded2dfaaab3444d5d3aa7967775d1311';

/// 笔记统计信息
///
/// Copied from [noteStatistics].
@ProviderFor(noteStatistics)
final noteStatisticsProvider =
    AutoDisposeFutureProvider<NoteStatistics>.internal(
  noteStatistics,
  name: r'noteStatisticsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$noteStatisticsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NoteStatisticsRef = AutoDisposeFutureProviderRef<NoteStatistics>;
String _$noteLinkServiceHash() => r'193d11478339d94b48c4b6284f6cf3c2ee5e1842';

/// 笔记链接服务Provider
///
/// Copied from [noteLinkService].
@ProviderFor(noteLinkService)
final noteLinkServiceProvider = AutoDisposeProvider<NoteLinkService>.internal(
  noteLinkService,
  name: r'noteLinkServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$noteLinkServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NoteLinkServiceRef = AutoDisposeProviderRef<NoteLinkService>;
String _$noteBacklinksHash() => r'5c5b315d4facde909e7f8305272efa71eaefd4af';

/// 获取笔记的反向链接(哪些笔记链接到了这个笔记)
///
/// Copied from [noteBacklinks].
@ProviderFor(noteBacklinks)
const noteBacklinksProvider = NoteBacklinksFamily();

/// 获取笔记的反向链接(哪些笔记链接到了这个笔记)
///
/// Copied from [noteBacklinks].
class NoteBacklinksFamily extends Family<AsyncValue<List<Note>>> {
  /// 获取笔记的反向链接(哪些笔记链接到了这个笔记)
  ///
  /// Copied from [noteBacklinks].
  const NoteBacklinksFamily();

  /// 获取笔记的反向链接(哪些笔记链接到了这个笔记)
  ///
  /// Copied from [noteBacklinks].
  NoteBacklinksProvider call(
    String noteId,
  ) {
    return NoteBacklinksProvider(
      noteId,
    );
  }

  @override
  NoteBacklinksProvider getProviderOverride(
    covariant NoteBacklinksProvider provider,
  ) {
    return call(
      provider.noteId,
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
  String? get name => r'noteBacklinksProvider';
}

/// 获取笔记的反向链接(哪些笔记链接到了这个笔记)
///
/// Copied from [noteBacklinks].
class NoteBacklinksProvider extends AutoDisposeFutureProvider<List<Note>> {
  /// 获取笔记的反向链接(哪些笔记链接到了这个笔记)
  ///
  /// Copied from [noteBacklinks].
  NoteBacklinksProvider(
    String noteId,
  ) : this._internal(
          (ref) => noteBacklinks(
            ref as NoteBacklinksRef,
            noteId,
          ),
          from: noteBacklinksProvider,
          name: r'noteBacklinksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$noteBacklinksHash,
          dependencies: NoteBacklinksFamily._dependencies,
          allTransitiveDependencies:
              NoteBacklinksFamily._allTransitiveDependencies,
          noteId: noteId,
        );

  NoteBacklinksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.noteId,
  }) : super.internal();

  final String noteId;

  @override
  Override overrideWith(
    FutureOr<List<Note>> Function(NoteBacklinksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NoteBacklinksProvider._internal(
        (ref) => create(ref as NoteBacklinksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        noteId: noteId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Note>> createElement() {
    return _NoteBacklinksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NoteBacklinksProvider && other.noteId == noteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, noteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NoteBacklinksRef on AutoDisposeFutureProviderRef<List<Note>> {
  /// The parameter `noteId` of this provider.
  String get noteId;
}

class _NoteBacklinksProviderElement
    extends AutoDisposeFutureProviderElement<List<Note>> with NoteBacklinksRef {
  _NoteBacklinksProviderElement(super.provider);

  @override
  String get noteId => (origin as NoteBacklinksProvider).noteId;
}

String _$noteOutboundLinksHash() => r'a972b17be3799a800e51917e250c010983341209';

/// 获取笔记的正向链接(这个笔记链接到了哪些笔记)
///
/// Copied from [noteOutboundLinks].
@ProviderFor(noteOutboundLinks)
const noteOutboundLinksProvider = NoteOutboundLinksFamily();

/// 获取笔记的正向链接(这个笔记链接到了哪些笔记)
///
/// Copied from [noteOutboundLinks].
class NoteOutboundLinksFamily extends Family<AsyncValue<List<Note>>> {
  /// 获取笔记的正向链接(这个笔记链接到了哪些笔记)
  ///
  /// Copied from [noteOutboundLinks].
  const NoteOutboundLinksFamily();

  /// 获取笔记的正向链接(这个笔记链接到了哪些笔记)
  ///
  /// Copied from [noteOutboundLinks].
  NoteOutboundLinksProvider call(
    String noteId,
  ) {
    return NoteOutboundLinksProvider(
      noteId,
    );
  }

  @override
  NoteOutboundLinksProvider getProviderOverride(
    covariant NoteOutboundLinksProvider provider,
  ) {
    return call(
      provider.noteId,
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
  String? get name => r'noteOutboundLinksProvider';
}

/// 获取笔记的正向链接(这个笔记链接到了哪些笔记)
///
/// Copied from [noteOutboundLinks].
class NoteOutboundLinksProvider extends AutoDisposeFutureProvider<List<Note>> {
  /// 获取笔记的正向链接(这个笔记链接到了哪些笔记)
  ///
  /// Copied from [noteOutboundLinks].
  NoteOutboundLinksProvider(
    String noteId,
  ) : this._internal(
          (ref) => noteOutboundLinks(
            ref as NoteOutboundLinksRef,
            noteId,
          ),
          from: noteOutboundLinksProvider,
          name: r'noteOutboundLinksProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$noteOutboundLinksHash,
          dependencies: NoteOutboundLinksFamily._dependencies,
          allTransitiveDependencies:
              NoteOutboundLinksFamily._allTransitiveDependencies,
          noteId: noteId,
        );

  NoteOutboundLinksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.noteId,
  }) : super.internal();

  final String noteId;

  @override
  Override overrideWith(
    FutureOr<List<Note>> Function(NoteOutboundLinksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NoteOutboundLinksProvider._internal(
        (ref) => create(ref as NoteOutboundLinksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        noteId: noteId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Note>> createElement() {
    return _NoteOutboundLinksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NoteOutboundLinksProvider && other.noteId == noteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, noteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NoteOutboundLinksRef on AutoDisposeFutureProviderRef<List<Note>> {
  /// The parameter `noteId` of this provider.
  String get noteId;
}

class _NoteOutboundLinksProviderElement
    extends AutoDisposeFutureProviderElement<List<Note>>
    with NoteOutboundLinksRef {
  _NoteOutboundLinksProviderElement(super.provider);

  @override
  String get noteId => (origin as NoteOutboundLinksProvider).noteId;
}

String _$noteLinkStatsHash() => r'be726a6324a2977ccb06b9de8989727d2648dbfe';

/// 获取笔记的完整链接统计
///
/// Copied from [noteLinkStats].
@ProviderFor(noteLinkStats)
const noteLinkStatsProvider = NoteLinkStatsFamily();

/// 获取笔记的完整链接统计
///
/// Copied from [noteLinkStats].
class NoteLinkStatsFamily extends Family<AsyncValue<NoteLinkStats>> {
  /// 获取笔记的完整链接统计
  ///
  /// Copied from [noteLinkStats].
  const NoteLinkStatsFamily();

  /// 获取笔记的完整链接统计
  ///
  /// Copied from [noteLinkStats].
  NoteLinkStatsProvider call(
    String noteId,
  ) {
    return NoteLinkStatsProvider(
      noteId,
    );
  }

  @override
  NoteLinkStatsProvider getProviderOverride(
    covariant NoteLinkStatsProvider provider,
  ) {
    return call(
      provider.noteId,
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
  String? get name => r'noteLinkStatsProvider';
}

/// 获取笔记的完整链接统计
///
/// Copied from [noteLinkStats].
class NoteLinkStatsProvider extends AutoDisposeFutureProvider<NoteLinkStats> {
  /// 获取笔记的完整链接统计
  ///
  /// Copied from [noteLinkStats].
  NoteLinkStatsProvider(
    String noteId,
  ) : this._internal(
          (ref) => noteLinkStats(
            ref as NoteLinkStatsRef,
            noteId,
          ),
          from: noteLinkStatsProvider,
          name: r'noteLinkStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$noteLinkStatsHash,
          dependencies: NoteLinkStatsFamily._dependencies,
          allTransitiveDependencies:
              NoteLinkStatsFamily._allTransitiveDependencies,
          noteId: noteId,
        );

  NoteLinkStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.noteId,
  }) : super.internal();

  final String noteId;

  @override
  Override overrideWith(
    FutureOr<NoteLinkStats> Function(NoteLinkStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NoteLinkStatsProvider._internal(
        (ref) => create(ref as NoteLinkStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        noteId: noteId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<NoteLinkStats> createElement() {
    return _NoteLinkStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NoteLinkStatsProvider && other.noteId == noteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, noteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NoteLinkStatsRef on AutoDisposeFutureProviderRef<NoteLinkStats> {
  /// The parameter `noteId` of this provider.
  String get noteId;
}

class _NoteLinkStatsProviderElement
    extends AutoDisposeFutureProviderElement<NoteLinkStats>
    with NoteLinkStatsRef {
  _NoteLinkStatsProviderElement(super.provider);

  @override
  String get noteId => (origin as NoteLinkStatsProvider).noteId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
