import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:red_flags/presentation/widgets/forms/form_focus.provider.dart';

class UnknownButton extends ConsumerStatefulWidget {
  final String text;
  final void Function() onPressed;

  final bool? isActive;
  final Color? color;

  const UnknownButton({super.key, required this.text, required this.onPressed, this.color, this.isActive});

  @override
  ConsumerState<UnknownButton> createState() => _FormButtonState();
}

class _FormButtonState extends ConsumerState<UnknownButton> {
  @override
  Widget build(BuildContext context) {
    final formFocusState = ref.watch(formFocusProvider);

    return Visibility(
      visible: formFocusState.data == false,
      child: ElevatedButton(
        onPressed: () {
          if (widget.isActive ?? false) widget.onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: widget.color ?? Theme.of(context).colorScheme.primary,
          splashFactory: InkRipple.splashFactory,
          animationDuration: Duration(milliseconds: 100),
          textStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold, fontSize: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: widget.color ?? Theme.of(context).colorScheme.primary, width: 1.1),
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          elevation: 0,
        ),
        child: Text(
          widget.text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: widget.color ?? Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
