import 'package:flutter/material.dart';
import 'package:red_flags/core/themes/light_theme.dart';

class ShakleTextfield extends StatefulWidget {
  final String label;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String? value;

  const ShakleTextfield(this.label, {super.key, this.onChanged, this.onSubmitted, this.value});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleTextfield> with TickerProviderStateMixin {
  /// This value allow me to know when input is selected. (And activate anim).
  final FocusNode _focus = FocusNode();

  /// Shake Animation (for background color).
  late final AnimationController _backgroundAnimCtrl;
  late final Animation<double> _backgroundAnim;
  final Duration _backgroundAnimTic = Duration(milliseconds: 1_600);

  /// Shake Animation (for front input).
  late final AnimationController _foregroundAnimCtrl;
  late final Animation<double> _foregroundAnim;
  final Duration _foregroundAnimTic = Duration(milliseconds: 1_000);

  /// Background color animation.
  late final AnimationController _colorCtrl;
  late final Animation<Color?> _colorAnim;
  final Duration _colorAnimTic = Duration(milliseconds: 10_000);

  /// Current state of input. Allow me to know when I have to activate or not the animation.
  final TextEditingController _ctrl = TextEditingController();
  bool isFocus = false;

  @override
  void initState() {
    super.initState();
    // * Define text.
    _ctrl.text = widget.value ?? "";

    /// * Set the text shaky animation for background text. The anim is started or stoped depending of the input focus.
    _backgroundAnimCtrl = AnimationController(vsync: this, duration: _backgroundAnimTic);
    _backgroundAnim = Tween<double>(begin: -1.0, end: 1.0).animate(_backgroundAnimCtrl);

    /// * Set the text shaky animation for frontend text. The anim is started or stoped depending of the input focus.
    _foregroundAnimCtrl = AnimationController(vsync: this, duration: _foregroundAnimTic);
    _foregroundAnim = Tween<double>(begin: -0.5, end: 0.5).animate(_foregroundAnimCtrl);

    /// * Set the background color.
    _colorCtrl = AnimationController(vsync: this, duration: _colorAnimTic);
    _colorAnim = ColorTween(begin: lightColorScheme.primary, end: lightColorScheme.secondary).animate(_colorCtrl);

    /// * Listen Input focus mode. Will start or stop the animation depending of the focus state of the input.
    _focus.addListener(_onFocusUpdate);
  }

  @override
  void dispose() {
    /// * Remove the listener.
    _focus.removeListener(_onFocusUpdate);

    /// * Dispose all controllers.
    _backgroundAnimCtrl.dispose();
    _foregroundAnimCtrl.dispose();
    _colorCtrl.dispose();
    _ctrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: isFocus,
          child: AnimatedBuilder(
            animation: _backgroundAnimCtrl,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_backgroundAnim.value, _backgroundAnim.value / 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _ctrl.text.isEmpty ? widget.label : " ",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: _colorAnim.value),
                    ),
                    SizedBox(height: 10),
                    Container(height: 1, width: double.infinity, color: _colorAnim.value),
                  ],
                ),
              );
            },
          ),
        ),
        AnimatedBuilder(
          animation: _foregroundAnim,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_foregroundAnim.value, _foregroundAnim.value / 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _ctrl.text.isEmpty ? widget.label : "",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  SizedBox(height: 10),
                  Container(height: 1, width: double.infinity, color: Theme.of(context).colorScheme.outline),
                ],
              ),
            );
          },
        ),
        TextField(
          controller: _ctrl,
          focusNode: _focus,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          style: Theme.of(context).textTheme.labelLarge,
          decoration: null,
        ),
      ],
    );
  }

  /// This function make the autocomplete appear when used.
  /// Can also be used when autocomplete data has been updated.
  /// The values used will depend of the current autocompleteValues and text set in the TextField.

  /// Called each time the input text is activated, focused.
  void _onFocusUpdate() {
    setState(() => isFocus = _focus.hasFocus);
    if (isFocus) {
      _backgroundAnimCtrl.repeat(reverse: true);
      _foregroundAnimCtrl.repeat(reverse: true);
      return;
    }

    _backgroundAnimCtrl.reverse();
    _foregroundAnimCtrl.reverse();
  }
}
