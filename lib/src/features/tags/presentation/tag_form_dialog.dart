import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/domain/entities/tag.dart';
import 'package:todolist/src/features/tags/application/tag_service.dart';

class TagFormDialog extends ConsumerStatefulWidget {
  const TagFormDialog({super.key, this.initialTag});

  final Tag? initialTag;

  static Future<Tag?> show(
    BuildContext context, {
    Tag? tag,
  }) {
    return showDialog<Tag>(
      context: context,
      builder: (context) => TagFormDialog(initialTag: tag),
    );
  }

  @override
  ConsumerState<TagFormDialog> createState() => _TagFormDialogState();
}

class _TagFormDialogState extends ConsumerState<TagFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  String _selectedColor = '#8896AB';
  bool _isSaving = false;

  static const _availableColors = [
    '#8896AB', // Gray (default)
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
    '#F43F5E', // Rose
    '#14B8A6', // Teal
    '#A855F7', // Violet
    '#64748B', // Slate
  ];

  @override
  void initState() {
    super.initState();
    final tag = widget.initialTag;
    _nameController = TextEditingController(text: tag?.name ?? '');
    _selectedColor = tag?.colorHex ?? '#8896AB';
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
    final isEditing = widget.initialTag != null;

    return AlertDialog(
      title: Text(isEditing ? l10n.tagFormEditTitle : l10n.tagFormNewTitle),
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
                  labelText: l10n.tagFormNameLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.label_outline,
                    color: _colorFromHex(_selectedColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.tagFormNameValidation;
                  }
                  return null;
                },
                autofocus: true,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.tagFormColorLabel,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
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
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              color: _getContrastColor(color),
                              size: 24,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      l10n.tagFormPreview,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _colorFromHex(_selectedColor)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.label,
                            size: 16,
                            color: _colorFromHex(_selectedColor),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _nameController.text.isEmpty
                                ? l10n.tagFormPreviewPlaceholder
                                : _nameController.text,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _colorFromHex(_selectedColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
      final service = ref.read(tagServiceProvider);
      final name = _nameController.text.trim();

      Tag result;
      if (widget.initialTag != null) {
        result = await service.updateTag(
          widget.initialTag!,
          TagUpdateInput(
            name: name,
            colorHex: _selectedColor,
          ),
        );
      } else {
        result = await service.createTag(
          TagCreationInput(
            name: name,
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
          SnackBar(content: Text('${context.l10n.tagFormSaveError}: $error')),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  Color _colorFromHex(String hex) {
    final sanitized = hex.replaceFirst('#', '');
    final value = int.tryParse(sanitized, radix: 16) ?? 0xFF8896AB;
    return Color(0xFF000000 | value);
  }

  Color _getContrastColor(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
