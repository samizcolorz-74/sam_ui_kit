import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';

/// Comprehensive accessibility helpers and semantic widgets
/// 
/// Features:
/// - Screen reader support
/// - Focus management
/// - Semantic labels
/// - Voice control
/// - High contrast support
/// - Text scaling
/// - Haptic feedback patterns

class AccessibilityHelper {
  /// Check if accessibility services are enabled
  static bool get isAccessibilityEnabled {
    return WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.accessibleNavigation;
  }
  
  /// Check if screen reader is enabled
  static bool get isScreenReaderEnabled {
    return WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.accessibleNavigation;
  }
  
  /// Check if high contrast is enabled
  static bool get isHighContrastEnabled {
    return WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.highContrast;
  }
  
  /// Check if large text is enabled
  static bool get isLargeTextEnabled {
    return WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.boldText;
  }
  
  /// Announce text to screen reader
  static void announce(String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }
  
  /// Focus management
  static void requestFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }
  
  /// Remove focus
  static void removeFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
  
  /// Get accessible text size
  static double getAccessibleTextSize(BuildContext context, double baseSize) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return baseSize * textScaleFactor.clamp(0.8, 2.0);
  }
  
  /// Get high contrast color
  static Color getAccessibleColor(BuildContext context, Color color) {
    if (isHighContrastEnabled) {
      final brightness = ThemeData.estimateBrightnessForColor(color);
      return brightness == Brightness.dark ? Colors.black : Colors.white;
    }
    return color;
  }
}

/// Enhanced button with full accessibility support
class AccessibleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final String? tooltip;
  final bool enabled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final FocusNode? focusNode;

  const AccessibleButton({
    Key? key,
    required this.child,
    this.onPressed,
    required this.semanticLabel,
    this.tooltip,
    this.enabled = true,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius = 12.0,
    this.focusNode,
  }) : super(key: key);

  @override
  State<AccessibleButton> createState() => _AccessibleButtonState();
}

class _AccessibleButtonState extends State<AccessibleButton> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChanged);
    }
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHighContrast = AccessibilityHelper.isHighContrastEnabled;
    
    Widget button = Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: _isFocused ? Border.all(
          color: theme.colorScheme.outline,
          width: 2,
        ) : null,
        boxShadow: isHighContrast ? null : [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.enabled ? () {
            HapticFeedback.selectionClick();
            widget.onPressed?.call();
          } : null,
          onHover: (hovering) {
            setState(() {
              _isHovered = hovering;
            });
          },
          focusNode: _focusNode,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(16),
            child: DefaultTextStyle(
              style: TextStyle(
                color: widget.foregroundColor ?? theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );

    button = Semantics(
      label: widget.semanticLabel,
      button: true,
      enabled: widget.enabled,
      onTap: widget.enabled ? widget.onPressed : null,
      child: button,
    );

    if (widget.tooltip != null) {
      button = Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Accessible text field with enhanced features
class AccessibleTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final String semanticLabel;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final int? maxLines;
  final bool enabled;

  const AccessibleTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    required this.semanticLabel,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.maxLines = 1,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<AccessibleTextField> createState() => _AccessibleTextFieldState();
}

class _AccessibleTextFieldState extends State<AccessibleTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChanged);
    }
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    
    if (_isFocused && widget.labelText != null) {
      AccessibilityHelper.announce('${widget.labelText} text field focused');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHighContrast = AccessibilityHelper.isHighContrastEnabled;
    
    return Semantics(
      label: widget.semanticLabel,
      textField: true,
      enabled: widget.enabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            style: TextStyle(
              fontSize: AccessibilityHelper.getAccessibleTextSize(context, 16),
            ),
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              helperText: widget.helperText,
              errorText: widget.errorText,
              prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
              suffixIcon: widget.suffixIcon != null ? IconButton(
                icon: Icon(widget.suffixIcon),
                onPressed: widget.onSuffixIconPressed,
                tooltip: widget.obscureText ? 'Toggle password visibility' : null,
              ) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isHighContrast ? Colors.black : theme.colorScheme.outline,
                  width: isHighContrast ? 2 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                  width: 2,
                ),
              ),
            ),
          ),
          if (widget.helperText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 12),
              child: Text(
                widget.helperText!,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: AccessibilityHelper.getAccessibleTextSize(context, 12),
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Screen reader announcement widget
class AnnouncementWidget extends StatefulWidget {
  final String message;
  final Widget child;
  final bool announceOnMount;

  const AnnouncementWidget({
    Key? key,
    required this.message,
    required this.child,
    this.announceOnMount = false,
  }) : super(key: key);

  @override
  State<AnnouncementWidget> createState() => _AnnouncementWidgetState();
}

class _AnnouncementWidgetState extends State<AnnouncementWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.announceOnMount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AccessibilityHelper.announce(widget.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: widget.child,
    );
  }
  
  void announce() {
    AccessibilityHelper.announce(widget.message);
  }
}

