// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Note _$NoteFromJson(Map<String, dynamic> json) {
  return _Note.fromJson(json);
}

/// @nodoc
mixin _$Note {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(2)
  String get content => throw _privateConstructorUsedError; // Markdown格式内容
  @HiveField(16)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(17)
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @HiveField(3)
  NoteCategory get category => throw _privateConstructorUsedError;
  @HiveField(4)
  List<String> get tags => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get isPinned => throw _privateConstructorUsedError; // 是否置顶
  @HiveField(6)
  bool get isFavorite => throw _privateConstructorUsedError; // 是否收藏
  @HiveField(7)
  bool get isArchived => throw _privateConstructorUsedError; // 是否归档
  @HiveField(8)
  String? get folderPath => throw _privateConstructorUsedError; // 文件夹路径(支持层级)
  @HiveField(9)
  List<String> get linkedTaskIds =>
      throw _privateConstructorUsedError; // 关联的任务ID
  @HiveField(10)
  List<String> get linkedNoteIds =>
      throw _privateConstructorUsedError; // 关联的笔记ID
  @HiveField(11)
  List<String> get imageUrls => throw _privateConstructorUsedError; // 图片URL列表
  @HiveField(12)
  List<String> get attachmentUrls =>
      throw _privateConstructorUsedError; // 附件URL列表
  @HiveField(13)
  String? get coverImageUrl => throw _privateConstructorUsedError; // 封面图片
  @HiveField(14)
  int? get wordCount => throw _privateConstructorUsedError; // 字数统计
  @HiveField(15)
  int? get readingTimeMinutes =>
      throw _privateConstructorUsedError; // 预计阅读时间(分钟)
  @HiveField(18)
  DateTime? get lastViewedAt => throw _privateConstructorUsedError; // 最后查看时间
  @HiveField(19)
  int get viewCount => throw _privateConstructorUsedError; // 查看次数
  @HiveField(20)
  int get version => throw _privateConstructorUsedError; // 版本号
  @HiveField(21)
  String? get ocrText => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NoteCopyWith<Note> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteCopyWith<$Res> {
  factory $NoteCopyWith(Note value, $Res Function(Note) then) =
      _$NoteCopyWithImpl<$Res, Note>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) String content,
      @HiveField(16) DateTime createdAt,
      @HiveField(17) DateTime updatedAt,
      @HiveField(3) NoteCategory category,
      @HiveField(4) List<String> tags,
      @HiveField(5) bool isPinned,
      @HiveField(6) bool isFavorite,
      @HiveField(7) bool isArchived,
      @HiveField(8) String? folderPath,
      @HiveField(9) List<String> linkedTaskIds,
      @HiveField(10) List<String> linkedNoteIds,
      @HiveField(11) List<String> imageUrls,
      @HiveField(12) List<String> attachmentUrls,
      @HiveField(13) String? coverImageUrl,
      @HiveField(14) int? wordCount,
      @HiveField(15) int? readingTimeMinutes,
      @HiveField(18) DateTime? lastViewedAt,
      @HiveField(19) int viewCount,
      @HiveField(20) int version,
      @HiveField(21) String? ocrText});
}

