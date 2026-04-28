import 'package:flutter/material.dart';

/// Generic image preview component with Hero animation
///
/// Usage:
/// ```dart
/// Hero(
///   tag: 'img-preview-unique-id',
///   child: GestureDetector(
///     onTap: () => ImgPreview.show(context, imageProvider, heroTag: 'img-preview-unique-id'),
///     child: Image(image: imageProvider),
///   ),
/// )
/// ```
class ImgPreview {
  /// Show a full-screen image preview with Hero animation
  ///
  /// [context] - The build context
  /// [imageProvider] - The ImageProvider to display (FileImage, NetworkImage, AssetImage, etc.)
  /// [heroTag] - The unique Hero tag for animation (must match the Hero tag on the source image)
  /// [background] - Optional background color for the preview (defaults to black)
  static void show(
    BuildContext context,
    ImageProvider imageProvider, {
    required String heroTag,
    Color? background,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return _ImgPreviewPage(
            imageProvider: imageProvider,
            heroTag: heroTag,
            background: background ?? Colors.black,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
        opaque: false,
        barrierColor: Colors.black,
      ),
    );
  }
}

class _ImgPreviewPage extends StatelessWidget {
  final ImageProvider imageProvider;
  final String heroTag;
  final Color background;

  const _ImgPreviewPage({
    required this.imageProvider,
    required this.heroTag,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: background,
        child: Center(
          child: Hero(
            tag: heroTag,
            child: Image(image: imageProvider),
          ),
        ),
      ),
    );
  }
}
