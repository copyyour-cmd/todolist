import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/domain/entities/note.dart';
import 'package:todolist/src/features/notes/application/note_providers.dart';
import 'package:todolist/src/features/notes/application/note_service.dart';
import 'package:todolist/src/features/notes/data/note_template_service.dart';
import 'package:todolist/src/features/notes/domain/note_template.dart';
import 'package:todolist/src/features/notes/presentation/note_editor_page.dart';
import 'package:todolist/src/features/notes/presentation/note_search_page.dart';
import 'package:todolist/src/features/notes/presentation/widgets/gesture_note_card.dart';
import 'package:todolist/src/features/notes/presentation/widgets/quick_note_dialog.dart';
import 'package:todolist/src/features/notes/presentation/widgets/template_selector_dialog.dart';
import 'package:todolist/src/features/notes/presentation/widgets/zoomable_note_preview.dart';
import 'package:todolist/src/features/notes/presentation/widgets/folder_tree_view.dart';
import 'package:todolist/src/features/notes/data/note_folder_service.dart';
import 'package:todolist/src/features/notes/domain/note_folder.dart';
import 'package:todolist/src/features/notes/presentation/widgets/folder_editor_dialog.dart';

class NotesListPage extends ConsumerStatefulWidget {
  const NotesListPage({super.key});

  static const routeName = 'notes';
  static const routePath = '/notes';

  @override
  ConsumerState<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends ConsumerState<NotesListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  NoteCategory? _selectedCategory;
  bool _isSelectionMode = false;
  final Set<String> _selectedNotes = {};

