import 'dart:async';

import 'package:flutter/material.dart';

class EllipsisTextAnimated extends StatefulWidget {
  final String baseText;
  final TextStyle? style;

  const EllipsisTextAnimated(this.baseText, {super.key, required this.style});

  @override
  State<StatefulWidget> createState() => _EllipsisTextAnimatedState();
}

class _EllipsisTextAnimatedState extends State<EllipsisTextAnimated> {
  int ellipsisCharNb = 3;
  late String fullText = '${widget.baseText}...';

  @override
  void initState() {
    super.initState();
    runAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Text(fullText, style: widget.style);
  }

  void runAnimation() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        if (ellipsisCharNb <= 0) {
          ellipsisCharNb = 3;
          fullText = '${widget.baseText}...';
          return;
        }
        ellipsisCharNb -= 1;
        fullText = fullText.substring(0, fullText.length - 1);
        return;
      });
    });
  }
}
