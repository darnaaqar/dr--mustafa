import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DentalLoading extends StatefulWidget {
  final double size;
  final Color color;

  const DentalLoading({
    super.key,
    this.size = 60,
    this.color = const Color(0xFF00D8FF),
  });

  @override
  State<DentalLoading> createState() => _DentalLoadingState();
}

class _DentalLoadingState extends State<DentalLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotating outer ring
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.14159,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.color.withOpacity(0.3),
                      width: 3,
                    ),
                  ),
                ),
              );
            },
          ),
          // Pulsing inner icon
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.8 + (_controller.value * 0.2),
                child: Icon(
                  Icons.health_and_safety_sharp,
                  size: widget.size * 0.5,
                  color: widget.color,
                ),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}