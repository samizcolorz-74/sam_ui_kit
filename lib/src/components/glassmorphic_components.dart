import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

/// A comprehensive glassmorphic components library for modern mobile apps
/// 
/// Features:
/// - Glassmorphism effects with backdrop blur
/// - Dark mode support
/// - Accessibility features
/// - Smooth animations
/// - Responsive design
/// - Haptic feedback

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurX;
  final double blurY;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final double? width;
  final double? height;

  const GlassmorphicCard({
    Key? key,
    required this.child,
    this.borderRadius = 20.0,
    this.blurX = 10.0,
    this.blurY = 10.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.padding,
    this.margin,
    this.shadows,
    this.onTap,
    this.semanticLabel,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final defaultBackgroundColor = backgroundColor ?? 
        (isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.2));
    
    final defaultBorderColor = borderColor ?? 
        (isDarkMode ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.3));

    final defaultShadows = shadows ?? [
      BoxShadow(
        color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ];

    Widget cardWidget = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: defaultShadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
          child: Container(
            decoration: BoxDecoration(
              color: defaultBackgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: defaultBorderColor,
                width: borderWidth,
              ),
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      cardWidget = Semantics(
        label: semanticLabel ?? 'Interactive card',
        button: true,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              onTap!();
            },
            borderRadius: BorderRadius.circular(borderRadius),
            child: cardWidget,
          ),
        ),
      );
    } else if (semanticLabel != null) {
      cardWidget = Semantics(
        label: semanticLabel,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}

class GlassmorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final bool isLoading;
  final String? semanticLabel;
  final double? width;
  final double? height;

  const GlassmorphicButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.isLoading = false,
    this.semanticLabel,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<GlassmorphicButton> createState() => _GlassmorphicButtonState();
}

class _GlassmorphicButtonState extends State<GlassmorphicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final defaultBackgroundColor = widget.backgroundColor ?? 
        Theme.of(context).colorScheme.primary.withOpacity(0.8);
    
    final defaultBorderColor = widget.borderColor ?? 
        Theme.of(context).colorScheme.primary.withOpacity(0.5);

    return Semantics(
      label: widget.semanticLabel ?? 'Button',
      button: true,
      enabled: widget.onPressed != null && !widget.isLoading,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: defaultBackgroundColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: Border.all(
                        color: defaultBorderColor,
                        width: widget.borderWidth,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onPressed != null && !widget.isLoading
                            ? () {
                                HapticFeedback.mediumImpact();
                                widget.onPressed!();
                              }
                            : null,
                        onTapDown: (_) => _animationController.forward(),
                        onTapUp: (_) => _animationController.reverse(),
                        onTapCancel: () => _animationController.reverse(),
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        child: Container(
                          padding: widget.padding,
                          child: widget.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : widget.child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GlassmorphicTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final String? semanticLabel;
  final bool enabled;

  const GlassmorphicTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.semanticLabel,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<GlassmorphicTextField> createState() => _GlassmorphicTextFieldState();
}

class _GlassmorphicTextFieldState extends State<GlassmorphicTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_isFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Semantics(
      label: widget.semanticLabel ?? widget.labelText ?? widget.hintText ?? 'Text field',
      textField: true,
      enabled: widget.enabled,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _isFocused
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.3 * _glowAnimation.value)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: _isFocused ? 20 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isFocused
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                          : Colors.white.withOpacity(0.3),
                      width: _isFocused ? 2 : 1,
                    ),
                  ),
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    obscureText: widget.obscureText,
                    keyboardType: widget.keyboardType,
                    validator: widget.validator,
                    onChanged: widget.onChanged,
                    onFieldSubmitted: widget.onSubmitted,
                    autofocus: widget.autofocus,
                    maxLines: widget.maxLines,
                    minLines: widget.minLines,
                    enabled: widget.enabled,
                    onTap: () {
                      HapticFeedback.selectionClick();
                    },
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      labelText: widget.labelText,
                      prefixIcon: widget.prefixIcon != null
                          ? Icon(
                              widget.prefixIcon,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : null,
                      suffixIcon: widget.suffixIcon != null
                          ? IconButton(
                              icon: Icon(
                                widget.suffixIcon,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                widget.onSuffixIconPressed?.call();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}

class GlassmorphicBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showHandle;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const GlassmorphicBottomSheet({
    Key? key,
    required this.child,
    this.title,
    this.showHandle = true,
    this.borderRadius = 24.0,
    this.padding = const EdgeInsets.all(20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        topRight: Radius.circular(borderRadius),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showHandle)
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                if (title != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Padding(
                  padding: padding!,
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool showHandle = true,
    double borderRadius = 24.0,
    EdgeInsetsGeometry? padding = const EdgeInsets.all(20),
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GlassmorphicBottomSheet(
        title: title,
        showHandle: showHandle,
        borderRadius: borderRadius,
        padding: padding,
        child: child,
      ),
    );
  }
}

class GlassmorphicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double blurX;
  final double blurY;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const GlassmorphicAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.blurX = 10.0,
    this.blurY = 10.0,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Semantics(
      label: 'App bar with title: $title',
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurX, sigmaY: blurY),
          child: Container(
            color: backgroundColor ?? 
                (isDarkMode ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2)),
            child: AppBar(
              title: Text(title),
              actions: actions,
              leading: leading,
              centerTitle: centerTitle,
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: foregroundColor ?? 
                  (isDarkMode ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Utility class for consistent glassmorphic styling
class GlassmorphicTheme {
  static const double defaultBorderRadius = 16.0;
  static const double defaultBlur = 10.0;
  static const double defaultBorderWidth = 1.0;
  
  static Color backgroundLight = Colors.white.withOpacity(0.2);
  static Color backgroundDark = Colors.white.withOpacity(0.1);
  
  static Color borderLight = Colors.white.withOpacity(0.3);
  static Color borderDark = Colors.white.withOpacity(0.2);
  
  static BoxShadow shadowLight = BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 15,
    offset: const Offset(0, 8),
  );
  
  static BoxShadow shadowDark = BoxShadow(
    color: Colors.black.withOpacity(0.3),
    blurRadius: 15,
    offset: const Offset(0, 8),
  );
}