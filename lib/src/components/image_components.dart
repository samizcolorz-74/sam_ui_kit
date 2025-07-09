import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'glassmorphic_components.dart';
import 'loading_skeleton.dart';

/// Comprehensive image handling and caching components
/// 
/// Features:
/// - Smart caching system
/// - Progressive loading
/// - Error handling
/// - Placeholder management
/// - Image optimization
/// - Accessibility support
/// - Network resilience

class SmartImage extends StatefulWidget {
  final String? imageUrl;
  final String? assetPath;
  final File? imageFile;
  final Uint8List? imageBytes;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final String? semanticLabel;
  final bool enableCaching;
  final Duration cacheDuration;
  final int? cacheWidth;
  final int? cacheHeight;
  final bool showLoadingProgress;
  final Color? backgroundColor;

  const SmartImage({
    Key? key,
    this.imageUrl,
    this.assetPath,
    this.imageFile,
    this.imageBytes,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.semanticLabel,
    this.enableCaching = true,
    this.cacheDuration = const Duration(days: 7),
    this.cacheWidth,
    this.cacheHeight,
    this.showLoadingProgress = true,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<SmartImage> createState() => _SmartImageState();
}

class _SmartImageState extends State<SmartImage> {
  bool _isLoading = false;
  bool _hasError = false;
  double? _loadingProgress;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    
    if (widget.imageBytes != null) {
      imageWidget = _buildMemoryImage();
    } else if (widget.imageFile != null) {
      imageWidget = _buildFileImage();
    } else if (widget.assetPath != null) {
      imageWidget = _buildAssetImage();
    } else if (widget.imageUrl != null) {
      imageWidget = _buildNetworkImage();
    } else {
      imageWidget = _buildErrorWidget();
    }

    if (widget.borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: widget.borderRadius!,
        child: imageWidget,
      );
    }

    if (widget.semanticLabel != null) {
      imageWidget = Semantics(
        label: widget.semanticLabel,
        image: true,
        child: imageWidget,
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
      ),
      child: imageWidget,
    );
  }

