import 'package:flutter/material.dart';
import '../utils/gesture_haptic_utils.dart';

/// Widget extensions for convenient usage of glassmorphic UI components
extension WidgetExtensions on Widget {
  /// Add haptic feedback to any widget
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

  /// Add swipe gesture to any widget
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

  /// Add long press gesture to any widget
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

  /// Add padding with responsive values
  Widget withResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 600 ? 16.0 : 24.0;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  /// Add margin with responsive values
  Widget withResponsiveMargin(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final margin = screenWidth < 600 ? 8.0 : 16.0;
    return Container(
      margin: EdgeInsets.all(margin),
      child: this,
    );
  }

  /// Add conditional visibility
  Widget showIf(bool condition) {
    return condition ? this : const SizedBox.shrink();
  }

  /// Add fade animation
  Widget withFadeAnimation({
    Duration duration = const Duration(milliseconds: 300),
    bool animate = true,
  }) {
    if (!animate) return this;
    
    return AnimatedOpacity(
      opacity: 1.0,
      duration: duration,
      child: this,
    );
  }

  /// Add scale animation on tap
  Widget withScaleAnimation({
    double scale = 0.95,
    Duration duration = const Duration(milliseconds: 100),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: this,
        );
      },
    );
  }
}