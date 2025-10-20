import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:todolist/src/features/notes/presentation/widgets/image_preview_dialog.dart';

/// 自定义Markdown图片构建器
/// 支持本地文件路径和网络图片
/// 点击图片可以预览和缩放
class CustomMarkdownImageBuilder extends MarkdownElementBuilder {
  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final String? src = element.attributes['src'];
    final String? alt = element.attributes['alt'] ?? '图片';

    if (src == null || src.isEmpty) {
      return const SizedBox.shrink();
    }

    return _ImageWidget(
      src: src,
      alt: alt!,
    );
  }
}

/// 图片组件
class _ImageWidget extends StatelessWidget {
  const _ImageWidget({
    required this.src,
    required this.alt,
  });

  final String src;
  final String alt;

  bool get isLocalFile {
    return !src.startsWith('http://') &&
        !src.startsWith('https://') &&
        !src.startsWith('data:');
  }

  /// 获取本地文件的实际路径(处理file://前缀)
  String get localFilePath {
    String path = src;
    // 移除 file:// 或 file:/// 前缀
    if (path.startsWith('file:///')) {
      path = path.substring(8); // 移除 "file:///"
    } else if (path.startsWith('file://')) {
      path = path.substring(7); // 移除 "file://"
    }
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImagePreview(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        constraints: const BoxConstraints(
          maxHeight: 400,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildImage(context),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (isLocalFile) {
      // 本地文件 - 使用处理后的路径
      final file = File(localFilePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget(context, '加载失败');
          },
        );
      } else {
        return _buildErrorWidget(context, '文件不存在: $localFilePath');
      }
    } else {
      // 网络图片
      return Image.network(
        src,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget(context, '网络图片加载失败');
        },
      );
    }
  }

  Widget _buildErrorWidget(BuildContext context, String reason) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.broken_image,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '图片加载失败: $alt',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ImagePreviewDialog(
        imageSrc: src,
        alt: alt,
        isLocalFile: isLocalFile,
      ),
    );
  }
}