/// @nodoc
class _$NoteCopyWithImpl<$Res, $Val extends Note>
    implements $NoteCopyWith<$Res> {
  _$NoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? category = null,
    Object? tags = null,
    Object? isPinned = null,
    Object? isFavorite = null,
    Object? isArchived = null,
    Object? folderPath = freezed,
    Object? linkedTaskIds = null,
    Object? linkedNoteIds = null,
    Object? imageUrls = null,
    Object? attachmentUrls = null,
    Object? coverImageUrl = freezed,
    Object? wordCount = freezed,
    Object? readingTimeMinutes = freezed,
    Object? lastViewedAt = freezed,
    Object? viewCount = null,
    Object? version = null,
    Object? ocrText = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as NoteCategory,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      folderPath: freezed == folderPath
          ? _value.folderPath
          : folderPath // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedTaskIds: null == linkedTaskIds
          ? _value.linkedTaskIds
          : linkedTaskIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      linkedNoteIds: null == linkedNoteIds
          ? _value.linkedNoteIds
          : linkedNoteIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      attachmentUrls: null == attachmentUrls
          ? _value.attachmentUrls
          : attachmentUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      wordCount: freezed == wordCount
          ? _value.wordCount
          : wordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      readingTimeMinutes: freezed == readingTimeMinutes
          ? _value.readingTimeMinutes
          : readingTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      lastViewedAt: freezed == lastViewedAt
          ? _value.lastViewedAt
          : lastViewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      ocrText: freezed == ocrText
          ? _value.ocrText
          : ocrText // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoteImplCopyWith<$Res> implements $NoteCopyWith<$Res> {
  factory _$$NoteImplCopyWith(
          _$NoteImpl value, $Res Function(_$NoteImpl) then) =
      __$$NoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) String content,
      @HiveField(16) DateTime createdAt,
      @HiveField(17) DateTime updatedAt,
      @HiveField(3) NoteCategory category,
      @HiveField(4) List<String> tags,
      @HiveField(5) bool isPinned,
      @HiveField(6) bool isFavorite,
      @HiveField(7) bool isArchived,
      @HiveField(8) String? folderPath,
      @HiveField(9) List<String> linkedTaskIds,
      @HiveField(10) List<String> linkedNoteIds,
      @HiveField(11) List<String> imageUrls,
      @HiveField(12) List<String> attachmentUrls,
      @HiveField(13) String? coverImageUrl,
      @HiveField(14) int? wordCount,
      @HiveField(15) int? readingTimeMinutes,
      @HiveField(18) DateTime? lastViewedAt,
      @HiveField(19) int viewCount,
      @HiveField(20) int version,
      @HiveField(21) String? ocrText});
}

/// @nodoc
class __$$NoteImplCopyWithImpl<$Res>
    extends _$NoteCopyWithImpl<$Res, _$NoteImpl>
    implements _$$NoteImplCopyWith<$Res> {
  __$$NoteImplCopyWithImpl(_$NoteImpl _value, $Res Function(_$NoteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? category = null,
    Object? tags = null,
    Object? isPinned = null,
    Object? isFavorite = null,
    Object? isArchived = null,
    Object? folderPath = freezed,
    Object? linkedTaskIds = null,
    Object? linkedNoteIds = null,
    Object? imageUrls = null,
    Object? attachmentUrls = null,
    Object? coverImageUrl = freezed,
    Object? wordCount = freezed,
    Object? readingTimeMinutes = freezed,
    Object? lastViewedAt = freezed,
    Object? viewCount = null,
    Object? version = null,
    Object? ocrText = freezed,
  }) {
    return _then(_$NoteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as NoteCategory,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      folderPath: freezed == folderPath
          ? _value.folderPath
          : folderPath // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedTaskIds: null == linkedTaskIds
          ? _value._linkedTaskIds
          : linkedTaskIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      linkedNoteIds: null == linkedNoteIds
          ? _value._linkedNoteIds
          : linkedNoteIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      attachmentUrls: null == attachmentUrls
          ? _value._attachmentUrls
          : attachmentUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      wordCount: freezed == wordCount
          ? _value.wordCount
          : wordCount // ignore: cast_nullable_to_non_nullable
              as int?,
      readingTimeMinutes: freezed == readingTimeMinutes
          ? _value.readingTimeMinutes
          : readingTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      lastViewedAt: freezed == lastViewedAt
          ? _value.lastViewedAt
          : lastViewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      ocrText: freezed == ocrText
          ? _value.ocrText
          : ocrText // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NoteImpl extends _Note {
  const _$NoteImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(2) required this.content,
      @HiveField(16) required this.createdAt,
      @HiveField(17) required this.updatedAt,
      @HiveField(3) this.category = NoteCategory.general,
      @HiveField(4) final List<String> tags = const <String>[],
      @HiveField(5) this.isPinned = false,
      @HiveField(6) this.isFavorite = false,
      @HiveField(7) this.isArchived = false,
      @HiveField(8) this.folderPath,
      @HiveField(9) final List<String> linkedTaskIds = const <String>[],
      @HiveField(10) final List<String> linkedNoteIds = const <String>[],
      @HiveField(11) final List<String> imageUrls = const <String>[],
      @HiveField(12) final List<String> attachmentUrls = const <String>[],
      @HiveField(13) this.coverImageUrl,
      @HiveField(14) this.wordCount,
      @HiveField(15) this.readingTimeMinutes,
      @HiveField(18) this.lastViewedAt,
      @HiveField(19) this.viewCount = 0,
      @HiveField(20) this.version = 0,
      @HiveField(21) this.ocrText})
      : _tags = tags,
        _linkedTaskIds = linkedTaskIds,
        _linkedNoteIds = linkedNoteIds,
        _imageUrls = imageUrls,
        _attachmentUrls = attachmentUrls,
        super._();

  factory _$NoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final String content;
// Markdown格式内容
  @override
  @HiveField(16)
  final DateTime createdAt;
  @override
  @HiveField(17)
  final DateTime updatedAt;
  @override
  @JsonKey()
  @HiveField(3)
  final NoteCategory category;
  final List<String> _tags;
  @override
  @JsonKey()
  @HiveField(4)
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  @HiveField(5)
  final bool isPinned;
// 是否置顶
  @override
  @JsonKey()
  @HiveField(6)
  final bool isFavorite;
// 是否收藏
  @override
  @JsonKey()
  @HiveField(7)
  final bool isArchived;
// 是否归档
  @override
  @HiveField(8)
  final String? folderPath;
// 文件夹路径(支持层级)
  final List<String> _linkedTaskIds;
// 文件夹路径(支持层级)
  @override
  @JsonKey()
  @HiveField(9)
  List<String> get linkedTaskIds {
    if (_linkedTaskIds is EqualUnmodifiableListView) return _linkedTaskIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_linkedTaskIds);
  }

