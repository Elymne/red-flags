import 'package:flutter/material.dart';
import 'package:red_flags/presentation/widgets/routing/title_pop_text.dart';

class TitleContainer extends StatelessWidget {
  final String title;
  final Color? color;
  final Function()? onPressed;

  const TitleContainer({super.key, required this.title, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Visibility(
              visible: onPressed != null,
              child: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onPressed, tooltip: 'Back'),
            ),
            TitlePopText(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
              animTic: Duration(milliseconds: 40),
              hasIdleAnim: true,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
