import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'glassmorphic_components.dart';
import '../utils/animation_mixins.dart';

/// Comprehensive loading states and skeleton components
/// 
/// Features:
/// - Shimmer effects
/// - Skeleton screens
/// - Loading indicators
/// - Progress animations
/// - Error states
/// - Empty states
/// - Retry mechanisms

class SkeletonLoader extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration animationDuration;

  const SkeletonLoader({
    Key? key,
    required this.child,
    required this.isLoading,
    this.baseColor,
    this.highlightColor,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(SkeletonLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    final baseColor = widget.baseColor ?? 
        (isDarkMode ? Colors.grey[800]! : Colors.grey[300]!);
    final highlightColor = widget.highlightColor ?? 
        (isDarkMode ? Colors.grey[700]! : Colors.grey[100]!);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
              transform: _SlidingGradientTransform(_animation.value),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/// Skeleton shapes for common UI elements
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonBox({
    Key? key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class SkeletonText extends StatelessWidget {
  final double? width;
  final double height;
  final int lines;
  final double spacing;
  final EdgeInsetsGeometry? margin;

  const SkeletonText({
    Key? key,
    this.width,
    this.height = 16.0,
    this.lines = 1,
    this.spacing = 8.0,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(lines, (index) {
          return Container(
            margin: EdgeInsets.only(bottom: index < lines - 1 ? spacing : 0),
            child: SkeletonBox(
              width: index == lines - 1 && lines > 1 
                  ? (width ?? double.infinity) * 0.7 
                  : width,
              height: height,
              borderRadius: height / 2,
            ),
          );
        }),
      ),
    );
  }
}

class SkeletonAvatar extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? margin;

  const SkeletonAvatar({
    Key? key,
    this.size = 40.0,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: size,
      height: size,
      borderRadius: size / 2,
      margin: margin,
    );
  }
}

/// Predefined skeleton layouts
class SkeletonCard extends StatelessWidget {
  final bool showAvatar;
  final bool showImage;
  final int textLines;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const SkeletonCard({
    Key? key,
    this.showAvatar = true,
    this.showImage = false,
    this.textLines = 3,
    this.padding = const EdgeInsets.all(16),
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      padding: padding,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar)
            Row(
              children: [
                const SkeletonAvatar(size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonText(width: 120, height: 16),
                      const SizedBox(height: 4),
                      SkeletonText(width: 80, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          if (showAvatar && (showImage || textLines > 0))
            const SizedBox(height: 16),
          if (showImage) ...[
            SkeletonBox(
              width: double.infinity,
              height: 200,
              borderRadius: 12,
            ),
            const SizedBox(height: 16),
          ],
          if (textLines > 0)
            SkeletonText(
              lines: textLines,
              height: 14,
              spacing: 8,
            ),
        ],
      ),
    );
  }
}

class SkeletonListTile extends StatelessWidget {
  final bool showLeading;
  final bool showTrailing;
  final bool showSubtitle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const SkeletonListTile({
    Key? key,
    this.showLeading = true,
    this.showTrailing = false,
    this.showSubtitle = true,
    this.padding = const EdgeInsets.all(16),
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      child: Row(
        children: [
          if (showLeading) ...[
            const SkeletonAvatar(size: 48),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonText(width: 200, height: 16),
                if (showSubtitle) ...[
                  const SizedBox(height: 8),
                  SkeletonText(width: 150, height: 12),
                ],
              ],
            ),
          ),
          if (showTrailing) ...[
            const SizedBox(width: 16),
            SkeletonBox(width: 24, height: 24, borderRadius: 4),
          ],
        ],
      ),
    );
  }
}

/// Advanced loading indicators
class ModernLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final LoadingStyle style;

  const ModernLoadingIndicator({
    Key? key,
    this.size = 40.0,
    this.color,
    this.strokeWidth = 4.0,
    this.style = LoadingStyle.circular,
  }) : super(key: key);

  @override
  State<ModernLoadingIndicator> createState() => _ModernLoadingIndicatorState();
}

class _ModernLoadingIndicatorState extends State<ModernLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          switch (widget.style) {
            case LoadingStyle.circular:
              return _buildCircularIndicator(color);
            case LoadingStyle.dots:
              return _buildDotsIndicator(color);
            case LoadingStyle.bars:
              return _buildBarsIndicator(color);
            case LoadingStyle.pulse:
              return _buildPulseIndicator(color);
          }
        },
      ),
    );
  }

  Widget _buildCircularIndicator(Color color) {
    return CustomPaint(
      painter: _CircularLoadingPainter(
        progress: _animation.value,
        color: color,
        strokeWidth: widget.strokeWidth,
      ),
    );
  }

  Widget _buildDotsIndicator(Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (index) {
        final delay = index * 0.2;
        final animValue = (_animation.value - delay).clamp(0.0, 1.0);
        final scale = math.sin(animValue * math.pi);
        
        return Transform.scale(
          scale: 0.5 + (scale * 0.5),
          child: Container(
            width: widget.size / 6,
            height: widget.size / 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBarsIndicator(Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(4, (index) {
        final delay = index * 0.1;
        final animValue = (_animation.value - delay).clamp(0.0, 1.0);
        final height = math.sin(animValue * math.pi * 2).abs();
        
        return Container(
          width: widget.size / 8,
          height: widget.size * (0.3 + height * 0.7),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(widget.size / 16),
          ),
        );
      }),
    );
  }

  Widget _buildPulseIndicator(Color color) {
    final scale = 0.5 + (math.sin(_animation.value * math.pi * 2).abs() * 0.5);
    final opacity = 0.3 + (math.sin(_animation.value * math.pi * 2).abs() * 0.7);
    
    return Transform.scale(
      scale: scale,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: color.withOpacity(opacity),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _CircularLoadingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CircularLoadingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

enum LoadingStyle {
  circular,
  dots,
  bars,
  pulse,
}

/// Error state widget
class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String retryText;

  const ErrorStateWidget({
    Key? key,
    this.title = 'Something went wrong',
    this.message = 'Please try again later.',
    this.icon = Icons.error_outline,
    this.onRetry,
    this.retryText = 'Try Again',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state widget
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String actionText;

  const EmptyStateWidget({
    Key? key,
    this.title = 'Nothing here yet',
    this.message = 'Add some content to get started.',
    this.icon = Icons.inbox_outlined,
    this.onAction,
    this.actionText = 'Get Started',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading overlay widget
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? loadingText;
  final Color? overlayColor;
  final LoadingStyle loadingStyle;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.loadingText,
    this.overlayColor,
    this.loadingStyle = LoadingStyle.circular,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? Colors.black.withOpacity(0.5),
            child: Center(
              child: GlassmorphicCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ModernLoadingIndicator(
                      style: loadingStyle,
                      size: 48,
                    ),
                    if (loadingText != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        loadingText!,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}