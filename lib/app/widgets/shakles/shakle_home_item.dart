import 'package:flutter/material.dart';

class ShakleHomeItem extends StatefulWidget {
  final String label;
  final Color animColor;
  final void Function() onTap;

  final bool isActive;

  const ShakleHomeItem(this.label, {super.key, required this.animColor, required this.onTap, this.isActive = true});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleHomeItem> with TickerProviderStateMixin {
  /// * Shake Animation (for background color).
  late final AnimationController _shakyController1;
  late final Animation<double> _shakyAnimation1;
  final Duration _shakyDurationTic1 = Duration(milliseconds: 400);

  /// * Shake Animation (for front input).
  late final AnimationController _shakyController2;
  late final Animation<double> _shakyAnimation2;
  final Duration _shakyDurationTic2 = Duration(milliseconds: 800);

  /// * Current state of input. Allow me to know when I have to activate or not the animation.
  final TextEditingController _textFieldController = TextEditingController();
  bool isFocus = false;

  @override
  void initState() {
    super.initState();

    /// * Set the text shaky animation for background text. The anim is started or stoped depending of the input focus.
    _shakyController1 = AnimationController(vsync: this, duration: _shakyDurationTic1);
    _shakyAnimation1 = Tween<double>(begin: -1.0, end: 1.0).animate(_shakyController1);

    /// * Set the text shaky animation for frontend text. The anim is started or stoped depending of the input focus.
    _shakyController2 = AnimationController(vsync: this, duration: _shakyDurationTic2);
    _shakyAnimation2 = Tween<double>(begin: -0.5, end: 0.5).animate(_shakyController2);

    /// * Run animations.
    _shakyController1.repeat(reverse: true);
    _shakyController2.repeat(reverse: true);
  }

  @override
  void dispose() {
    /// * Dispose all controllers.
    _shakyController1.dispose();
    _shakyController2.dispose();
    _textFieldController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _shakyController1,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakyAnimation1.value, _shakyAnimation1.value / 2),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: widget.animColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      /// TODO Icon.
                      Icon(Icons.add, color: widget.animColor, size: 40),

                      /// * Little spacing.
                      SizedBox(width: 20),

                      /// * SImple text.
                      Text(widget.label, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: widget.animColor)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
