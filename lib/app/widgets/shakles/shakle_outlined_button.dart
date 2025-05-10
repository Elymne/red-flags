import 'package:flutter/material.dart';
import 'package:red_flags/core/themes/light_theme.dart';

class ShakleOutlinedButton extends StatefulWidget {
  final String label;
  final bool isActive;
  final void Function() onPressed;

  const ShakleOutlinedButton(this.label, {super.key, required this.onPressed, required this.isActive});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleOutlinedButton> with TickerProviderStateMixin {
  /// Shake Animation (for background color).
  late final AnimationController _shakyController1;
  late final Animation<double> _shakyAnimation1;
  final Duration _shakyDurationTic1 = Duration(milliseconds: 1_600);

  /// Shake Animation (for front input).
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

    /// * Set the text shaky animation for background text. The anim is started or stoped depending of the input focus.
    _shakyController1 = AnimationController(vsync: this, duration: _shakyDurationTic1);
    _shakyAnimation1 = Tween<double>(begin: -1.2, end: 1.2).animate(_shakyController1);
    if (widget.isActive) _shakyController1.repeat(reverse: true);

    /// * Set the text shaky animation for frontend text. The anim is started or stoped depending of the input focus.
    _shakyController2 = AnimationController(vsync: this, duration: _shakyDurationTic2);
    _shakyAnimation2 = Tween<double>(begin: -1, end: 1).animate(_shakyController2);
    if (widget.isActive) _shakyController2.repeat(reverse: true);

    /// * Set the background color.
    _colorController = AnimationController(vsync: this, duration: _colorDurationTic);
    _colorAnimation = ColorTween(begin: lightColorScheme.primary, end: lightColorScheme.secondary).animate(_colorController);
    // if (widget.isActive) _colorController.repeat(reverse: true);
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
        if (widget.isActive)
          AnimatedBuilder(
            animation: _shakyController1,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakyAnimation1.value, _shakyAnimation1.value * 0.5),
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _colorAnimation.value ?? Colors.transparent),
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  ),

                  child: Text(widget.label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: _colorAnimation.value)),
                ),
              );
            },
          ),
        AnimatedBuilder(
          animation: _shakyAnimation2,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakyAnimation2.value, _shakyAnimation2.value * 0.5),
              child: OutlinedButton(
                onPressed: widget.isActive ? widget.onPressed : null,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: widget.isActive ? Theme.of(context).colorScheme.outline : Theme.of(context).colorScheme.outlineVariant,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                ),
                child: Text(
                  widget.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: widget.isActive ? Theme.of(context).colorScheme.outline : Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