// 关联的任务ID
  final List<String> _linkedNoteIds;
// 关联的任务ID
  @override
  @JsonKey()
  @HiveField(10)
  List<String> get linkedNoteIds {
    if (_linkedNoteIds is EqualUnmodifiableListView) return _linkedNoteIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_linkedNoteIds);
  }

// 关联的笔记ID
  final List<String> _imageUrls;
// 关联的笔记ID
  @override
  @JsonKey()
  @HiveField(11)
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

// 图片URL列表
  final List<String> _attachmentUrls;
// 图片URL列表
  @override
  @JsonKey()
  @HiveField(12)
  List<String> get attachmentUrls {
    if (_attachmentUrls is EqualUnmodifiableListView) return _attachmentUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachmentUrls);
  }

// 附件URL列表
  @override
  @HiveField(13)
  final String? coverImageUrl;
// 封面图片
  @override
  @HiveField(14)
  final int? wordCount;
// 字数统计
  @override
  @HiveField(15)
  final int? readingTimeMinutes;
// 预计阅读时间(分钟)
  @override
  @HiveField(18)
  final DateTime? lastViewedAt;
// 最后查看时间
  @override
  @JsonKey()
  @HiveField(19)
  final int viewCount;
// 查看次数
  @override
  @JsonKey()
  @HiveField(20)
  final int version;
