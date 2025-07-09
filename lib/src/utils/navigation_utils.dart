import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/glassmorphic_components.dart';
import 'animation_mixins.dart';
import 'gesture_haptic_utils.dart';

/// Comprehensive navigation and modal presentation utilities
/// 
/// Features:
/// - Modern navigation patterns
/// - Animated transitions
/// - Modal presentations
/// - Bottom sheets
/// - Snack bars
/// - Dialogs
/// - Hero animations
/// - Route management

class NavigationUtils {
  /// Navigate with custom animation
  static Future<T?> navigateWithAnimation<T>({
    required BuildContext context,
    required Widget destination,
    NavigationAnimation animation = NavigationAnimation.slideFromRight,
    Duration duration = const Duration(milliseconds: 300),
    bool replacement = false,
  }) {
    final route = PageRouteBuilder<T>(
      pageBuilder: (context, primaryAnimation, secondaryAnimation) => destination,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, primaryAnimation, secondaryAnimation, child) {
        return _buildTransition(animation, primaryAnimation, child);
      },
    );

    if (replacement) {
      return Navigator.pushReplacement(context, route);
    } else {
      return Navigator.push(context, route);
    }
  }

  /// Navigate and clear stack
  static Future<T?> navigateAndClearStack<T>({
    required BuildContext context,
    required Widget destination,
    NavigationAnimation animation = NavigationAnimation.fadeIn,
  }) {
    return Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder<T>(
        pageBuilder: (context, primaryAnimation, secondaryAnimation) => destination,
        transitionsBuilder: (context, primaryAnimation, secondaryAnimation, child) {
          return _buildTransition(animation, primaryAnimation, child);
        },
      ),
      (route) => false,
    );
  }

  /// Pop with animation
  static void popWithAnimation(
    BuildContext context, {
    NavigationAnimation animation = NavigationAnimation.slideToRight,
  }) {
    HapticManager.contextualFeedback(HapticContext.navigation);
    Navigator.pop(context);
  }

  /// Show modern bottom sheet
  static Future<T?> showModernBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool showHandle = true,
    bool isScrollControlled = true,
    bool enableDrag = true,
    double? heightFactor,
    EdgeInsetsGeometry? padding,
  }) {
    return GlassmorphicBottomSheet.show<T>(
      context: context,
      title: title,
      showHandle: showHandle,
      padding: padding,
      child: child,
    );
  }

  /// Show custom dialog
  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required Widget content,
    String? title,
    List<Widget>? actions,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black54,
      builder: (context) => ModernDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }

  /// Show modern snack bar
  static void showModernSnackBar({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final theme = Theme.of(context);
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        icon = Icons.check_circle;
        break;
      case SnackBarType.error:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        icon = Icons.error;
        break;
      case SnackBarType.warning:
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        icon = Icons.warning;
        break;
      case SnackBarType.info:
      default:
        backgroundColor = theme.colorScheme.primary;
        textColor = theme.colorScheme.onPrimary;
        icon = Icons.info;
        break;
    }

    HapticManager.contextualFeedback(_getHapticForSnackBar(type));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: onAction != null && actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: textColor,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }

  static Widget _buildTransition(
    NavigationAnimation animation,
    Animation<double> primaryAnimation,
    Widget child,
  ) {
    switch (animation) {
      case NavigationAnimation.slideFromRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(primaryAnimation),
          child: child,
        );
      case NavigationAnimation.slideFromLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(primaryAnimation),
          child: child,
        );
      case NavigationAnimation.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(primaryAnimation),
          child: child,
        );
      case NavigationAnimation.slideFromTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(primaryAnimation),
          child: child,
        );
      case NavigationAnimation.slideToRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(1.0, 0.0),
          ).animate(primaryAnimation),
          child: child,
        );
      case NavigationAnimation.fadeIn:
        return FadeTransition(
          opacity: primaryAnimation,
          child: child,
        );
      case NavigationAnimation.scaleIn:
        return ScaleTransition(
          scale: primaryAnimation,
          child: child,
        );
      case NavigationAnimation.rotateIn:
        return RotationTransition(
          turns: primaryAnimation,
          child: child,
        );
    }
  }

  static HapticContext _getHapticForSnackBar(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return HapticContext.success;
      case SnackBarType.error:
        return HapticContext.error;
      case SnackBarType.warning:
        return HapticContext.warning;
      case SnackBarType.info:
      default:
        return HapticContext.selection;
    }
  }
}

enum NavigationAnimation {
  slideFromRight,
  slideFromLeft,
  slideFromBottom,
  slideFromTop,
  slideToRight,
  fadeIn,
  scaleIn,
  rotateIn,
}

enum SnackBarType {
  success,
  error,
  warning,
  info,
}

/// Modern dialog component
class ModernDialog extends StatefulWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;

  const ModernDialog({
    Key? key,
    this.title,
    required this.content,
    this.actions,
    this.contentPadding,
    this.actionsPadding,
  }) : super(key: key);

  @override
  State<ModernDialog> createState() => _ModernDialogState();
}

