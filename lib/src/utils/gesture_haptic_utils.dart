import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

/// Comprehensive gesture and haptic feedback utilities
/// 
/// Features:
/// - Advanced gesture recognition
/// - Contextual haptic feedback
/// - Custom gesture patterns
/// - Accessibility support
/// - Performance optimization
/// - Cross-platform compatibility

class HapticManager {
  static bool _isEnabled = true;
  static HapticIntensity _defaultIntensity = HapticIntensity.medium;
  
  /// Enable or disable haptic feedback globally
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }
  
  /// Set default haptic intensity
  static void setDefaultIntensity(HapticIntensity intensity) {
    _defaultIntensity = intensity;
  }
  
  /// Light impact feedback
  static void lightImpact() {
    if (!_isEnabled) return;
    HapticFeedback.lightImpact();
  }
  
  /// Medium impact feedback
  static void mediumImpact() {
    if (!_isEnabled) return;
    HapticFeedback.mediumImpact();
  }
  
  /// Heavy impact feedback
  static void heavyImpact() {
    if (!_isEnabled) return;
    HapticFeedback.heavyImpact();
  }
  
  /// Selection click feedback
  static void selectionClick() {
    if (!_isEnabled) return;
    HapticFeedback.selectionClick();
  }
  
  /// Contextual feedback based on action type
  static void contextualFeedback(HapticContext context) {
    if (!_isEnabled) return;
    
    switch (context) {
      case HapticContext.buttonPress:
        mediumImpact();
        break;
      case HapticContext.selection:
        selectionClick();
        break;
      case HapticContext.success:
        lightImpact();
        break;
      case HapticContext.error:
        heavyImpact();
        break;
      case HapticContext.warning:
        mediumImpact();
        break;
      case HapticContext.navigation:
        lightImpact();
        break;
      case HapticContext.swipe:
        selectionClick();
        break;
      case HapticContext.longPress:
        heavyImpact();
        break;
    }
  }
  
  /// Custom haptic pattern
  static void customPattern(List<HapticEvent> events) async {
    if (!_isEnabled) return;
    
    for (final event in events) {
      await Future.delayed(event.delay);
      switch (event.type) {
        case HapticType.light:
          lightImpact();
          break;
        case HapticType.medium:
          mediumImpact();
          break;
        case HapticType.heavy:
          heavyImpact();
          break;
        case HapticType.selection:
          selectionClick();
          break;
      }
    }
  }
}

enum HapticContext {
  buttonPress,
  selection,
  success,
  error,
  warning,
  navigation,
  swipe,
  longPress,
}

enum HapticIntensity {
  light,
  medium,
  heavy,
}

enum HapticType {
  light,
  medium,
  heavy,
  selection,
}

class HapticEvent {
  final HapticType type;
  final Duration delay;
  
  const HapticEvent({
    required this.type,
    this.delay = Duration.zero,
  });
}

/// Enhanced gesture detector with haptic feedback
class HapticGestureDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final GestureDragStartCallback? onPanStart;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureDragEndCallback? onPanEnd;
  final GestureScaleStartCallback? onScaleStart;
  final GestureScaleUpdateCallback? onScaleUpdate;
  final GestureScaleEndCallback? onScaleEnd;
  final bool enableHapticFeedback;
  final HapticContext? hapticContext;
  final String? semanticLabel;

  const HapticGestureDetector({
    Key? key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.enableHapticFeedback = true,
    this.hapticContext,
    this.semanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget detector = GestureDetector(
      onTap: onTap != null ? () {
        if (enableHapticFeedback) {
          HapticManager.contextualFeedback(hapticContext ?? HapticContext.buttonPress);
        }
        onTap!();
      } : null,
      onDoubleTap: onDoubleTap != null ? () {
        if (enableHapticFeedback) {
          HapticManager.mediumImpact();
        }
        onDoubleTap!();
      } : null,
      onLongPress: onLongPress != null ? () {
        if (enableHapticFeedback) {
          HapticManager.contextualFeedback(HapticContext.longPress);
        }
        onLongPress!();
      } : null,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onScaleEnd: onScaleEnd,
      child: child,
    );

    if (semanticLabel != null) {
      detector = Semantics(
        label: semanticLabel,
        button: onTap != null,
        child: detector,
      );
    }

    return detector;
  }
}

