import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';

/// Comprehensive theme management system with dynamic switching
/// 
/// Features:
/// - Dynamic theme switching
/// - System theme detection
/// - Custom color schemes
/// - Smooth transitions
/// - Persistence support
/// - Accessibility features

class ThemeManager extends ChangeNotifier {
  static ThemeManager? _instance;
  static ThemeManager get instance => _instance ??= ThemeManager._internal();
  
  ThemeManager._internal() {
    _initializeTheme();
  }
  
  ThemeMode _themeMode = ThemeMode.system;
  bool _isDarkMode = false;
  ColorScheme? _customColorScheme;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;
  ColorScheme? get customColorScheme => _customColorScheme;
  
  void _initializeTheme() {
    // Detect system theme
    final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    _isDarkMode = brightness == Brightness.dark;
    
    // Listen to system theme changes
    SchedulerBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      final newBrightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      if (_themeMode == ThemeMode.system) {
        _isDarkMode = newBrightness == Brightness.dark;
        notifyListeners();
      }
    };
  }
  
  /// Set theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _updateDarkMode();
    notifyListeners();
  }
  
  /// Toggle between light and dark theme
  void toggleTheme() {
    if (_themeMode == ThemeMode.system) {
      setThemeMode(_isDarkMode ? ThemeMode.light : ThemeMode.dark);
    } else {
      setThemeMode(_themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
    }
  }
  
  /// Set custom color scheme
  void setCustomColorScheme(ColorScheme colorScheme) {
    _customColorScheme = colorScheme;
    notifyListeners();
  }
  
  /// Clear custom color scheme
  void clearCustomColorScheme() {
    _customColorScheme = null;
    notifyListeners();
  }
  
  void _updateDarkMode() {
    switch (_themeMode) {
      case ThemeMode.light:
        _isDarkMode = false;
        break;
      case ThemeMode.dark:
        _isDarkMode = true;
        break;
      case ThemeMode.system:
        final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
        _isDarkMode = brightness == Brightness.dark;
        break;
    }
  }
  
  /// Get the current theme data
  ThemeData getThemeData({bool isDark = false}) {
    final colorScheme = _customColorScheme ?? 
        (isDark ? _darkColorScheme : _lightColorScheme);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: isDark ? Brightness.dark : Brightness.light,
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: colorScheme.surface,
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surface,
        selectedColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      
      // Navigation Rail Theme
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurface.withOpacity(0.6)),
        selectedLabelTextStyle: TextStyle(color: colorScheme.primary),
        unselectedLabelTextStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      
      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  /// Light color scheme
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF6750A4),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF625B71),
    onSecondary: Color(0xFFFFFFFF),
    tertiary: Color(0xFF7D5260),
    onTertiary: Color(0xFFFFFFFF),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    background: Color(0xFFFFFBFE),
    onBackground: Color(0xFF1C1B1F),
    surface: Color(0xFFFFFBFE),
    onSurface: Color(0xFF1C1B1F),
    surfaceVariant: Color(0xFFE7E0EC),
    onSurfaceVariant: Color(0xFF49454F),
    outline: Color(0xFF79747E),
    onInverseSurface: Color(0xFFF4EFF4),
    inverseSurface: Color(0xFF313033),
    inversePrimary: Color(0xFFD0BCFF),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF6750A4),
  );
  
  /// Dark color scheme
  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFD0BCFF),
    onPrimary: Color(0xFF381E72),
    secondary: Color(0xFFCCC2DC),
    onSecondary: Color(0xFF332D41),
    tertiary: Color(0xFFEFB8C8),
    onTertiary: Color(0xFF492532),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    background: Color(0xFF1C1B1F),
    onBackground: Color(0xFFE6E1E5),
    surface: Color(0xFF1C1B1F),
    onSurface: Color(0xFFE6E1E5),
    surfaceVariant: Color(0xFF49454F),
    onSurfaceVariant: Color(0xFFCAC4D0),
    outline: Color(0xFF938F99),
    onInverseSurface: Color(0xFF1C1B1F),
    inverseSurface: Color(0xFFE6E1E5),
    inversePrimary: Color(0xFF6750A4),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFD0BCFF),
  );
}

/// Theme provider widget
class ThemeProvider extends StatefulWidget {
  final Widget child;
  
