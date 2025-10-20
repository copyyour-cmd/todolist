import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/domain/entities/attachment.dart';
import 'package:todolist/src/features/attachments/presentation/attachment_preview_dialog.dart';

class AttachmentList extends ConsumerWidget {
  const AttachmentList({
    required this.attachments, required this.onDelete, super.key,
    this.readOnly = false,
  });

  final List<Attachment> attachments;
  final Function(Attachment) onDelete;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    if (attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments (${attachments.length})',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: attachments.map((attachment) {
            return _AttachmentCard(
              attachment: attachment,
              onTap: () => _showPreview(context, attachment),
              onDelete: readOnly ? null : () => onDelete(attachment),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showPreview(BuildContext context, Attachment attachment) {
    showDialog(
      context: context,
      builder: (context) => AttachmentPreviewDialog(attachment: attachment),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  const _AttachmentCard({
    required this.attachment,
    required this.onTap,
    this.onDelete,
  });

  final Attachment attachment;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            // Content
            Positioned.fill(
              child: _buildContent(context),
            ),
            // Delete button
            if (onDelete != null)
              Positioned(
                top: 4,
                right: 4,
                child: InkWell(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    switch (attachment.type) {
      case AttachmentType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(attachment.filePath),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholder(context, Icons.image, attachment.fileExtension);
            },
          ),
        );

      case AttachmentType.file:
        return _buildPlaceholder(context, Icons.description, attachment.fileExtension);

      case AttachmentType.audio:
        return _buildPlaceholder(context, Icons.mic, attachment.fileExtension);
    }
  }

  Widget _buildPlaceholder(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 32, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          attachment.displaySize,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
