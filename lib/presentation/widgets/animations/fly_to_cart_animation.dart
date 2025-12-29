import 'package:flutter/material.dart';
import 'dart:math' as math;

class FlyToCartAnimation extends StatefulWidget {
  final String imageUrl;
  final Offset startPosition;
  final Offset endPosition;
  final VoidCallback onComplete;
  final bool isNetworkImage;

  const FlyToCartAnimation({
    Key? key,
    required this.imageUrl,
    required this.startPosition,
    required this.endPosition,
    required this.onComplete,
    this.isNetworkImage = true,
  }) : super(key: key);

  @override
  State<FlyToCartAnimation> createState() => _FlyToCartAnimationState();
}

class _FlyToCartAnimationState extends State<FlyToCartAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _curveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(_curveAnimation);

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset _calculatePosition(double t) {
    // Bezier curve calculation for smooth arc
    final dx = widget.startPosition.dx +
        (widget.endPosition.dx - widget.startPosition.dx) * t;
    
    // Create an arc effect
    final midY = math.min(widget.startPosition.dy, widget.endPosition.dy) - 100;
    final dy = _quadraticBezier(
      widget.startPosition.dy,
      midY,
      widget.endPosition.dy,
      t,
    );

    return Offset(dx, dy);
  }

  double _quadraticBezier(double p0, double p1, double p2, double t) {
    final oneMinusT = 1.0 - t;
    return oneMinusT * oneMinusT * p0 + 2 * oneMinusT * t * p1 + t * t * p2;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final position = _calculatePosition(_curveAnimation.value);
        
        return Positioned(
          left: position.dx - 40, // Center the image (80/2)
          top: position.dy - 40,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: widget.isNetworkImage
                      ? Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, color: Colors.grey),
                            );
                          },
                        )
                      : Image.asset(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, color: Colors.grey),
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Helper class to trigger the animation
class FlyToCartHelper {
  static OverlayEntry? _currentOverlay;

  static void startAnimation({
    required BuildContext context,
    required String imageUrl,
    required GlobalKey sourceKey,
    required GlobalKey targetKey,
    required VoidCallback onComplete,
    bool isNetworkImage = true,
  }) {
    // Remove any existing animation
    _currentOverlay?.remove();
    _currentOverlay = null;

    // Get positions
    final RenderBox? sourceBox =
        sourceKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? targetBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;

    if (sourceBox == null || targetBox == null) {
      onComplete();
      return;
    }

    final sourcePosition = sourceBox.localToGlobal(Offset.zero);
    final targetPosition = targetBox.localToGlobal(Offset.zero);

    // Create overlay
    _currentOverlay = OverlayEntry(
      builder: (context) => FlyToCartAnimation(
        imageUrl: imageUrl,
        startPosition: sourcePosition,
        endPosition: targetPosition,
        isNetworkImage: isNetworkImage,
        onComplete: () {
          _currentOverlay?.remove();
          _currentOverlay = null;
          onComplete();
        },
      ),
    );

    Overlay.of(context).insert(_currentOverlay!);
  }
}
