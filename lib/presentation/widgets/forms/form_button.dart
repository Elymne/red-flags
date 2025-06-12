import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:red_flags/presentation/widgets/forms/form_visibility.provider.dart';

class FormButton extends ConsumerStatefulWidget {
  final String text;
  final void Function() onPressed;

  const FormButton({super.key, required this.text, required this.onPressed});

  @override
  ConsumerState<FormButton> createState() => _FormButtonState();
}

class _FormButtonState extends ConsumerState<FormButton> {
  @override
  Widget build(BuildContext context) {
    final formFocusState = ref.watch(formFocusProvider);

    return Visibility(
      visible: formFocusState.data,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold, fontSize: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          elevation: 1,
        ),
        child: Text(widget.text),
      ),
    );
  }
}
