import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/l10n/l10n.dart';
import 'package:todolist/src/domain/entities/attachment.dart';
import 'package:todolist/src/features/attachments/application/attachment_providers.dart';
import 'package:todolist/src/features/attachments/presentation/audio_recorder_dialog.dart';

class AttachmentPicker extends ConsumerWidget {
  const AttachmentPicker({
    required this.onAttachmentAdded, super.key,
  });

  final Function(Attachment) onAttachmentAdded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final attachmentService = ref.watch(attachmentServiceProvider);

    return IconButton(
      icon: const Icon(Icons.attach_file),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final attachment = await attachmentService.pickImageFromCamera();
                  if (attachment != null) {
                    onAttachmentAdded(attachment);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final attachment = await attachmentService.pickImageFromGallery();
                  if (attachment != null) {
                    onAttachmentAdded(attachment);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Choose File'),
                onTap: () async {
                  Navigator.pop(context);
                  final attachment = await attachmentService.pickFile();
                  if (attachment != null) {
                    onAttachmentAdded(attachment);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.mic),
                title: const Text('Record Audio'),
                onTap: () async {
                  Navigator.pop(context);
                  final attachment = await showDialog<Attachment>(
                    context: context,
                    builder: (context) => const AudioRecorderDialog(),
                  );
                  if (attachment != null) {
                    onAttachmentAdded(attachment);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