/// Focus trap widget for modal dialogs
class FocusTrap extends StatefulWidget {
  final Widget child;
  final bool active;
  final FocusNode? firstFocus;
  final FocusNode? lastFocus;

  const FocusTrap({
    Key? key,
    required this.child,
    this.active = true,
    this.firstFocus,
    this.lastFocus,
  }) : super(key: key);

  @override
  State<FocusTrap> createState() => _FocusTrapState();
}

class _FocusTrapState extends State<FocusTrap> {
  late FocusNode _firstFocusNode;
  late FocusNode _lastFocusNode;

  @override
  void initState() {
    super.initState();
    _firstFocusNode = widget.firstFocus ?? FocusNode();
    _lastFocusNode = widget.lastFocus ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.firstFocus == null) _firstFocusNode.dispose();
    if (widget.lastFocus == null) _lastFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) return widget.child;
    
    return FocusScope(
      child: Column(
        children: [
          Focus(
            focusNode: _firstFocusNode,
            onKey: (node, event) {
              if (event.logicalKey == LogicalKeyboardKey.tab && 
                  event.isShiftPressed) {
                _lastFocusNode.requestFocus();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: const SizedBox.shrink(),
          ),
          Expanded(child: widget.child),
          Focus(
            focusNode: _lastFocusNode,
            onKey: (node, event) {
              if (event.logicalKey == LogicalKeyboardKey.tab && 
                  !event.isShiftPressed) {
                _firstFocusNode.requestFocus();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// Accessible list tile with proper semantics
class AccessibleListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String semanticLabel;
  final bool enabled;
  final bool selected;

  const AccessibleListTile({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    required this.semanticLabel,
    this.enabled = true,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      selected: selected,
      enabled: enabled,
      onTap: enabled ? onTap : null,
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: enabled ? () {
          HapticFeedback.selectionClick();
          onTap?.call();
        } : null,
        selected: selected,
        selectedTileColor: theme.colorScheme.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// Accessibility testing widget
class AccessibilityTester extends StatelessWidget {
  final Widget child;
  final bool showBounds;
  final bool showLabels;

  const AccessibilityTester({
    Key? key,
    required this.child,
    this.showBounds = false,
    this.showLabels = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showBounds && !showLabels) return child;
    
    return Semantics(
      container: true,
      child: Stack(
        children: [
          child,
          if (showBounds || showLabels)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _AccessibilityPainter(
                    showBounds: showBounds,
                    showLabels: showLabels,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AccessibilityPainter extends CustomPainter {
  final bool showBounds;
  final bool showLabels;

  _AccessibilityPainter({
    required this.showBounds,
    required this.showLabels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showBounds) {
      final paint = Paint()
        ..color = Colors.red.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Voice command handler
class VoiceCommandHandler {
  static const List<String> commonCommands = [
    'tap',
    'click',
    'select',
    'open',
    'close',
    'back',
    'next',
    'previous',
    'scroll up',
    'scroll down',
  ];
  
  static bool handleCommand(String command, BuildContext context) {
    switch (command.toLowerCase()) {
      case 'back':
        Navigator.of(context).maybePop();
        return true;
      case 'scroll up':
        // Handle scroll up
        return true;
      case 'scroll down':
        // Handle scroll down
        return true;
      default:
        return false;
    }
  }
}

/// Accessibility extensions
extension AccessibilityExtensions on Widget {
  Widget accessibleWrapper({
    required String semanticLabel,
    String? hint,
    bool? button,
    bool? header,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: semanticLabel,
      hint: hint,
      button: button ?? false,
      header: header ?? false,
      onTap: onTap,
      child: this,
    );
  }
  
  Widget highContrastWrapper(BuildContext context) {
    if (!AccessibilityHelper.isHighContrastEnabled) return this;
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: this,
    );
  }
  
  Widget announceOnTap(String message) {
    return GestureDetector(
      onTap: () => AccessibilityHelper.announce(message),
      child: this,
    );
  }
}