// 版本号
  @override
  @HiveField(21)
  final String? ocrText;

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, category: $category, tags: $tags, isPinned: $isPinned, isFavorite: $isFavorite, isArchived: $isArchived, folderPath: $folderPath, linkedTaskIds: $linkedTaskIds, linkedNoteIds: $linkedNoteIds, imageUrls: $imageUrls, attachmentUrls: $attachmentUrls, coverImageUrl: $coverImageUrl, wordCount: $wordCount, readingTimeMinutes: $readingTimeMinutes, lastViewedAt: $lastViewedAt, viewCount: $viewCount, version: $version, ocrText: $ocrText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.folderPath, folderPath) ||
                other.folderPath == folderPath) &&
            const DeepCollectionEquality()
                .equals(other._linkedTaskIds, _linkedTaskIds) &&
            const DeepCollectionEquality()
                .equals(other._linkedNoteIds, _linkedNoteIds) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            const DeepCollectionEquality()
                .equals(other._attachmentUrls, _attachmentUrls) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.wordCount, wordCount) ||
                other.wordCount == wordCount) &&
            (identical(other.readingTimeMinutes, readingTimeMinutes) ||
                other.readingTimeMinutes == readingTimeMinutes) &&
            (identical(other.lastViewedAt, lastViewedAt) ||
                other.lastViewedAt == lastViewedAt) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.ocrText, ocrText) || other.ocrText == ocrText));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        content,
        createdAt,
        updatedAt,
        category,
        const DeepCollectionEquality().hash(_tags),
        isPinned,
        isFavorite,
        isArchived,
        folderPath,
        const DeepCollectionEquality().hash(_linkedTaskIds),
        const DeepCollectionEquality().hash(_linkedNoteIds),
        const DeepCollectionEquality().hash(_imageUrls),
        const DeepCollectionEquality().hash(_attachmentUrls),
        coverImageUrl,
        wordCount,
        readingTimeMinutes,
        lastViewedAt,
        viewCount,
        version,
        ocrText
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
      __$$NoteImplCopyWithImpl<_$NoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteImplToJson(
      this,
    );
  }
}

abstract class _Note extends Note {
  const factory _Note(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String title,
      @HiveField(2) required final String content,
      @HiveField(16) required final DateTime createdAt,
      @HiveField(17) required final DateTime updatedAt,
      @HiveField(3) final NoteCategory category,
      @HiveField(4) final List<String> tags,
      @HiveField(5) final bool isPinned,
      @HiveField(6) final bool isFavorite,
      @HiveField(7) final bool isArchived,
      @HiveField(8) final String? folderPath,
      @HiveField(9) final List<String> linkedTaskIds,
      @HiveField(10) final List<String> linkedNoteIds,
      @HiveField(11) final List<String> imageUrls,
      @HiveField(12) final List<String> attachmentUrls,
      @HiveField(13) final String? coverImageUrl,
      @HiveField(14) final int? wordCount,
      @HiveField(15) final int? readingTimeMinutes,
      @HiveField(18) final DateTime? lastViewedAt,
      @HiveField(19) final int viewCount,
      @HiveField(20) final int version,
      @HiveField(21) final String? ocrText}) = _$NoteImpl;
  const _Note._() : super._();

  factory _Note.fromJson(Map<String, dynamic> json) = _$NoteImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get title;
  @override
  @HiveField(2)
  String get content;
  @override // Markdown格式内容
  @HiveField(16)
  DateTime get createdAt;
  @override
  @HiveField(17)
  DateTime get updatedAt;
  @override
  @HiveField(3)
  NoteCategory get category;
  @override
  @HiveField(4)
  List<String> get tags;
  @override
  @HiveField(5)
  bool get isPinned;
  @override // 是否置顶
  @HiveField(6)
  bool get isFavorite;
  @override // 是否收藏
  @HiveField(7)
  bool get isArchived;
  @override // 是否归档
  @HiveField(8)
  String? get folderPath;
  @override // 文件夹路径(支持层级)
  @HiveField(9)
  List<String> get linkedTaskIds;
  @override // 关联的任务ID
  @HiveField(10)
  List<String> get linkedNoteIds;
  @override // 关联的笔记ID
  @HiveField(11)
  List<String> get imageUrls;
  @override // 图片URL列表
  @HiveField(12)
  List<String> get attachmentUrls;
  @override // 附件URL列表
  @HiveField(13)
  String? get coverImageUrl;
  @override // 封面图片
  @HiveField(14)
  int? get wordCount;
  @override // 字数统计
  @HiveField(15)
  int? get readingTimeMinutes;
  @override // 预计阅读时间(分钟)
  @HiveField(18)
  DateTime? get lastViewedAt;
  @override // 最后查看时间
  @HiveField(19)
  int get viewCount;
  @override // 查看次数
  @HiveField(20)
  int get version;
  @override // 版本号
  @HiveField(21)
  String? get ocrText;
  @override
  @JsonKey(ignore: true)
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
