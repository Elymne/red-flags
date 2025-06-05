import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShakleHomeItem extends StatefulWidget {
  final String title;
  final String iconPath;
  final void Function() onTap;

  const ShakleHomeItem({super.key, required this.title, required this.iconPath, required this.onTap});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleHomeItem> with TickerProviderStateMixin {
  late final AnimationController _onPressAnimCtrl;
  late final Animation<double> _onPressAnim;

  @override
  void initState() {
    super.initState();
    _onPressAnimCtrl = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _onPressAnim = Tween<double>(begin: 1, end: 0.94).animate(CurvedAnimation(parent: _onPressAnimCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _onPressAnimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: () {},
      onLongPressDown: (details) {
        _onPressAnimCtrl.forward();
      },
      onLongPressEnd: (details) {
        _onPressAnimCtrl.reverse();
      },
      onLongPressCancel: () {
        _onPressAnimCtrl.reverse();
      },
      child: AnimatedBuilder(
        animation: _onPressAnimCtrl,
        builder: (context, child) {
          return Transform.scale(
            scale: _onPressAnim.value,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.outline.withAlpha(40),
                    blurRadius: 4 * _onPressAnim.value,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(children: [SvgPicture.asset(widget.iconPath, width: 30, height: 30, color: Theme.of(context).colorScheme.outline)]),
                  SizedBox(width: 10),
                  Text(widget.title, style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
