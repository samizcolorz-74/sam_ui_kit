import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Comprehensive animation mixins and controllers for modern mobile apps
/// 
/// Features:
/// - Reusable animation patterns
/// - Smooth transitions
/// - Performance optimized
/// - Easy integration
/// - Customizable parameters

/// Mixin for fade-in animations
mixin FadeAnimationMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin {
  late AnimationController fadeController;
  late Animation<double> fadeAnimation;
  
  void initializeFadeAnimation({
    Duration duration = const Duration(milliseconds: 800),
    Curve curve = Curves.easeInOut,
    double begin = 0.0,
    double end = 1.0,
  }) {
    fadeController = AnimationController(
      duration: duration,
      vsync: this,
    );
    fadeAnimation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: fadeController,
      curve: curve,
    ));
  }
  
  void startFadeAnimation() {
    fadeController.forward();
  }
  
  void reverseFadeAnimation() {
    fadeController.reverse();
  }
  
  void resetFadeAnimation() {
    fadeController.reset();
  }
  
  void disposeFadeAnimation() {
    fadeController.dispose();
  }
  
  Widget buildFadeTransition(Widget child) {
    return AnimatedBuilder(
      animation: fadeAnimation,
      builder: (context, _) {
        return Opacity(
          opacity: fadeAnimation.value,
          child: child,
        );
      },
    );
  }
}

/// Mixin for slide animations
mixin SlideAnimationMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin {
  late AnimationController slideController;
  late Animation<Offset> slideAnimation;
  
  void initializeSlideAnimation({
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.elasticOut,
    Offset begin = const Offset(0, 0.3),
    Offset end = Offset.zero,
  }) {
    slideController = AnimationController(
      duration: duration,
      vsync: this,
    );
    slideAnimation = Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: slideController,
      curve: curve,
    ));
  }
  
  void startSlideAnimation() {
    slideController.forward();
  }
  
  void reverseSlideAnimation() {
    slideController.reverse();
  }
  
  void resetSlideAnimation() {
    slideController.reset();
  }
  
  void disposeSlideAnimation() {
    slideController.dispose();
  }
  
  Widget buildSlideTransition(Widget child) {
    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (context, _) {
        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
    );
  }
}

/// Mixin for scale animations
mixin ScaleAnimationMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin {
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;
  
  void initializeScaleAnimation({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.elasticOut,
    double begin = 0.0,
    double end = 1.0,
  }) {
    scaleController = AnimationController(
      duration: duration,
      vsync: this,
    );
    scaleAnimation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: scaleController,
      curve: curve,
    ));
  }
  
  void startScaleAnimation() {
    scaleController.forward();
  }
  
  void reverseScaleAnimation() {
    scaleController.reverse();
  }
  
  void resetScaleAnimation() {
    scaleController.reset();
  }
  
  void disposeScaleAnimation() {
    scaleController.dispose();
  }
  
  Widget buildScaleTransition(Widget child) {
    return AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, _) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: child,
        );
      },
    );
  }
}

/// Mixin for rotation animations
mixin RotationAnimationMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin {
  late AnimationController rotationController;
  late Animation<double> rotationAnimation;
  
  void initializeRotationAnimation({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    double begin = 0.0,
    double end = 0.5, // 0.5 = 180 degrees
  }) {
    rotationController = AnimationController(
      duration: duration,
      vsync: this,
    );
    rotationAnimation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: rotationController,
      curve: curve,
    ));
  }
  
  void startRotationAnimation() {
    rotationController.forward();
  }
  
  void reverseRotationAnimation() {
    rotationController.reverse();
  }
  
  void resetRotationAnimation() {
    rotationController.reset();
  }
  
  void disposeRotationAnimation() {
    rotationController.dispose();
  }
  
  Widget buildRotationTransition(Widget child) {
    return AnimatedBuilder(
      animation: rotationAnimation,
      builder: (context, _) {
        return Transform.rotate(
          angle: rotationAnimation.value * 2 * 3.14159, // Convert to radians
          child: child,
        );
      },
    );
  }
}

/// Mixin for counter animations
mixin CounterAnimationMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin {
  late AnimationController counterController;
  late Animation<double> counterAnimation;
  
  void initializeCounterAnimation({
    Duration duration = const Duration(milliseconds: 1500),
    Curve curve = Curves.easeOut,
  }) {
    counterController = AnimationController(
      duration: duration,
      vsync: this,
    );
    counterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: counterController,
      curve: curve,
    ));
  }
  
  void startCounterAnimation() {
    counterController.forward();
  }
  
  void reverseCounterAnimation() {
    counterController.reverse();
  }
  
  void resetCounterAnimation() {
    counterController.reset();
  }
  
  void disposeCounterAnimation() {
    counterController.dispose();
  }
  
  Widget buildCounterTransition(int targetValue, TextStyle? style) {
    return AnimatedBuilder(
      animation: counterAnimation,
      builder: (context, _) {
        final currentValue = (targetValue * counterAnimation.value).toInt();
        return Text(
          currentValue.toString(),
          style: style,
        );
      },
    );
  }
}

