// lib/widgets/pinch_zoom_overlay.dart

import 'package:flutter/material.dart';

/// Wraps any widget with pinch-to-zoom behaviour.
/// When pinching: image scales over the UI.
/// When released: it spring-animates back to original position.
class PinchZoomOverlay extends StatefulWidget {
  final Widget child;

  const PinchZoomOverlay({super.key, required this.child});

  @override
  State<PinchZoomOverlay> createState() => _PinchZoomOverlayState();
}

class _PinchZoomOverlayState extends State<PinchZoomOverlay>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _offset = Offset.zero;
  Offset _previousOffset = Offset.zero;
  bool _isZooming = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScaleStart(ScaleStartDetails details) {
    _controller.stop();
    setState(() {
      _previousScale = _scale;
      _previousOffset = _offset;
      _isZooming = true;
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 5.0);
      // Only allow panning when zoomed in
      if (_scale > 1.0) {
        _offset = _previousOffset + details.focalPointDelta;
      }
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    // Animate back to original scale and position
    _scaleAnimation = Tween<double>(begin: _scale, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _offsetAnimation = Tween<Offset>(
      begin: _offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller
      ..reset()
      ..forward();

    _controller.addListener(() {
      setState(() {
        _scale = _scaleAnimation.value;
        _offset = _offsetAnimation.value;
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isZooming = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: Transform(
        transform: Matrix4.identity()
          ..translate(_offset.dx, _offset.dy)
          ..scale(_scale),
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}
