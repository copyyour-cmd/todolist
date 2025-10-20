import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/domain/entities/task_list.dart';
import 'package:todolist/src/features/lists/application/list_service.dart';

class ListFormDialog extends ConsumerStatefulWidget {
  const ListFormDialog({super.key, this.initialList});

  final TaskList? initialList;

  static Future<TaskList?> show(
    BuildContext context, {
    TaskList? list,
  }) {
    return showDialog<TaskList>(
      context: context,
      builder: (context) => ListFormDialog(initialList: list),
    );
  }

  @override
  ConsumerState<ListFormDialog> createState() => _ListFormDialogState();
}

class _ListFormDialogState extends ConsumerState<ListFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  String? _selectedIcon;
  String _selectedColor = '#4C83FB';
  bool _isSaving = false;

  // Common Material Icons for lists
  static const _availableIcons = [
    'inbox',
    'work',
    'home',
    'shopping_cart',
    'favorite',
    'star',
    'calendar_today',
    'school',
    'fitness_center',
    'restaurant',
    'flight',
    'lightbulb',
    'brush',
    'music_note',
    'sports_soccer',
  ];

  static const _availableColors = [
    '#4C83FB', // Blue
    '#F97316', // Orange
    '#10B981', // Green
    '#8B5CF6', // Purple
    '#EC4899', // Pink
    '#EF4444', // Red
    '#F59E0B', // Amber
    '#06B6D4', // Cyan
    '#84CC16', // Lime
    '#6366F1', // Indigo
  ];

  @override
  void initState() {
    super.initState();
    final list = widget.initialList;
    _nameController = TextEditingController(text: list?.name ?? '');
    _selectedIcon = list?.iconName;
    _selectedColor = list?.colorHex ?? '#4C83FB';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isEditing = widget.initialList != null;

    return AlertDialog(
      title: Text(isEditing ? l10n.listFormEditTitle : l10n.listFormNewTitle),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.listFormNameLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.listFormNameValidation;
                  }
                  return null;
                },
                autofocus: true,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.listFormIconLabel,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableIcons.map((iconName) {
                  final isSelected = _selectedIcon == iconName;
                  return InkWell(
                    onTap: () => setState(() => _selectedIcon = iconName),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(
                                color: theme.colorScheme.primary,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Icon(
                        _getIconData(iconName),
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.listFormColorLabel,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableColors.map((colorHex) {
                  final isSelected = _selectedColor == colorHex;
                  final color = _colorFromHex(colorHex);
                  return InkWell(
                    onTap: () => setState(() => _selectedColor = colorHex),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: theme.colorScheme.primary,
                                width: 3,
                              )
                            : null,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              color: _getContrastColor(color),
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? l10n.commonSave : l10n.commonCreate),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final service = ref.read(listServiceProvider);
      final name = _nameController.text.trim();

      TaskList result;
      if (widget.initialList != null) {
        result = await service.updateList(
          widget.initialList!,
          ListUpdateInput(
            name: name,
            iconName: _selectedIcon,
            colorHex: _selectedColor,
          ),
        );
      } else {
        result = await service.createList(
          ListCreationInput(
            name: name,
            iconName: _selectedIcon,
            colorHex: _selectedColor,
          ),
        );
      }

      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.l10n.listFormSaveError}: $error')),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  IconData _getIconData(String iconName) {
    return switch (iconName) {
      'inbox' => Icons.inbox,
      'work' => Icons.work,
      'home' => Icons.home,
      'shopping_cart' => Icons.shopping_cart,
      'favorite' => Icons.favorite,
      'star' => Icons.star,
      'calendar_today' => Icons.calendar_today,
      'school' => Icons.school,
      'fitness_center' => Icons.fitness_center,
      'restaurant' => Icons.restaurant,
      'flight' => Icons.flight,
      'lightbulb' => Icons.lightbulb,
      'brush' => Icons.brush,
      'music_note' => Icons.music_note,
      'sports_soccer' => Icons.sports_soccer,
      _ => Icons.list,
    };
  }

  Color _colorFromHex(String hex) {
    final sanitized = hex.replaceFirst('#', '');
    final value = int.tryParse(sanitized, radix: 16) ?? 0xFF000000;
    return Color(0xFF000000 | value);
  }

  Color _getContrastColor(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