/// Comprehensive animation controller for multiple animations
class MultiAnimationController with ChangeNotifier {
  final List<AnimationController> _controllers = [];
  
  void addController(AnimationController controller) {
    _controllers.add(controller);
    controller.addListener(notifyListeners);
  }
  
  void removeController(AnimationController controller) {
    _controllers.remove(controller);
    controller.removeListener(notifyListeners);
  }
  
  void startAll() {
    for (final controller in _controllers) {
      controller.forward();
    }
  }
  
  void reverseAll() {
    for (final controller in _controllers) {
      controller.reverse();
    }
  }
  
  void resetAll() {
    for (final controller in _controllers) {
      controller.reset();
    }
  }
  
  void disposeAll() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
  }
  
  bool get isAnimating => _controllers.any((controller) => controller.isAnimating);
  bool get isCompleted => _controllers.every((controller) => controller.isCompleted);
  bool get isDismissed => _controllers.every((controller) => controller.isDismissed);
}

/// Preset animation configurations
class AnimationPresets {
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration normalDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);
  static const Duration verySlowDuration = Duration(milliseconds: 800);
  
  static const Curve bounceInCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeInOut;
  static const Curve fastCurve = Curves.easeOut;
  static const Curve slowCurve = Curves.easeIn;
  
  // Slide presets
  static const Offset slideFromBottom = Offset(0, 1);
  static const Offset slideFromTop = Offset(0, -1);
  static const Offset slideFromLeft = Offset(-1, 0);
  static const Offset slideFromRight = Offset(1, 0);
  
  // Scale presets
  static const double scaleFromZero = 0.0;
  static const double scaleFromSmall = 0.5;
  static const double scaleToNormal = 1.0;
  static const double scaleToLarge = 1.2;
}

/// Utility class for creating common animated widgets
class AnimatedWidgets {
  /// Creates a staggered animation for a list of widgets
  static Widget staggeredList({
    required List<Widget> children,
    required AnimationController controller,
    Duration staggerDelay = const Duration(milliseconds: 100),
    Curve curve = Curves.easeOut,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        
        final start = (index * staggerDelay.inMilliseconds) / controller.duration!.inMilliseconds;
        final end = start + 0.5; // Animation duration is 50% of total
        
        final animation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Interval(start, end.clamp(0.0, 1.0), curve: curve),
        ));
        
        return AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - animation.value)),
              child: Opacity(
                opacity: animation.value,
                child: child,
              ),
            );
          },
        );
      }).toList(),
    );
  }
  
  /// Creates a pulsing animation
  static Widget pulsing({
    required Widget child,
    required AnimationController controller,
    double minScale = 0.95,
    double maxScale = 1.05,
  }) {
    final animation = Tween<double>(
      begin: minScale,
      end: maxScale,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
    
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform.scale(
          scale: animation.value,
          child: child,
        );
      },
    );
  }
  
  /// Creates a shimmer effect
  static Widget shimmer({
    required Widget child,
    required AnimationController controller,
    Color? highlightColor,
    Color? baseColor,
  }) {
    final animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
    
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return ClipRect(
          child: Stack(
            children: [
              child,
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(animation.value * 200, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          baseColor ?? Colors.grey[300]!,
                          highlightColor ?? Colors.grey[100]!,
                          baseColor ?? Colors.grey[300]!,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  /// Creates a typewriter effect
  static Widget typewriter({
    required String text,
    required AnimationController controller,
    TextStyle? style,
    Duration characterDelay = const Duration(milliseconds: 50),
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final charactersToShow = (text.length * controller.value).floor();
        return Text(
          text.substring(0, charactersToShow),
          style: style,
        );
      },
    );
  }
}

/// Haptic feedback utilities
class HapticUtils {
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }
  
  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }
  
  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }
  
  static void selectionClick() {
    HapticFeedback.selectionClick();
  }
  
  static void buttonPress() {
    HapticFeedback.mediumImpact();
  }
  
  static void success() {
    HapticFeedback.lightImpact();
  }
  
  static void error() {
    HapticFeedback.heavyImpact();
  }
  
  static void warning() {
    HapticFeedback.mediumImpact();
  }
}