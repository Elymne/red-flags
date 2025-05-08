import 'package:flutter/material.dart';

class SquaresBackground extends StatefulWidget {
  const SquaresBackground({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SquaresBackground> {
  late final color = Theme.of(context).colorScheme.primary;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// *
        Positioned(top: 10, left: 100, child: _SquareElement(color: color, shadowColor: color, size: 40, blurRadius: 4)),
        Positioned(top: 40, left: 200, child: _SquareElement(color: color, shadowColor: color, size: 20, blurRadius: 2)),
        Positioned(top: 100, left: 40, child: _SquareElement(color: color, shadowColor: color, size: 60, blurRadius: 8)),
        Positioned(top: 80, left: 300, child: _SquareElement(color: color, shadowColor: color, size: 20, blurRadius: 2)),
      ],
    );
  }
}

class _SquareElement extends StatelessWidget {
  final double size;
  final Color color;
  final Color shadowColor;
  final double blurRadius;

  const _SquareElement({required this.size, required this.color, required this.shadowColor, required this.blurRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        /// *
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(size / 4)),
        boxShadow: [BoxShadow(color: shadowColor, blurRadius: blurRadius, offset: Offset(0.0, 0.0))],
      ),
    );
  }
}
