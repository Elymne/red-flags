import 'package:flutter/material.dart';
import 'package:red_flags/core/themes/light_theme.dart';

class ShakleOutlinedButton extends StatefulWidget {
  final String label;
  final void Function()? onPressed;

  const ShakleOutlinedButton(this.label, {super.key, this.onPressed});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleOutlinedButton> with TickerProviderStateMixin {
  /// Shake Animation (for background color).
  late final AnimationController _backgroundAnimCtrl;
  late final Animation<double> _backgroundAnim;
  final Duration _backgroundAnimDur = Duration(milliseconds: 1_600);

  /// Shake Animation (for front input).
  late final AnimationController _frontAnimCtrl;
  late final Animation<double> _frontAnim;
  final Duration _frontAnimDur = Duration(milliseconds: 1_000);

  /// Background color animation.
  late final AnimationController _colorAnimCtrl;
  late final Animation<Color?> _colorAnim;
  final Duration _colorAnimDur = Duration(milliseconds: 10_000);

  @override
  void initState() {
    super.initState();

    /// * Set the text shaky animation for background text. The anim is started or stoped depending of the input focus.
    _backgroundAnimCtrl = AnimationController(vsync: this, duration: _backgroundAnimDur);
    _backgroundAnim = Tween<double>(begin: -1.2, end: 1.2).animate(_backgroundAnimCtrl);
    if (widget.onPressed != null) _backgroundAnimCtrl.repeat(reverse: true);

    /// * Set the text shaky animation for frontend text. The anim is started or stoped depending of the input focus.
    _frontAnimCtrl = AnimationController(vsync: this, duration: _frontAnimDur);
    _frontAnim = Tween<double>(begin: -1, end: 1).animate(_frontAnimCtrl);
    if (widget.onPressed != null) _frontAnimCtrl.repeat(reverse: true);

    /// * Set the background color.
    _colorAnimCtrl = AnimationController(vsync: this, duration: _colorAnimDur);
    _colorAnim = ColorTween(begin: lightColorScheme.primary, end: lightColorScheme.secondary).animate(_colorAnimCtrl);
    // if (widget.isActive) _colorController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundAnimCtrl.dispose();
    _frontAnimCtrl.dispose();
    _colorAnimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: widget.onPressed != null,
          child: AnimatedBuilder(
            animation: _backgroundAnimCtrl,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_backgroundAnim.value, _backgroundAnim.value * 0.5),
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _colorAnim.value ?? Colors.transparent),
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  ),
                  child: Text(widget.label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: _colorAnim.value)),
                ),
              );
            },
          ),
        ),

        AnimatedBuilder(
          animation: _frontAnim,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_frontAnim.value, _frontAnim.value * 0.5),
              child: OutlinedButton(
                onPressed: widget.onPressed,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: widget.onPressed != null ? Theme.of(context).colorScheme.outline : Theme.of(context).colorScheme.outlineVariant,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                ),
                child: Text(
                  widget.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: widget.onPressed != null ? Theme.of(context).colorScheme.outline : Theme.of(context).colorScheme.outlineVariant,
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