  Widget _buildNetworkImage() {
    return Image.network(
      widget.imageUrl!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      cacheWidth: widget.cacheWidth,
      cacheHeight: widget.cacheHeight,
      loadingBuilder: widget.showLoadingProgress ? (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        
        final progress = loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
            : null;
            
        return _buildLoadingWidget(progress);
      } : null,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget();
      },
    );
  }

  Widget _buildAssetImage() {
    return Image.asset(
      widget.assetPath!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      cacheWidth: widget.cacheWidth,
      cacheHeight: widget.cacheHeight,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget();
      },
    );
  }

  Widget _buildFileImage() {
    return Image.file(
      widget.imageFile!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      cacheWidth: widget.cacheWidth,
      cacheHeight: widget.cacheHeight,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget();
      },
    );
  }

  Widget _buildMemoryImage() {
    return Image.memory(
      widget.imageBytes!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      cacheWidth: widget.cacheWidth,
      cacheHeight: widget.cacheHeight,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget();
      },
    );
  }

  Widget _buildLoadingWidget(double? progress) {
    if (widget.placeholder != null) {
      return widget.placeholder!;
    }
    
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[200],
      child: Stack(
        alignment: Alignment.center,
        children: [
          SkeletonBox(
            width: widget.width,
            height: widget.height,
            borderRadius: 0,
          ),
          if (progress != null)
            CircularProgressIndicator(
              value: progress,
              strokeWidth: 2,
              backgroundColor: Colors.grey[300],
            )
          else
            const ModernLoadingIndicator(size: 32),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (widget.errorWidget != null) {
      return widget.errorWidget!;
    }
    
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[100],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            color: Colors.grey,
            size: 48,
          ),
          SizedBox(height: 8),
          Text(
            'Image not available',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Avatar component with fallback options
class SmartAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final File? imageFile;
  final String? initials;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final Widget? placeholder;
  final Widget? errorWidget;
  final String? semanticLabel;
  final VoidCallback? onTap;

  const SmartAvatar({
    Key? key,
    this.imageUrl,
    this.assetPath,
    this.imageFile,
    this.initials,
    this.radius = 20.0,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.placeholder,
    this.errorWidget,
    this.semanticLabel,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = imageUrl != null || assetPath != null || imageFile != null;
    
    Widget avatar;
    
    if (hasImage) {
      avatar = CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        child: ClipOval(
          child: SmartImage(
            imageUrl: imageUrl,
            assetPath: assetPath,
            imageFile: imageFile,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            placeholder: placeholder ?? _buildInitialsWidget(theme),
            errorWidget: errorWidget ?? _buildInitialsWidget(theme),
            semanticLabel: semanticLabel,
          ),
        ),
      );
    } else {
      avatar = CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        child: _buildInitialsWidget(theme),
      );
    }

    if (onTap != null) {
      avatar = GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap!();
        },
        child: avatar,
      );
    }

    if (semanticLabel != null) {
      avatar = Semantics(
        label: semanticLabel,
        image: true,
        button: onTap != null,
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _buildInitialsWidget(ThemeData theme) {
    if (initials == null || initials!.isEmpty) {
      return Icon(
        Icons.person,
        size: radius,
        color: textColor ?? theme.colorScheme.onPrimary,
      );
    }
    
    return Text(
      initials!,
      style: textStyle ?? TextStyle(
        color: textColor ?? theme.colorScheme.onPrimary,
        fontSize: radius * 0.7,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// Image carousel with modern design
class ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final List<String>? assetPaths;
  final List<File>? imageFiles;
  final double height;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final bool showIndicators;
  final bool showCounter;
  final BorderRadius? borderRadius;
  final String? semanticLabel;
  final Function(int)? onImageTap;

  const ImageCarousel({
    Key? key,
    this.imageUrls = const [],
    this.assetPaths,
    this.imageFiles,
    this.height = 200.0,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.showIndicators = true,
    this.showCounter = true,
    this.borderRadius,
    this.semanticLabel,
    this.onImageTap,
  }) : super(key: key);

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    if (widget.autoPlay && _totalImages > 1) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _totalImages {
    if (widget.imageFiles != null) return widget.imageFiles!.length;
    if (widget.assetPaths != null) return widget.assetPaths!.length;
    return widget.imageUrls.length;
  }

  void _startAutoPlay() {
    Future.delayed(widget.autoPlayInterval, () {
      if (mounted && _pageController.hasClients) {
        final nextIndex = (_currentIndex + 1) % _totalImages;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        if (widget.autoPlay) _startAutoPlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_totalImages == 0) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: widget.borderRadius,
        ),
        child: const Center(
          child: Text('No images available'),
        ),
      );
    }

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: _totalImages,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    widget.onImageTap?.call(index);
                  },
                  child: _buildImageAtIndex(index),
                );
              },
            ),
          ),
          
          // Indicators
          if (widget.showIndicators && _totalImages > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_totalImages, (index) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index 
                          ? Colors.white 
                          : Colors.white.withOpacity(0.5),
                    ),
                  );
                }),
              ),
            ),
          
          // Counter
          if (widget.showCounter && _totalImages > 1)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentIndex + 1}/$_totalImages',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageAtIndex(int index) {
    if (widget.imageFiles != null) {
      return SmartImage(
        imageFile: widget.imageFiles![index],
        width: double.infinity,
        height: widget.height,
        fit: BoxFit.cover,
        semanticLabel: '${widget.semanticLabel ?? 'Image'} ${index + 1} of $_totalImages',
      );
    } else if (widget.assetPaths != null) {
      return SmartImage(
        assetPath: widget.assetPaths![index],
        width: double.infinity,
        height: widget.height,
        fit: BoxFit.cover,
        semanticLabel: '${widget.semanticLabel ?? 'Image'} ${index + 1} of $_totalImages',
      );
    } else {
      return SmartImage(
        imageUrl: widget.imageUrls[index],
        width: double.infinity,
        height: widget.height,
        fit: BoxFit.cover,
        semanticLabel: '${widget.semanticLabel ?? 'Image'} ${index + 1} of $_totalImages',
      );
    }
  }
}

/// Image gallery with grid layout
class ImageGrid extends StatelessWidget {
  final List<String> imageUrls;
  final List<String>? assetPaths;
  final List<File>? imageFiles;
  final int crossAxisCount;
  final double aspectRatio;
  final double spacing;
  final BorderRadius? borderRadius;
  final Function(int)? onImageTap;
  final String? semanticLabel;

