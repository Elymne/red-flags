import 'package:flutter/material.dart';
import 'package:red_flags/app/widgets/page_change_related/shakle_pop_text.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 0,
          children: [
            ShaklePopText(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
              speedAnimation: Duration(milliseconds: 40),
              hasIdleAnim: true,
            ),
            ShaklePopText(
              subtitle,
              style: Theme.of(context).textTheme.headlineMedium,
              speedAnimation: Duration(milliseconds: 20),
              hasIdleAnim: true,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