  const ThemeProvider({
    Key? key,
    required this.child,
  }) : super(key: key);
  
  @override
  State<ThemeProvider> createState() => _ThemeProviderState();
}

class _ThemeProviderState extends State<ThemeProvider> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    ThemeManager.instance.addListener(_onThemeChanged);
  }
  
  @override
  void dispose() {
    ThemeManager.instance.removeListener(_onThemeChanged);
    _animationController.dispose();
    super.dispose();
  }
  
  void _onThemeChanged() {
    _animationController.forward(from: 0);
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeManager.instance,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return MaterialApp(
              theme: ThemeManager.instance.getThemeData(isDark: false),
              darkTheme: ThemeManager.instance.getThemeData(isDark: true),
              themeMode: ThemeManager.instance.themeMode,
              home: widget.child,
            );
          },
        );
      },
    );
  }
}

/// Theme switcher widget
class ThemeSwitcher extends StatefulWidget {
  final String? semanticLabel;
  
  const ThemeSwitcher({
    Key? key,
    this.semanticLabel,
  }) : super(key: key);
  
  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> 
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
    
    if (ThemeManager.instance.isDarkMode) {
      _controller.value = 1.0;
    }
    
    ThemeManager.instance.addListener(_onThemeChanged);
  }
  
  @override
  void dispose() {
    ThemeManager.instance.removeListener(_onThemeChanged);
    _controller.dispose();
    super.dispose();
  }
  
  void _onThemeChanged() {
    if (ThemeManager.instance.isDarkMode) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel ?? 'Theme switcher',
      button: true,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          ThemeManager.instance.toggleTheme();
        },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.lerp(
                  Colors.orange.shade300,
                  Colors.indigo.shade300,
                  _animation.value,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _animation.value > 0.5 ? Icons.dark_mode : Icons.light_mode,
                color: Colors.white,
                size: 24,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Predefined color schemes
class ColorSchemes {
  static const ColorScheme blue = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2196F3),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF03DAC6),
    onSecondary: Color(0xFF000000),
    tertiary: Color(0xFFFF5722),
    onTertiary: Color(0xFFFFFFFF),
    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),
    background: Color(0xFFFFFBFE),
    onBackground: Color(0xFF1C1B1F),
    surface: Color(0xFFFFFBFE),
    onSurface: Color(0xFF1C1B1F),
    surfaceVariant: Color(0xFFE7E0EC),
    onSurfaceVariant: Color(0xFF49454F),
    outline: Color(0xFF79747E),
    onInverseSurface: Color(0xFFF4EFF4),
    inverseSurface: Color(0xFF313033),
    inversePrimary: Color(0xFFBB86FC),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF2196F3),
  );
  
  static const ColorScheme green = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF4CAF50),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF81C784),
    onSecondary: Color(0xFF000000),
    tertiary: Color(0xFFFFC107),
    onTertiary: Color(0xFF000000),
    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),
    background: Color(0xFFFFFBFE),
    onBackground: Color(0xFF1C1B1F),
    surface: Color(0xFFFFFBFE),
    onSurface: Color(0xFF1C1B1F),
    surfaceVariant: Color(0xFFE7E0EC),
    onSurfaceVariant: Color(0xFF49454F),
    outline: Color(0xFF79747E),
    onInverseSurface: Color(0xFFF4EFF4),
    inverseSurface: Color(0xFF313033),
    inversePrimary: Color(0xFFA5D6A7),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF4CAF50),
  );
  
  static const ColorScheme purple = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF9C27B0),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFE1BEE7),
    onSecondary: Color(0xFF000000),
    tertiary: Color(0xFFFF9800),
    onTertiary: Color(0xFFFFFFFF),
    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),
    background: Color(0xFFFFFBFE),
    onBackground: Color(0xFF1C1B1F),
    surface: Color(0xFFFFFBFE),
    onSurface: Color(0xFF1C1B1F),
    surfaceVariant: Color(0xFFE7E0EC),
    onSurfaceVariant: Color(0xFF49454F),
    outline: Color(0xFF79747E),
    onInverseSurface: Color(0xFFF4EFF4),
    inverseSurface: Color(0xFF313033),
    inversePrimary: Color(0xFFCE93D8),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF9C27B0),
  );
}