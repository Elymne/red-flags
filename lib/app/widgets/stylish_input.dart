import 'package:flutter/material.dart';

class StylishInput extends StatefulWidget {
  final String label;
  final void Function(String)? onChanged;

  const StylishInput(this.label, {super.key, required this.onChanged});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<StylishInput> with TickerProviderStateMixin {
  /// This value allow me to know when input is selected. (And activate anim).
  final FocusNode _focus = FocusNode();

  /// Shake Animation (for background color).
  late final AnimationController _shakyController1;
  late final Animation<double> _shakyAnimation1;
  final Duration _shakyDurationTic1 = Duration(milliseconds: 100);

  /// Shake Animation (for front input).
  late final AnimationController _shakyController2;
  late final Animation<double> _shakyAnimation2;
  final Duration _shakyDurationTic2 = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();

    // Set the text shaky animation for background text. The anim is started or stoped depending of the input focus.
    _shakyController1 = AnimationController(vsync: this, duration: _shakyDurationTic1);
    _shakyAnimation1 = Tween<double>(begin: -1, end: 1).animate(_shakyController1);
    _shakyAnimation1.addStatusListener((status) {});

    // Set the text shaky animation for frontend text. The anim is started or stoped depending of the input focus.
    _shakyController2 = AnimationController(vsync: this, duration: _shakyDurationTic2);
    _shakyAnimation2 = Tween<double>(begin: -1.4, end: 1.4).animate(_shakyController2);
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
        // AnimatedBuilder(
        //   animation: _shakyAnimation1,
        //   builder: (context, child) {
        //     return Transform.translate(
        //       offset: Offset(_shakyAnimation1.value, 0),
        //       child: TextField(style: Theme.of(context).textTheme.labelLarge, decoration: InputDecoration(labelText: widget.label)),
        //     );
        //   },
        // ),
        AnimatedBuilder(
          animation: _shakyAnimation2,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakyAnimation2.value, 0),
              child: TextField(
                focusNode: _focus,
                onChanged: (value) {},
                style: Theme.of(context).textTheme.labelLarge,
                decoration: InputDecoration(
                  labelText: widget.label,

                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _onFocusUpdate() {
    if (_focus.hasFocus) {
      // TODO : Run animation, and all…
      return;
    }

    // TODO : revert the animation and pause it. Then
  }
}