/// Swipe gesture recognizer with haptic feedback
class SwipeGestureDetector extends StatefulWidget {
  final Widget child;
  final Function(SwipeDirection)? onSwipe;
  final double threshold;
  final bool enableHapticFeedback;
  final String? semanticLabel;

  const SwipeGestureDetector({
    Key? key,
    required this.child,
    this.onSwipe,
    this.threshold = 50.0,
    this.enableHapticFeedback = true,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<SwipeGestureDetector> createState() => _SwipeGestureDetectorState();
}

class _SwipeGestureDetectorState extends State<SwipeGestureDetector> {
  Offset? _startPosition;

  @override
  Widget build(BuildContext context) {
    Widget detector = GestureDetector(
      onPanStart: (details) {
        _startPosition = details.localPosition;
      },
      onPanEnd: (details) {
        if (_startPosition == null) return;
        
        final dx = details.localPosition.dx - _startPosition!.dx;
        final dy = details.localPosition.dy - _startPosition!.dy;
        
        if (dx.abs() > widget.threshold || dy.abs() > widget.threshold) {
          SwipeDirection? direction;
          
          if (dx.abs() > dy.abs()) {
            // Horizontal swipe
            direction = dx > 0 ? SwipeDirection.right : SwipeDirection.left;
          } else {
            // Vertical swipe
            direction = dy > 0 ? SwipeDirection.down : SwipeDirection.up;
          }
          
          if (widget.enableHapticFeedback) {
            HapticManager.contextualFeedback(HapticContext.swipe);
          }
          
          widget.onSwipe?.call(direction);
        }
        
        _startPosition = null;
      },
      child: widget.child,
    );

    if (widget.semanticLabel != null) {
      detector = Semantics(
        label: widget.semanticLabel,
        child: detector,
      );
    }

    return detector;
  }
}

enum SwipeDirection {
  up,
  down,
  left,
  right,
}

/// Pull to refresh with haptic feedback
class HapticPullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final double threshold;
  final bool enableHapticFeedback;
  final Color? indicatorColor;

  const HapticPullToRefresh({
    Key? key,
    required this.child,
    required this.onRefresh,
    this.threshold = 80.0,
    this.enableHapticFeedback = true,
    this.indicatorColor,
  }) : super(key: key);

  @override
  State<HapticPullToRefresh> createState() => _HapticPullToRefreshState();
}

class _HapticPullToRefreshState extends State<HapticPullToRefresh>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasTriggeredHaptic = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (widget.enableHapticFeedback) {
          HapticManager.lightImpact();
        }
        await widget.onRefresh();
      },
      color: widget.indicatorColor,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            final metrics = notification.metrics;
            if (metrics.extentBefore == 0.0 && metrics.extentAfter > 0.0) {
              final pullDistance = -metrics.pixels;
              
              if (pullDistance > widget.threshold && !_hasTriggeredHaptic) {
                if (widget.enableHapticFeedback) {
                  HapticManager.selectionClick();
                }
                _hasTriggeredHaptic = true;
              } else if (pullDistance <= 0) {
                _hasTriggeredHaptic = false;
              }
            }
          }
          return false;
        },
        child: widget.child,
      ),
    );
  }
}

/// Long press with progress indicator and haptic feedback
class LongPressGestureDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onLongPress;
  final Duration duration;
  final bool showProgress;
  final bool enableHapticFeedback;
  final Color? progressColor;
  final String? semanticLabel;

  const LongPressGestureDetector({
    Key? key,
    required this.child,
    this.onLongPress,
    this.duration = const Duration(milliseconds: 800),
    this.showProgress = true,
    this.enableHapticFeedback = true,
    this.progressColor,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<LongPressGestureDetector> createState() => _LongPressGestureDetectorState();
}

class _LongPressGestureDetectorState extends State<LongPressGestureDetector>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isPressed) {
        if (widget.enableHapticFeedback) {
          HapticManager.contextualFeedback(HapticContext.longPress);
        }
        widget.onLongPress?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget detector = GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: Stack(
        children: [
          widget.child,
          if (widget.showProgress && _isPressed)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _LongPressPainter(
                      progress: _controller.value,
                      color: widget.progressColor ?? theme.colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );

    if (widget.semanticLabel != null) {
      detector = Semantics(
        label: widget.semanticLabel,
        button: true,
        child: detector,
      );
    }

    return detector;
  }
}

class _LongPressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _LongPressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width.abs() + size.height.abs()) / 4;
    
    final sweepAngle = 2 * 3.14159 * progress;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

