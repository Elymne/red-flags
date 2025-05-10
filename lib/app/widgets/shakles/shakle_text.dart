import 'package:flutter/material.dart';
import 'package:red_flags/core/themes/light_theme.dart';

class ShakleText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double force;

  const ShakleText(this.text, {super.key, required this.style, this.force = 1});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleText> with TickerProviderStateMixin {
  /// Background idle animation.
  late final AnimationController _shakyController1;
  late final Animation<double> _shakyAnimation1;
  final Duration _shakyDurationTic1 = Duration(milliseconds: 1_600);

  /// Frontend idle animation.
  late final AnimationController _shakyController2;
  late final Animation<double> _shakyAnimation2;
  final Duration _shakyDurationTic2 = Duration(milliseconds: 1_000);

  /// Background color animation.
  late final AnimationController _colorController;
  late final Animation<Color?> _colorAnimation;
  final Duration _colorDurationTic = Duration(milliseconds: 10_000);

  @override
  void initState() {
    super.initState();

    /// * Set the text shaky animation for background text.
    _shakyController1 = AnimationController(vsync: this, duration: _shakyDurationTic1);
    _shakyAnimation1 = Tween<double>(begin: -3, end: 3).animate(_shakyController1);
    _shakyController1.repeat(reverse: true);

    /// * Set the text shaky animation for frontend text.
    _shakyController2 = AnimationController(vsync: this, duration: _shakyDurationTic2);
    _shakyAnimation2 = Tween<double>(begin: -1, end: 1).animate(_shakyController2);
    _shakyController2.repeat(reverse: true);

    /// * Set the background color.
    _colorController = AnimationController(vsync: this, duration: _colorDurationTic);
    _colorAnimation = ColorTween(begin: lightColorScheme.primary, end: lightColorScheme.secondary).animate(_colorController);
    // _colorController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _shakyController1.dispose();
    _shakyController2.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _shakyAnimation1,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakyAnimation1.value * widget.force, 0),
              child: Text(widget.text, style: widget.style?.copyWith(color: _colorAnimation.value)),
            );
          },
        ),
        AnimatedBuilder(
          animation: _shakyAnimation2,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakyAnimation2.value * widget.force, 0),
              child: Text(widget.text, style: widget.style),
            );
          },
        ),
      ],
    );
  }
}