  // 文件夹视图相关状态
  ViewMode _viewMode = ViewMode.list;
  String? _selectedFolderId;
  NoteFolderService? _folderService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initFolderService();
  }

  Future<void> _initFolderService() async {
    _folderService = NoteFolderService();
    await _folderService!.init();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: _isSelectionMode
          ? _buildSelectionAppBar()
          : _buildNormalAppBar(),
      body: _viewMode == ViewMode.list
          ? TabBarView(
              controller: _tabController,
              children: [
                _buildNotesList(NoteListType.all),
                _buildNotesList(NoteListType.favorite),
                _buildNotesList(NoteListType.pinned),
                _buildNotesList(NoteListType.archived),
              ],
            )
          : _buildFolderView(),
      floatingActionButton: _isSelectionMode
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 快速笔记按钮
                FloatingActionButton.small(
                  heroTag: 'quick',
                  onPressed: _showQuickNoteDialog,
                  tooltip: '快速笔记',
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.flash_on),
                ),
                const SizedBox(height: 12),
                // 模板按钮
                FloatingActionButton.small(
                  heroTag: 'template',
                  onPressed: () => _createNoteFromTemplate(),
                  tooltip: '使用模板',
                  child: const Icon(Icons.description_outlined),
                ),
                const SizedBox(height: 12),
                // 新建按钮
                FloatingActionButton.extended(
                  heroTag: 'new',
                  onPressed: () => _createNewNote(),
                  icon: const Icon(Icons.add),
                  label: const Text('新建笔记'),
                ),
              ],
            ),
    );
  }

  PreferredSizeWidget _buildNormalAppBar() {
    return AppBar(
      title: const Text('笔记'),
      actions: [
          // 视图切换按钮
          IconButton(
            icon: Icon(_viewMode == ViewMode.list
                ? Icons.folder_outlined
                : Icons.list),
            onPressed: () {
              setState(() {
                _viewMode =
                    _viewMode == ViewMode.list ? ViewMode.folder : ViewMode.list;
                if (_viewMode == ViewMode.list) {
                  _selectedFolderId = null; // 切换到列表视图时清除文件夹选择
                }
              });
            },
            tooltip: _viewMode == ViewMode.list ? '文件夹视图' : '列表视图',
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.push('/notes/statistics'),
            tooltip: '统计分析',
          ),
          IconButton(
            icon: const Icon(Icons.hub_rounded),
            onPressed: () => context.push('/knowledge-graph'),
            tooltip: '知识图谱',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push(NoteSearchPage.routePath),
            tooltip: '搜索笔记',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: '筛选',
            onSelected: (value) {
              setState(() {
                if (value == 'all') {
                  _selectedCategory = null;
                } else {
                  _selectedCategory = NoteCategory.values.firstWhere(
                    (c) => c.name == value,
                  );
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Row(
                  children: [
                    Icon(Icons.all_inclusive),
                    SizedBox(width: 12),
                    Text('全部分类'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              ...NoteCategory.values.map((category) {
                final note = Note(
                  id: '',
                  title: '',
                  content: '',
                  category: category,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                return PopupMenuItem(
                  value: category.name,
                  child: Row(
                    children: [
                      Text(note.getCategoryIcon(), style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Text(note.getCategoryName()),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '全部', icon: Icon(Icons.note, size: 18)),
            Tab(text: '收藏', icon: Icon(Icons.star, size: 18)),
            Tab(text: '置顶', icon: Icon(Icons.push_pin, size: 18)),
            Tab(text: '归档', icon: Icon(Icons.archive, size: 18)),
          ],
        ),
      );
  }

  PreferredSizeWidget _buildSelectionAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          setState(() {
            _isSelectionMode = false;
            _selectedNotes.clear();
          });
        },
      ),
      title: Text('已选择 ${_selectedNotes.length} 项'),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _selectedNotes.isEmpty ? null : _batchDelete,
          tooltip: '删除',
        ),
        IconButton(
          icon: const Icon(Icons.archive),
          onPressed: _selectedNotes.isEmpty ? null : _batchArchive,
          tooltip: '归档',
        ),
        PopupMenuButton<String>(
          enabled: _selectedNotes.isNotEmpty,
          onSelected: (value) {
            switch (value) {
              case 'favorite':
                _batchToggleFavorite();
                break;
              case 'pin':
                _batchTogglePin();
                break;
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'favorite',
              child: Row(
                children: [
                  Icon(Icons.star),
                  SizedBox(width: 12),
                  Text('收藏'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'pin',
              child: Row(
                children: [
                  Icon(Icons.push_pin),
                  SizedBox(width: 12),
                  Text('置顶'),
                ],
              ),
            ),
          ],
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: '全部', icon: Icon(Icons.note, size: 18)),
          Tab(text: '收藏', icon: Icon(Icons.star, size: 18)),
          Tab(text: '置顶', icon: Icon(Icons.push_pin, size: 18)),
          Tab(text: '归档', icon: Icon(Icons.archive, size: 18)),
        ],
      ),
    );
  }


  /// 构建文件夹视图
  Widget _buildFolderView() {
    if (_folderService == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final notesAsync = ref.watch(notesProvider);

    return Row(
      children: [
        // 左侧文件夹树
        SizedBox(
          width: 250,
          child: Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                // 文件夹管理头部
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('文件夹'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _showCreateFolderDialog,
                    tooltip: '新建文件夹',
                  ),
                ),
                const Divider(height: 1),
                // 文件夹树视图
                Expanded(
                  child: FolderTreeView(
                    folderService: _folderService!,
                    selectedFolderId: _selectedFolderId,
                    onFolderSelected: (folderId) {
                      setState(() {
                        _selectedFolderId = folderId;
                      });
                    },
                    onFolderLongPress: (folder) {
                      _showFolderMenu(folder.id);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // 右侧笔记列表
        Expanded(
          child: notesAsync.when(
            data: (notes) {
              // 根据选中的文件夹过滤笔记
              var filteredNotes = notes;
              if (_selectedFolderId == null) {
                // 显示所有笔记
                filteredNotes = notes;
              } else {
                // 显示特定文件夹的笔记
                final folderPath = _folderService!.getFolderPathString(_selectedFolderId!);
                filteredNotes =
                    notes.where((note) => note.folderPath == folderPath).toList();
              }

              // 应用分类筛选
              if (_selectedCategory != null) {
                filteredNotes = filteredNotes
                    .where((note) => note.category == _selectedCategory)
                    .toList();
              }

              if (filteredNotes.isEmpty) {
                return _buildEmptyFolderState();
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(notesProvider);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = filteredNotes[index];
                    return GestureNoteCard(
                      note: note,
                      isSelected: _selectedNotes.contains(note.id),
                      isSelectionMode: _isSelectionMode,
                      onTap: () {
                        if (_isSelectionMode) {
                          _toggleSelection(note.id);
                        } else {
                          _openNote(note);
                        }
                      },
                      onDoubleTap: () => _openNoteEditor(note),
                      onLongPress: () {
                        if (!_isSelectionMode) {
                          setState(() {
                            _isSelectionMode = true;
                            _selectedNotes.add(note.id);
                          });
                        }
                      },
                      onDelete: () async {
                        final service = ref.read(noteServiceProvider);
                        await service.deleteNote(note.id);
                        ref.invalidate(notesProvider);
                      },
                      onArchive: () async {
                        final service = ref.read(noteServiceProvider);
                        if (note.isArchived) {
                          await service.unarchiveNote(note);
                        } else {
                          await service.archiveNote(note);
                        }
                        ref.invalidate(notesProvider);
                      },
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('加载失败: $error'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyFolderState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open,
              size: 72, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text('此文件夹没有笔记',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '创建新笔记或移动现有笔记到此文件夹',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList(NoteListType type) {
    final notesAsync = _getNotesProvider(type);

    return notesAsync.when(
      data: (notes) {
        // 应用分类筛选
        var filteredNotes = notes;
        if (_selectedCategory != null) {
          filteredNotes = notes
              .where((note) => note.category == _selectedCategory)
              .toList();
        }

        // 应用搜索筛选
        if (_searchQuery.isNotEmpty) {
          filteredNotes = filteredNotes.where((note) {
            final query = _searchQuery.toLowerCase();
            return note.title.toLowerCase().contains(query) ||
                note.content.toLowerCase().contains(query);
          }).toList();
        }

        if (filteredNotes.isEmpty) {
          return _buildEmptyState(type);
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(notesProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8),
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              final note = filteredNotes[index];
              return GestureNoteCard(
                note: note,
                isSelected: _selectedNotes.contains(note.id),
                isSelectionMode: _isSelectionMode,
                onTap: () {
                  if (_isSelectionMode) {
                    _toggleSelection(note.id);
                  } else {
                    _openNote(note);
                  }
                },
                onDoubleTap: () => _openNoteEditor(note),
                onLongPress: () {
                  if (!_isSelectionMode) {
                    setState(() {
                      _isSelectionMode = true;
                      _selectedNotes.add(note.id);
                    });
                  }
                },
                onDelete: () async {
                  final service = ref.read(noteServiceProvider);
                  await service.deleteNote(note.id);
                  ref.invalidate(notesProvider);
                },
                onArchive: () async {
                  final service = ref.read(noteServiceProvider);
                  if (note.isArchived) {
                    await service.unarchiveNote(note);
                  } else {
                    await service.archiveNote(note);
                  }
                  ref.invalidate(notesProvider);
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('加载失败: $error'),
          ],
        ),
      ),
    );
  }

  AsyncValue<List<Note>> _getNotesProvider(NoteListType type) {
    switch (type) {
      case NoteListType.all:
        return ref.watch(notesProvider);
      case NoteListType.favorite:
        return ref.watch(favoriteNotesProvider);
      case NoteListType.pinned:
        return ref.watch(pinnedNotesProvider);
      case NoteListType.archived:
        return ref.watch(archivedNotesProvider);
    }
  }

  Widget _buildEmptyState(NoteListType type) {
    String title, subtitle;
    IconData icon;

    switch (type) {
      case NoteListType.all:
        icon = Icons.note_add_outlined;
        title = '还没有笔记';
        subtitle = '点击下方按钮创建第一条笔记';
        break;
      case NoteListType.favorite:
        icon = Icons.star_outline;
        title = '没有收藏的笔记';
        subtitle = '收藏重要的笔记以便快速访问';
        break;
      case NoteListType.pinned:
        icon = Icons.push_pin_outlined;
        title = '没有置顶的笔记';
        subtitle = '置顶常用笔记显示在列表顶部';
        break;
      case NoteListType.archived:
        icon = Icons.archive_outlined;
        title = '没有归档的笔记';
        subtitle = '归档不常用的笔记以保持列表整洁';
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 72, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _createNewNote() {
    context.push(NoteEditorPage.routePath);
  }

  void _showQuickNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => const QuickNoteDialog(),
    );
  }

  Future<void> _createNoteFromTemplate() async {
    // 初始化模板服务
    final templateService = NoteTemplateService();
    await templateService.init();

    // 获取模板列表
    final presetTemplates = templateService.getPresetTemplates();
    final customTemplates = templateService.getCustomTemplates();

    if (mounted) {
      // 显示模板选择对话框
      final selectedTemplate = await showDialog<NoteTemplate>(
        context: context,
        builder: (context) => TemplateSelectorDialog(
          presetTemplates: presetTemplates,
          customTemplates: customTemplates,
        ),
      );

      // 如果选择了模板，跳转到编辑器并应用模板
      if (selectedTemplate != null && mounted) {
        // 直接导航到编辑器，传递模板参数
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NoteEditorPage(template: selectedTemplate),
          ),
        );
        // 刷新笔记列表
        ref.invalidate(notesProvider);
      }
    }
  }

  void _openNote(Note note) {
    // Open zoomable preview
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ZoomableNotePreview(note: note),
        fullscreenDialog: true,
      ),
    );
  }

  void _openNoteEditor(Note note) {
    context.push('${NotesListPage.routePath}/${note.id}');
  }

  void _toggleSelection(String noteId) {
    setState(() {
      if (_selectedNotes.contains(noteId)) {
        _selectedNotes.remove(noteId);
        if (_selectedNotes.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedNotes.add(noteId);
      }
    });
  }

  Future<void> _batchDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('批量删除'),
        content: Text('确定要删除选中的 ${_selectedNotes.length} 条笔记吗？此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(noteServiceProvider);
      for (final noteId in _selectedNotes) {
        await service.deleteNote(noteId);
      }
      ref.invalidate(notesProvider);
      setState(() {
        _isSelectionMode = false;
        _selectedNotes.clear();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已删除 ${_selectedNotes.length} 条笔记')),
        );
      }
    }
  }

  Future<void> _batchArchive() async {
    final service = ref.read(noteServiceProvider);
    final notesAsync = await ref.read(notesProvider.future);

    for (final noteId in _selectedNotes) {
      final note = notesAsync.firstWhere((n) => n.id == noteId);
      if (!note.isArchived) {
        await service.archiveNote(note);
      }
    }

    ref.invalidate(notesProvider);
    setState(() {
      _isSelectionMode = false;
      _selectedNotes.clear();
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已归档选中的笔记')),
      );
    }
  }

  Future<void> _batchToggleFavorite() async {
    final service = ref.read(noteServiceProvider);
    final notesAsync = await ref.read(notesProvider.future);

    for (final noteId in _selectedNotes) {
      final note = notesAsync.firstWhere((n) => n.id == noteId);
      await service.toggleFavorite(note);
    }

    ref.invalidate(notesProvider);
    setState(() {
      _isSelectionMode = false;
      _selectedNotes.clear();
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已更新收藏状态')),
      );
    }
  }

  Future<void> _batchTogglePin() async {
    final service = ref.read(noteServiceProvider);
    final notesAsync = await ref.read(notesProvider.future);

    for (final noteId in _selectedNotes) {
      final note = notesAsync.firstWhere((n) => n.id == noteId);
      await service.togglePin(note);
    }

    ref.invalidate(notesProvider);
    setState(() {
      _isSelectionMode = false;
      _selectedNotes.clear();
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已更新置顶状态')),
      );
    }
  }

  void _showNoteMenu(Note note) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.drive_file_move, color: Colors.teal),
              title: const Text('移至文件夹'),
              onTap: () async {
                Navigator.pop(context);
                _showMoveToFolderDialog(note);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                note.isFavorite ? Icons.star : Icons.star_outline,
                color: Colors.amber,
              ),
              title: Text(note.isFavorite ? '取消收藏' : '收藏'),
              onTap: () async {
                Navigator.pop(context);
                final service = ref.read(noteServiceProvider);
                await service.toggleFavorite(note);
                ref.invalidate(notesProvider);
              },
            ),
            ListTile(
              leading: Icon(
                note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: Colors.blue,
              ),
              title: Text(note.isPinned ? '取消置顶' : '置顶'),
              onTap: () async {
                Navigator.pop(context);
                final service = ref.read(noteServiceProvider);
                await service.togglePin(note);
                ref.invalidate(notesProvider);
              },
            ),
            ListTile(
              leading: Icon(
                note.isArchived ? Icons.unarchive : Icons.archive,
                color: Colors.green,
              ),
              title: Text(note.isArchived ? '取消归档' : '归档'),
              onTap: () async {
                Navigator.pop(context);
                final service = ref.read(noteServiceProvider);
                if (note.isArchived) {
                  await service.unarchiveNote(note);
                } else {
                  await service.archiveNote(note);
                }
                ref.invalidate(notesProvider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: Colors.purple),
              title: const Text('复制'),
              onTap: () async {
                Navigator.pop(context);
                final service = ref.read(noteServiceProvider);
                await service.duplicateNote(note);
                ref.invalidate(notesProvider);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('笔记已复制')),
                  );
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('删除', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('确认删除'),
                    content: Text('确定要删除笔记"${note.title}"吗？此操作无法撤销。'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('取消'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('删除'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  final service = ref.read(noteServiceProvider);
                  await service.deleteNote(note.id);
                  ref.invalidate(notesProvider);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('笔记已删除')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 显示移动到文件夹对话框
  Future<void> _showMoveToFolderDialog(Note note) async {
    if (_folderService == null) {
      await _initFolderService();
    }
    if (_folderService == null) return;

    final folders = _folderService!.getAllFolders();

    if (!mounted) return;

    final selectedFolderId = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('移至文件夹'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 根目录选项
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('根目录'),
                onTap: () => Navigator.pop(context, ''), // 空字符串表示根目录
              ),
              const Divider(),
              // 文件夹列表
              ...folders.map((folder) {
                return ListTile(
                  leading: Icon(
                    Icons.folder,
                    color: folder.color != null
                        ? Color(folder.color!)
                        : Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(folder.name),
                  subtitle: _folderService!.getFolderPathString(folder.id).isNotEmpty
                      ? Text(_folderService!.getFolderPathString(folder.id))
                      : null,
                  onTap: () => Navigator.pop(context, folder.id),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );

    // 如果用户选择了文件夹,执行移动操作
    if (selectedFolderId != null && mounted) {
      final service = ref.read(noteServiceProvider);
      final targetFolder = selectedFolderId.isEmpty
          ? null
          : folders.firstWhere((f) => f.id == selectedFolderId);

      final targetPath = targetFolder != null
          ? _folderService!.getFolderPathString(targetFolder.id)
          : '';

      final updatedNote = note.copyWith(
        folderPath: targetPath,
      );

      final updateInput = NoteUpdateInput(
        title: updatedNote.title,
        content: updatedNote.content,
        folderPath: targetPath,
      );

      await service.updateNote(updatedNote, updateInput);
      ref.invalidate(notesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              targetFolder == null
                  ? '笔记已移至根目录'
                  : '笔记已移至 ${targetFolder.name}',
            ),
          ),
        );
      }
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('搜索笔记'),
        content: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '输入关键词搜索标题或内容',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('清除'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示创建文件夹对话框
  Future<void> _showCreateFolderDialog() async {
    if (_folderService == null) return;

    final result = await showDialog<FolderEditorResult?>(
      context: context,
      builder: (context) => const FolderEditorDialog(),
    );

    if (result != null && mounted) {
      final newFolder = NoteFolder.create(
        name: result.name,
        icon: result.icon,
        color: result.color,
      );
      await _folderService!.addFolder(newFolder);
      setState(() {});
    }
  }

  /// 显示文件夹菜单
  void _showFolderMenu(String? folderId) {
    if (_folderService == null || folderId == null) return;

    final folder =
        _folderService!.getAllFolders().firstWhere((f) => f.id == folderId);

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('重命名'),
              onTap: () async {
                Navigator.pop(context);
                final result = await showDialog<FolderEditorResult?>(
                  context: context,
                  builder: (context) => FolderEditorDialog(
                    folder: folder,
                  ),
                );
                if (result != null && mounted) {
                  final updatedFolder = folder.copyWith(
                    name: result.name,
                    icon: result.icon,
                    color: result.color,
                  );
                  await _folderService!.updateFolder(updatedFolder);
                  setState(() {});
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.create_new_folder, color: Colors.green),
              title: const Text('新建子文件夹'),
              onTap: () async {
                Navigator.pop(context);
                final result = await showDialog<FolderEditorResult?>(
                  context: context,
                  builder: (context) => FolderEditorDialog(
                    parentId: folder.id,
                  ),
                );
                if (result != null && mounted) {
                  final newFolder = NoteFolder.create(
                    name: result.name,
                    icon: result.icon,
                    color: result.color,
                    parentId: folder.id,
                  );
                  await _folderService!.addFolder(newFolder);
                  setState(() {});
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.palette, color: Colors.purple),
              title: const Text('更改颜色'),
              onTap: () async {
                Navigator.pop(context);
                final result = await showDialog<FolderEditorResult?>(
                  context: context,
                  builder: (context) => FolderEditorDialog(
                    folder: folder,
                  ),
                );
                if (result != null && mounted) {
                  final updatedFolder = folder.copyWith(
                    name: result.name,
                    icon: result.icon,
                    color: result.color,
                  );
                  await _folderService!.updateFolder(updatedFolder);
                  setState(() {});
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('删除', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('确认删除'),
                    content: Text('确定要删除文件夹"${folder.name}"吗？\n此文件夹中的笔记将被移至根目录。'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('取消'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('删除'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && mounted) {
                  await _folderService!.deleteFolder(folder.id);
                  setState(() {
                    if (_selectedFolderId == folder.id) {
                      _selectedFolderId = null;
                    }
                  });
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('文件夹已删除')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.note,
    required this.onTap,
    required this.onLongPress,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题行
              Row(
                children: [
                  Text(
                    note.getCategoryIcon(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      note.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (note.isFavorite)
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                  if (note.isPinned)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.push_pin, size: 16, color: Colors.blue),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // 预览内容
              Text(
                note.getPreviewText(maxLength: 100),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // 标签
              if (note.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: note.tags.take(3).map((tag) {
                    return Chip(
                      label: Text(
                        '#$tag',
                        style: theme.textTheme.bodySmall,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              const SizedBox(height: 8),

              // 底部信息
              Row(
                children: [
                  Icon(
                    Icons.subject,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${note.wordCount ?? 0}字',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.visibility,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${note.viewCount}次',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatTime(note.updatedAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return DateFormat('MM-dd HH:mm').format(time);
    }
  }
}

enum NoteListType {
  all,
  favorite,
  pinned,
  archived,
}

enum ViewMode {
  list,
  folder,
}
