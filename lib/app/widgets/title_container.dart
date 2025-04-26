import 'package:flutter/material.dart';
import 'package:red_flags/app/widgets/shakle_text.dart';

class TitleContainer extends StatelessWidget {
  final String title;
  final String subtitle;

  const TitleContainer({super.key, required this.title, this.subtitle = " "});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 0,
          children: [
            ShakleText(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
              animColor: Theme.of(context).primaryColor,
              speedAnimation: Duration(milliseconds: 100),
              hasIdleAnim: true,
            ),
            ShakleText(
              subtitle,
              style: Theme.of(context).textTheme.headlineMedium,
              animColor: Theme.of(context).primaryColor,
              speedAnimation: Duration(milliseconds: 40),
              hasIdleAnim: true,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
