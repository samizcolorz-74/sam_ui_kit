# Sam's UI Kit

A comprehensive Flutter UI components library featuring modern glassmorphism effects, accessibility-first design, and responsive utilities.

## ✨ Features

- **🎨 Glassmorphism Effects**: Modern frosted glass UI with backdrop blur
- **♿ Accessibility First**: Full screen reader, high contrast, and keyboard navigation support
- **📱 Responsive Design**: Adaptive layouts for all screen sizes
- **🌙 Dark Mode**: Seamless theme switching with smooth transitions
- **🎯 Material Design 3**: Latest design language implementation
- **⚡ Performance Optimized**: Efficient animations and rendering
- **📦 Modular**: Use only what you need
- **🔧 Customizable**: Extensive customization options

## 🚀 Installation

Add this package to your Flutter project:

```yaml
dependencies:
  sam_ui_kit:
    path: lib/packages/sam_ui_kit
```

## 📋 Quick Start

### Basic Setup

```dart
import 'package:sam_ui_kit/sam_ui_kit.dart';

void main() {
  runApp(
    ThemeProvider(
      child: MyApp(),
    ),
  );
}
```

### Basic Components

```dart
// Glassmorphic Card
GlassmorphicCard(
  child: Text('Beautiful glassmorphic card'),
  onTap: () => print('Tapped!'),
)

// Modern Button with Loading State
ModernLoadingButton(
  text: 'Submit',
  onPressed: _handleSubmit,
  isLoading: _isLoading,
)

// Smart Image with Caching
SmartImage(
  imageUrl: 'https://example.com/image.jpg',
  borderRadius: BorderRadius.circular(12),
  semanticLabel: 'Profile picture',
)
```

## 🎯 Components Overview

### Core Components
- **GlassmorphicCard**: Frosted glass container with blur effects
- **GlassmorphicButton**: Interactive button with glass styling
- **GlassmorphicTextField**: Input field with modern glassmorphic design
- **GlassmorphicBottomSheet**: Modal bottom sheet with blur background
- **GlassmorphicAppBar**: Transparent app bar with glassmorphic effects

### Modern UI Components
- **ModernLoadingButton**: Button with integrated loading states
- **ModernProgressIndicator**: Circular progress with smooth animations
- **ModernCard**: Enhanced card with hover effects
- **ModernSearchBar**: Animated search input field
- **ModernToggleSwitch**: Custom styled toggle switch

### Loading & Skeleton
- **SkeletonLoader**: Shimmer effect wrapper for loading states
- **SkeletonCard**: Pre-built card skeleton layout
- **ModernLoadingIndicator**: Various loading animation styles
- **LoadingOverlay**: Full-screen loading overlay

### Image Components
- **SmartImage**: Intelligent image widget with caching
- **SmartAvatar**: Avatar with fallback options
- **ImageCarousel**: Modern image carousel with indicators
- **ImageGrid**: Grid layout for image galleries

### Navigation & Modals
- **NavigationUtils**: Custom navigation with animations
- **ModernDialog**: Glassmorphic dialog components
- **ConfirmationDialog**: Pre-built confirmation dialogs
- **LoadingDialog**: Loading state dialogs

### Gesture & Haptic
- **HapticGestureDetector**: Enhanced gesture detection with haptic feedback
- **SwipeGestureDetector**: Swipe gesture recognition
- **LongPressGestureDetector**: Long press with visual feedback
- **MultiTouchGestureDetector**: Multi-touch handling

## 🎨 Theme System

### Theme Setup
```dart
// Initialize theme provider
ThemeProvider(
  child: MyApp(),
)

// Toggle theme
ThemeManager.instance.toggleTheme();

// Set custom color scheme
ThemeManager.instance.setCustomColorScheme(ColorSchemes.blue);
```

### Custom Color Schemes
```dart
// Define custom colors
final customScheme = ColorScheme.fromSeed(
  seedColor: Colors.purple,
  brightness: Brightness.dark,
);

ThemeManager.instance.setCustomColorScheme(customScheme);
```

## 🛠️ Customization Examples

### Custom Glassmorphic Card
```dart
GlassmorphicCard(
  borderRadius: 20.0,
  blurX: 15.0,
  blurY: 15.0,
  backgroundColor: Colors.white.withOpacity(0.1),
  borderColor: Colors.white.withOpacity(0.2),
  child: YourContent(),
)
```

### Responsive Layout
```dart
Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(context.responsivePadding),
    child: Column(
      children: [
        if (context.isLargeScreen) 
          LargeScreenLayout()
        else 
          MobileLayout(),
      ],
    ),
  );
}
```

### Animation Mixins
```dart
class MyWidget extends StatefulWidget {
  // ...
}

class _MyWidgetState extends State<MyWidget> 
    with TickerProviderStateMixin, FadeAnimationMixin {
  
  @override
  void initState() {
    super.initState();
    initializeFadeAnimation();
    startFadeAnimation();
  }
  
  @override
  Widget build(BuildContext context) {
    return buildFadeTransition(
      Text('Animated text'),
    );
  }
}
```

## ♿ Accessibility Features

### Screen Reader Support
```dart
AccessibleButton(
  semanticLabel: 'Save document',
  onPressed: _saveDocument,
  child: Text('Save'),
)
```

### High Contrast Support
```dart
// Components automatically adapt to high contrast mode
if (context.isHighContrast) {
  // Custom high contrast handling
}
```

### Keyboard Navigation
```dart
// Focus management
FocusTrap(
  child: ModalContent(),
)

// Screen reader announcements
AnnouncementWidget(
  message: 'Form submitted successfully',
  child: YourContent(),
)
```

## 🔧 Advanced Usage

### Custom Haptic Patterns
```dart
// Define custom haptic pattern
HapticManager.customPattern([
  HapticEvent(type: HapticType.light),
  HapticEvent(type: HapticType.medium, delay: Duration(milliseconds: 100)),
]);

// Use with gestures
Widget().withHapticTap(
  onTap: () => print('Tapped with haptic'),
  context: HapticContext.success,
);
```

### Image Optimization
```dart
SmartImage(
  imageUrl: 'https://example.com/large-image.jpg',
  cacheWidth: 300,
  cacheHeight: 300,
  placeholder: SkeletonBox(width: 300, height: 300),
  errorWidget: ErrorStateWidget(),
)
```

### Navigation Animations
```dart
// Custom navigation with animation
NavigationUtils.navigateWithAnimation(
  context: context,
  destination: NextScreen(),
  animation: NavigationAnimation.slideFromRight,
);

// Modern bottom sheet
context.showModernBottomSheet(
  BottomSheetContent(),
  title: 'Select Option',
);
```

## 📊 Performance Tips

1. **Use Skeleton Loading**: Always show loading states
2. **Optimize Images**: Use cacheWidth and cacheHeight
3. **Minimize Rebuilds**: Use const constructors where possible
4. **Dispose Resources**: Properly dispose animation controllers
5. **Use Extensions**: Leverage widget and context extensions

## 🔍 Debugging

Enable debug mode to see component boundaries and performance metrics:

```dart
// Enable debug mode
SamUIKitDebugConfig.enabled = true;

// Show performance overlay
SamUIKitDebugConfig.showPerformanceOverlay = true;
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- Community contributors for feedback and improvements

---

**Made with ❤️ by Sam (BarkCrush Development Team)**