/// Multi-touch gesture detector
class MultiTouchGestureDetector extends StatefulWidget {
  final Widget child;
  final Function(int)? onTouchCountChanged;
  final Function(List<Offset>)? onMultiTouchUpdate;
  final bool enableHapticFeedback;
  final String? semanticLabel;

  const MultiTouchGestureDetector({
    Key? key,
    required this.child,
    this.onTouchCountChanged,
    this.onMultiTouchUpdate,
    this.enableHapticFeedback = true,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<MultiTouchGestureDetector> createState() => _MultiTouchGestureDetectorState();
}

class _MultiTouchGestureDetectorState extends State<MultiTouchGestureDetector> {
  final Map<int, Offset> _touches = {};

  @override
  Widget build(BuildContext context) {
    Widget detector = Listener(
      onPointerDown: (event) {
        _touches[event.pointer] = event.localPosition;
        if (widget.enableHapticFeedback && _touches.length > 1) {
          HapticManager.lightImpact();
        }
        widget.onTouchCountChanged?.call(_touches.length);
      },
      onPointerMove: (event) {
        _touches[event.pointer] = event.localPosition;
        widget.onMultiTouchUpdate?.call(_touches.values.toList());
      },
      onPointerUp: (event) {
        _touches.remove(event.pointer);
        widget.onTouchCountChanged?.call(_touches.length);
      },
      onPointerCancel: (event) {
        _touches.remove(event.pointer);
        widget.onTouchCountChanged?.call(_touches.length);
      },
      child: widget.child,
    );

    if (widget.semanticLabel != null) {
      detector = Semantics(
        label: widget.semanticLabel,
        child: detector,
      );
    }

    return detector;
  }
}

/// Haptic patterns for common scenarios
class HapticPatterns {
  /// Success pattern: light -> light
  static const success = [
    HapticEvent(type: HapticType.light),
    HapticEvent(type: HapticType.light, delay: Duration(milliseconds: 100)),
  ];
  
  /// Error pattern: heavy -> heavy -> heavy
  static const error = [
    HapticEvent(type: HapticType.heavy),
    HapticEvent(type: HapticType.heavy, delay: Duration(milliseconds: 150)),
    HapticEvent(type: HapticType.heavy, delay: Duration(milliseconds: 150)),
  ];
  
  /// Warning pattern: medium -> medium
  static const warning = [
    HapticEvent(type: HapticType.medium),
    HapticEvent(type: HapticType.medium, delay: Duration(milliseconds: 200)),
  ];
  
  /// Notification pattern: light -> medium
  static const notification = [
    HapticEvent(type: HapticType.light),
    HapticEvent(type: HapticType.medium, delay: Duration(milliseconds: 100)),
  ];
  
  /// Progress pattern: selection clicks
  static const progress = [
    HapticEvent(type: HapticType.selection),
    HapticEvent(type: HapticType.selection, delay: Duration(milliseconds: 50)),
    HapticEvent(type: HapticType.selection, delay: Duration(milliseconds: 50)),
  ];
}

/// Gesture extensions for common widgets
extension GestureExtensions on Widget {
  Widget withHapticTap({
    required VoidCallback onTap,
    HapticContext context = HapticContext.buttonPress,
    bool enableHaptic = true,
    String? semanticLabel,
  }) {
    return HapticGestureDetector(
      onTap: onTap,
      hapticContext: context,
      enableHapticFeedback: enableHaptic,
      semanticLabel: semanticLabel,
      child: this,
    );
  }
  
  Widget withSwipeGesture({
    required Function(SwipeDirection) onSwipe,
    double threshold = 50.0,
    bool enableHaptic = true,
    String? semanticLabel,
  }) {
    return SwipeGestureDetector(
      onSwipe: onSwipe,
      threshold: threshold,
      enableHapticFeedback: enableHaptic,
      semanticLabel: semanticLabel,
      child: this,
    );
  }
  
  Widget withLongPress({
    required VoidCallback onLongPress,
    Duration duration = const Duration(milliseconds: 800),
    bool showProgress = true,
    bool enableHaptic = true,
    String? semanticLabel,
  }) {
    return LongPressGestureDetector(
      onLongPress: onLongPress,
      duration: duration,
      showProgress: showProgress,
      enableHapticFeedback: enableHaptic,
      semanticLabel: semanticLabel,
      child: this,
    );
  }
}