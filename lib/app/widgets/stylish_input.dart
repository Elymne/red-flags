import 'package:flutter/material.dart';

class StylishInput extends StatefulWidget {
  final String label;
  final Color animColor;
  final void Function(String) onChanged;

  const StylishInput(this.label, {super.key, required this.onChanged, required this.animColor});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<StylishInput> with TickerProviderStateMixin {
  /// This value allow me to know when input is selected. (And activate anim).
  final FocusNode _focus = FocusNode();

  /// Shake Animation (for background color).
  late final AnimationController _shakyController1;
  late final Animation<double> _shakyAnimation1;
  final Duration _shakyDurationTic1 = Duration(milliseconds: 400);

  /// Shake Animation (for front input).
  late final AnimationController _shakyController2;
  late final Animation<double> _shakyAnimation2;
  final Duration _shakyDurationTic2 = Duration(milliseconds: 800);

  /// Current state of input. Allow me to know when I have to activate or not the animation.
  String inputValue = "";
  bool isFocus = false;

  @override
  void initState() {
    super.initState();
    // Set the text shaky animation for background text. The anim is started or stoped depending of the input focus.
    _shakyController1 = AnimationController(vsync: this, duration: _shakyDurationTic1);
    _shakyAnimation1 = Tween<double>(begin: -1.0, end: 1.0).animate(_shakyController1);
    _shakyAnimation1.addStatusListener((status) {});
    // Set the text shaky animation for frontend text. The anim is started or stoped depending of the input focus.
    _shakyController2 = AnimationController(vsync: this, duration: _shakyDurationTic2);
    _shakyAnimation2 = Tween<double>(begin: -0.5, end: 0.5).animate(_shakyController2);
    _shakyAnimation2.addStatusListener((status) {});
    // Listen Input focus mode. Will start or stop the animation depending of the focus state of the input.
    _focus.addListener(_onFocusUpdate);
  }

  @override
  void dispose() {
    // Remove the listener.
    _focus.removeListener(_onFocusUpdate);

    _shakyController1.dispose();
    _shakyController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isFocus)
          AnimatedBuilder(
            animation: _shakyController1,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakyAnimation1.value, _shakyAnimation1.value / 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inputValue.isEmpty ? widget.label : "",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: widget.animColor),
                    ),
                    SizedBox(height: 10),
                    Container(height: 1, width: double.infinity, color: widget.animColor),
                  ],
                ),
              );
            },
          ),
        AnimatedBuilder(
          animation: _shakyAnimation2,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakyAnimation2.value, _shakyAnimation2.value / 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inputValue.isEmpty ? widget.label : "",
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
          focusNode: _focus,
          onChanged: (value) {
            setState(() => inputValue = value);
            widget.onChanged(value);
          },
          style: Theme.of(context).textTheme.labelLarge,
          decoration: null,
        ),
      ],
    );
  }

  void _onFocusUpdate() {
    setState(() => isFocus = _focus.hasFocus);
    if (isFocus) {
      // Run loop animation.
      _shakyController1.repeat(reverse: true);
      _shakyController2.repeat(reverse: true);
      return;
    }
    // Revert and stop animation.
    _shakyController1.reverse();
    _shakyController2.reverse();
  }
}
