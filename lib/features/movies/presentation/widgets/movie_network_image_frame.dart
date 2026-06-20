import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';

class MovieNetworkImageFrame extends StatefulWidget {
  const MovieNetworkImageFrame({
    super.key,
    required this.imageUrl,
    required this.fit,
    required this.overlayBuilder,
  });

  final String imageUrl;
  final BoxFit fit;
  final WidgetBuilder overlayBuilder;

  @override
  State<MovieNetworkImageFrame> createState() => _MovieNetworkImageFrameState();
}

class _MovieNetworkImageFrameState extends State<MovieNetworkImageFrame> {
  bool _isLoaded = false;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl.isEmpty || _hasError) {
      return _ImageFallback(
        icon: _hasError ? Icons.broken_image_outlined : Icons.movie_outlined,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          widget.imageUrl,
          fit: widget.fit,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            final isReady = wasSynchronouslyLoaded || frame != null;

            if (isReady && !_isLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _isLoaded = true;
                  });
                }
              });
            }

            if (!isReady) {
              return const _ImageLoading();
            }

            return child;
          },
          errorBuilder: (_, __, ___) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_hasError) {
                setState(() {
                  _hasError = true;
                });
              }
            });
            return const _ImageFallback(icon: Icons.broken_image_outlined);
          },
        ),
        if (_isLoaded) widget.overlayBuilder(context),
      ],
    );
  }
}

class _ImageLoading extends StatelessWidget {
  const _ImageLoading();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8ECF3),
      highlightColor: const Color(0xFFF6F8FC),
      child: Container(
        color: AppColors.background,
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 40,
        color: const Color(0xFF6B7280),
      ),
    );
  }
}
