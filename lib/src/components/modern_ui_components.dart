import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'glassmorphic_components.dart';
import 'animation_mixins.dart';

/// Complete modern UI components library with advanced features
/// 
/// Features:
/// - Comprehensive component library
/// - Modern design patterns
/// - Performance optimizations
/// - Accessibility support
/// - Responsive design
/// - Advanced animations

class ModernLoadingButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final String? semanticLabel;

  const ModernLoadingButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.width,
    this.height,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<ModernLoadingButton> createState() => _ModernLoadingButtonState();
}

class _ModernLoadingButtonState extends State<ModernLoadingButton>
    with SingleTickerProviderStateMixin, FadeAnimationMixin {
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    initializeFadeAnimation();
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _rippleController.dispose();
    disposeFadeAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return GlassmorphicButton(
      onPressed: widget.onPressed,
      isLoading: widget.isLoading,
      borderRadius: widget.borderRadius,
      padding: widget.padding,
      width: widget.width,
      height: widget.height,
      backgroundColor: widget.backgroundColor ?? theme.colorScheme.primary,
      semanticLabel: widget.semanticLabel ?? widget.text,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: widget.isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.foregroundColor ?? Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: widget.foregroundColor ?? Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: widget.foregroundColor ?? Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class ModernProgressIndicator extends StatefulWidget {
  final double value;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final double size;
  final Widget? child;
  final bool showPercentage;
  final TextStyle? textStyle;

  const ModernProgressIndicator({
    Key? key,
    required this.value,
    this.strokeWidth = 8.0,
    this.backgroundColor,
    this.progressColor,
    this.size = 100.0,
    this.child,
    this.showPercentage = false,
    this.textStyle,
  }) : super(key: key);

  @override
  State<ModernProgressIndicator> createState() => _ModernProgressIndicatorState();
}

class _ModernProgressIndicatorState extends State<ModernProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(ModernProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _ProgressPainter(
              progress: _animation.value,
              strokeWidth: widget.strokeWidth,
              backgroundColor: widget.backgroundColor ?? theme.colorScheme.surface,
              progressColor: widget.progressColor ?? theme.colorScheme.primary,
            ),
            child: widget.child ?? (widget.showPercentage
                ? Center(
                    child: Text(
                      '${(_animation.value * 100).toInt()}%',
                      style: widget.textStyle ?? theme.textTheme.titleMedium,
                    ),
                  )
                : null),
          );
        },
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  _ProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ModernCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final bool enableHoverEffect;
  final String? semanticLabel;

  const ModernCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16.0,
    this.backgroundColor,
    this.shadows,
    this.onTap,
    this.enableHoverEffect = true,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GlassmorphicCard(
            onTap: widget.onTap,
            padding: widget.padding,
            margin: widget.margin,
            borderRadius: widget.borderRadius,
            backgroundColor: widget.backgroundColor,
            shadows: widget.shadows ?? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1 + (0.1 * _elevationAnimation.value)),
                blurRadius: 15 + (10 * _elevationAnimation.value),
                offset: Offset(0, 8 + (4 * _elevationAnimation.value)),
              ),
            ],
            semanticLabel: widget.semanticLabel,
            child: MouseRegion(
              onEnter: widget.enableHoverEffect ? (_) {
                setState(() => _isHovered = true);
                _controller.forward();
              } : null,
              onExit: widget.enableHoverEffect ? (_) {
                setState(() => _isHovered = false);
                _controller.reverse();
              } : null,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

class ModernChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool selected;
  final String? semanticLabel;

  const ModernChip({
    Key? key,
    required this.label,
    this.icon,
    this.onTap,
    this.onDeleted,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.selected = false,
    this.semanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    final effectiveBackgroundColor = backgroundColor ?? 
        (selected 
            ? theme.colorScheme.primary.withOpacity(0.8)
            : theme.colorScheme.surface);
    
    final effectiveForegroundColor = foregroundColor ?? 
        (selected 
            ? Colors.white
            : theme.colorScheme.onSurface);

    return GlassmorphicCard(
      onTap: onTap,
      borderRadius: borderRadius,
      padding: padding,
      backgroundColor: effectiveBackgroundColor,
      semanticLabel: semanticLabel ?? label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: effectiveForegroundColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: effectiveForegroundColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (onDeleted != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onDeleted!();
              },
              child: Icon(
                Icons.close,
                size: 16,
                color: effectiveForegroundColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ModernSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final String? semanticLabel;

  const ModernSearchBar({
    Key? key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<ModernSearchBar> createState() => _ModernSearchBarState();
}

class _ModernSearchBarState extends State<ModernSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    if (widget.controller != null) {
      widget.controller!.addListener(_onTextChanged);
      _hasText = widget.controller!.text.isNotEmpty;
      if (_hasText) _controller.forward();
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller!.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
      if (hasText) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassmorphicTextField(
      controller: widget.controller,
      hintText: widget.hintText,
      prefixIcon: Icons.search,
      suffixIcon: _hasText ? Icons.clear : null,
      onSuffixIconPressed: _hasText ? () {
        widget.controller?.clear();
        widget.onClear?.call();
      } : null,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      autofocus: widget.autofocus,
      semanticLabel: widget.semanticLabel ?? 'Search field',
    );
  }
}

class ModernToggleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final double width;
  final double height;
  final String? semanticLabel;

  const ModernToggleSwitch({
    Key? key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.width = 50.0,
    this.height = 28.0,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<ModernToggleSwitch> createState() => _ModernToggleSwitchState();
}

class _ModernToggleSwitchState extends State<ModernToggleSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ModernToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
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
    final theme = Theme.of(context);
    
    return Semantics(
      label: widget.semanticLabel ?? 'Toggle switch',
      value: widget.value ? 'On' : 'Off',
      onTap: widget.onChanged != null ? () {
        widget.onChanged!(!widget.value);
      } : null,
      child: GestureDetector(
        onTap: widget.onChanged != null ? () {
          HapticFeedback.selectionClick();
          widget.onChanged!(!widget.value);
        } : null,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.height / 2),
                color: Color.lerp(
                  widget.inactiveColor ?? theme.colorScheme.surface,
                  widget.activeColor ?? theme.colorScheme.primary,
                  _animation.value,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: widget.value ? widget.width - widget.height : 0,
                    child: Container(
                      width: widget.height,
                      height: widget.height,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Utility class for responsive design
class ResponsiveHelper {
  static bool isPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }
  
  static double responsiveValue(
    BuildContext context, {
    required double phone,
    required double tablet,
    required double desktop,
  }) {
    if (isPhone(context)) return phone;
    if (isTablet(context)) return tablet;
    return desktop;
  }
  
  static EdgeInsets responsivePadding(BuildContext context) {
    return EdgeInsets.all(responsiveValue(
      context,
      phone: 16.0,
      tablet: 24.0,
      desktop: 32.0,
    ));
  }
}

/// Constants for consistent spacing
class ModernSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Constants for consistent border radius
class ModernBorderRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double circular = 50.0;
}