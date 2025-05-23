import 'package:flutter/material.dart';
import 'package:red_flags/app/widgets/routing/shakle_pop_text.dart';

class TitleContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? color;

  const TitleContainer({super.key, required this.title, this.subtitle = " ", this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 0,
        children: [
          ShaklePopText(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
            animTic: Duration(milliseconds: 40),
            hasIdleAnim: true,
            color: color,
          ),
          ShaklePopText(
            subtitle,
            style: Theme.of(context).textTheme.headlineMedium,
            animTic: Duration(milliseconds: 20),
            hasIdleAnim: true,
            color: color,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
