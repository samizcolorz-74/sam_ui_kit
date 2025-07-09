import 'package:flutter/material.dart';
import '../utils/navigation_utils.dart';

/// Context extensions for convenient navigation and UI operations
extension ContextExtensions on BuildContext {
  /// Theme shortcuts
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  
  /// Screen size utilities
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  bool get isSmallScreen => screenWidth < 600;
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;
  bool get isLargeScreen => screenWidth >= 1200;
  
  /// Responsive values
  double get responsivePadding => isSmallScreen ? 16.0 : 24.0;
  double get responsiveMargin => isSmallScreen ? 8.0 : 16.0;
  double get responsiveRadius => isSmallScreen ? 12.0 : 16.0;
  
  /// Navigation shortcuts
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }

  void pop<T>([T? result]) {
    return Navigator.of(this).pop(result);
  }

  /// Snackbar shortcuts
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

  /// Bottom sheet shortcuts
  Future<T?> showModernBottomSheet<T>(Widget child, {String? title}) {
    return NavigationUtils.showModernBottomSheet<T>(
      context: this,
      child: child,
      title: title,
    );
  }

  /// Dialog shortcuts
  Future<T?> showCustomDialog<T>(Widget content, {String? title}) {
    return NavigationUtils.showCustomDialog<T>(
      context: this,
      content: content,
      title: title,
    );
  }

  /// Focus utilities
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  void requestFocus(FocusNode node) {
    FocusScope.of(this).requestFocus(node);
  }

  /// Accessibility utilities
  bool get isAccessibilityEnabled => MediaQuery.of(this).accessibleNavigation;
  bool get isHighContrast => MediaQuery.of(this).highContrast;
  double get textScaleFactor => MediaQuery.of(this).textScaleFactor;
  
  /// Safe area utilities
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
  
  /// Orientation utilities
  Orientation get orientation => MediaQuery.of(this).orientation;
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;
}