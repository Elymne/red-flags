import 'package:flutter/material.dart';

/// ! Not sure about this one.
class NeonElevatedButton extends StatefulWidget {
  final String label;
  final Color animColor;
  final bool isActive;
  final void Function() onPressed;

  const NeonElevatedButton(this.label, {super.key, required this.onPressed, required this.animColor, required this.isActive});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<NeonElevatedButton> with TickerProviderStateMixin {
  /// Shake Animation (for background color).
  late final AnimationController _shakyController1;
  late final Animation<double> _shakyAnimation1;
  final Duration _shakyDurationTic1 = Duration(milliseconds: 1000);

  /// Current state of input. Allow me to know when I have to activate or not the animation.
  String inputValue = "";
  bool isFocus = false;

  @override
  void initState() {
    super.initState();
    // Set the text shaky animation for background text. The anim is started or stoped depending of the input focus.
    _shakyController1 = AnimationController(vsync: this, duration: _shakyDurationTic1);
    _shakyAnimation1 = Tween<double>(begin: 1, end: 2).animate(_shakyController1);
    if (widget.isActive) {
      _shakyController1.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _shakyController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Button.
        AnimatedBuilder(
          animation: _shakyController1,
          builder: (context, child) {
            return GestureDetector(
              onTap: widget.onPressed,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  border: Border.all(color: widget.animColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: widget.animColor.withAlpha(200),
                      spreadRadius: 1 * _shakyAnimation1.value,
                      blurRadius: 4 * _shakyAnimation1.value,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
                  child: Text(widget.label, style: Theme.of(context).textTheme.labelLarge),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