  const ImageGrid({
    Key? key,
    this.imageUrls = const [],
    this.assetPaths,
    this.imageFiles,
    this.crossAxisCount = 2,
    this.aspectRatio = 1.0,
    this.spacing = 8.0,
    this.borderRadius,
    this.onImageTap,
    this.semanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalImages = _getTotalImages();
    
    if (totalImages == 0) {
      return const Center(
        child: Text('No images available'),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        aspectRatio: aspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: totalImages,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onImageTap?.call(index);
          },
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            child: _buildImageAtIndex(index),
          ),
        );
      },
    );
  }

  int _getTotalImages() {
    if (imageFiles != null) return imageFiles!.length;
    if (assetPaths != null) return assetPaths!.length;
    return imageUrls.length;
  }

  Widget _buildImageAtIndex(int index) {
    if (imageFiles != null) {
      return SmartImage(
        imageFile: imageFiles![index],
        fit: BoxFit.cover,
        semanticLabel: '${semanticLabel ?? 'Image'} ${index + 1}',
      );
    } else if (assetPaths != null) {
      return SmartImage(
        assetPath: assetPaths![index],
        fit: BoxFit.cover,
        semanticLabel: '${semanticLabel ?? 'Image'} ${index + 1}',
      );
    } else {
      return SmartImage(
        imageUrl: imageUrls[index],
        fit: BoxFit.cover,
        semanticLabel: '${semanticLabel ?? 'Image'} ${index + 1}',
      );
    }
  }
}

/// Image picker component
class ImagePickerButton extends StatelessWidget {
  final Function(File)? onImageSelected;
  final String label;
  final IconData icon;
  final Widget? child;
  final double? width;
  final double? height;
  final String? semanticLabel;

  const ImagePickerButton({
    Key? key,
    this.onImageSelected,
    this.label = 'Select Image',
    this.icon = Icons.add_photo_alternate,
    this.child,
    this.width,
    this.height,
    this.semanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicButton(
      onPressed: () {
        _showImagePickerOptions(context);
      },
      width: width,
      height: height,
      semanticLabel: semanticLabel ?? label,
      child: child ?? Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    GlassmorphicBottomSheet.show(
      context: context,
      title: 'Select Image Source',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              _pickImageFromCamera();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              _pickImageFromGallery();
            },
          ),
        ],
      ),
    );
  }

  void _pickImageFromCamera() {
    // Implement camera image picking
    // This would typically use image_picker package
    print('Pick image from camera');
  }

  void _pickImageFromGallery() {
    // Implement gallery image picking
    // This would typically use image_picker package
    print('Pick image from gallery');
  }
}

/// Image zoom viewer
class ImageZoomViewer extends StatefulWidget {
  final String? imageUrl;
  final String? assetPath;
  final File? imageFile;
  final double minScale;
  final double maxScale;
  final String? semanticLabel;

  const ImageZoomViewer({
    Key? key,
    this.imageUrl,
    this.assetPath,
    this.imageFile,
    this.minScale = 1.0,
    this.maxScale = 4.0,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<ImageZoomViewer> createState() => _ImageZoomViewerState();
}

class _ImageZoomViewerState extends State<ImageZoomViewer> {
  late TransformationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: InteractiveViewer(
        transformationController: _controller,
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        child: Center(
          child: SmartImage(
            imageUrl: widget.imageUrl,
            assetPath: widget.assetPath,
            imageFile: widget.imageFile,
            fit: BoxFit.contain,
            semanticLabel: widget.semanticLabel,
          ),
        ),
      ),
    );
  }
}

/// Image utility functions
class ImageUtils {
  /// Get image size from URL
  static Future<Size?> getImageSize(String imageUrl) async {
    try {
      final image = NetworkImage(imageUrl);
      final imageStream = image.resolve(ImageConfiguration.empty);
      final completer = Completer<Size>();
      
      imageStream.addListener(ImageStreamListener((info, _) {
        final size = Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        );
        completer.complete(size);
      }));
      
      return await completer.future;
    } catch (e) {
      return null;
    }
  }
  
  /// Calculate aspect ratio
  static double calculateAspectRatio(Size imageSize) {
    return imageSize.width / imageSize.height;
  }
  
  /// Generate placeholder color based on text
  static Color generatePlaceholderColor(String text) {
    final hash = text.hashCode;
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[hash.abs() % colors.length];
  }
  
  /// Extract initials from name
  static String extractInitials(String name, {int maxLength = 2}) {
    final words = name.trim().split(RegExp(r'\s+'));
    final initials = words
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase())
        .take(maxLength)
        .join();
    return initials;
  }
}