class _ModernDialogState extends State<ModernDialog>
    with SingleTickerProviderStateMixin, ScaleAnimationMixin {
  @override
  void initState() {
    super.initState();
    initializeScaleAnimation();
    startScaleAnimation();
  }

  @override
  void dispose() {
    disposeScaleAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildScaleTransition(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: GlassmorphicCard(
          borderRadius: 24,
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.title != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Text(
                    widget.title!,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              Padding(
                padding: widget.contentPadding ?? 
                    EdgeInsets.fromLTRB(24, widget.title != null ? 0 : 24, 24, 24),
                child: widget.content,
              ),
              if (widget.actions != null && widget.actions!.isNotEmpty)
                Padding(
                  padding: widget.actionsPadding ?? 
                      const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: widget.actions!
                        .asMap()
                        .entries
                        .map((entry) {
                          final index = entry.key;
                          final action = entry.value;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: index > 0 ? 8 : 0,
                                right: index < widget.actions!.length - 1 ? 8 : 0,
                              ),
                              child: action,
                            ),
                          );
                        })
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Confirmation dialog utility
class ConfirmationDialog {
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDangerous = false,
  }) {
    return NavigationUtils.showCustomDialog<bool>(
      context: context,
      title: title,
      content: Text(message),
      actions: [
        GlassmorphicButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        GlassmorphicButton(
          onPressed: () => Navigator.of(context).pop(true),
          backgroundColor: isDangerous ? Colors.red : null,
          child: Text(confirmText),
        ),
      ],
    );
  }
}

/// Loading dialog utility
class LoadingDialog {
  static void show({
    required BuildContext context,
    String message = 'Loading...',
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => PopScope(
        canPop: barrierDismissible,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: GlassmorphicCard(
            borderRadius: 24,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

/// Hero animation utilities
class HeroUtils {
  /// Create hero transition for images
  static Widget createImageHero({
    required String tag,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return Hero(
      tag: tag,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }

  /// Navigate with hero animation
  static Future<T?> navigateWithHero<T>({
    required BuildContext context,
    required Widget destination,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.push(
      context,
      PageRouteBuilder<T>(
        pageBuilder: (context, primaryAnimation, secondaryAnimation) => destination,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
      ),
    );
  }
}

/// Route observer for analytics and navigation tracking
class NavigationObserver extends RouteObserver<PageRoute<dynamic>> {
  final Function(String)? onRouteChanged;

  NavigationObserver({this.onRouteChanged});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _trackRoute(route.settings.name ?? 'Unknown');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _trackRoute(newRoute.settings.name ?? 'Unknown');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute) {
      _trackRoute(previousRoute.settings.name ?? 'Unknown');
    }
  }

  void _trackRoute(String routeName) {
    onRouteChanged?.call(routeName);
    print('Navigation: $routeName');
  }
}

/// Page indicator for tab views
class ModernPageIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final Color? activeColor;
  final Color? inactiveColor;
  final double dotSize;
  final double spacing;
  final PageIndicatorStyle style;

  const ModernPageIndicator({
    Key? key,
    required this.currentIndex,
    required this.totalPages,
    this.activeColor,
    this.inactiveColor,
    this.dotSize = 8.0,
    this.spacing = 8.0,
    this.style = PageIndicatorStyle.dots,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeClr = activeColor ?? theme.colorScheme.primary;
    final inactiveClr = inactiveColor ?? theme.colorScheme.onSurface.withOpacity(0.3);

    switch (style) {
      case PageIndicatorStyle.dots:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(totalPages, (index) {
            final isActive = index == currentIndex;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: spacing / 2),
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? activeClr : inactiveClr,
              ),
            );
          }),
        );
      case PageIndicatorStyle.bars:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(totalPages, (index) {
            final isActive = index == currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: spacing / 2),
              width: isActive ? dotSize * 2 : dotSize,
              height: dotSize / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(dotSize / 4),
                color: isActive ? activeClr : inactiveClr,
              ),
            );
          }),
        );
      case PageIndicatorStyle.worm:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(totalPages, (index) {
            final isActive = index == currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: spacing / 2),
              width: isActive ? dotSize * 2.5 : dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(dotSize / 2),
                color: isActive ? activeClr : inactiveClr,
              ),
            );
          }),
        );
    }
  }
}

enum PageIndicatorStyle {
  dots,
  bars,
  worm,
}

/// Navigation extensions for easy usage
extension NavigationExtensions on BuildContext {
  /// Quick navigation methods
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  void pop<T>([T? result]) {
    return Navigator.of(this).pop(result);
  }

  void popUntil(bool Function(Route<dynamic>) predicate) {
    return Navigator.of(this).popUntil(predicate);
  }

  /// Quick snack bar methods
  void showSuccessSnackBar(String message) {
    NavigationUtils.showModernSnackBar(
      context: this,
      message: message,
      type: SnackBarType.success,
    );
  }

  void showErrorSnackBar(String message) {
    NavigationUtils.showModernSnackBar(
      context: this,
      message: message,
      type: SnackBarType.error,
    );
  }

  void showWarningSnackBar(String message) {
    NavigationUtils.showModernSnackBar(
      context: this,
      message: message,
      type: SnackBarType.warning,
    );
  }

  void showInfoSnackBar(String message) {
    NavigationUtils.showModernSnackBar(
      context: this,
      message: message,
      type: SnackBarType.info,
    );
  }
}