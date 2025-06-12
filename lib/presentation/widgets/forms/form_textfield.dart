import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/presentation/widgets/forms/form_visibility.provider.dart';

class FormTextfield extends ConsumerStatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final void Function(String value) onSubmitted;

  const FormTextfield({required this.label, required this.value, required this.icon, required this.onSubmitted, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<FormTextfield> {
  final FocusNode focus = FocusNode();
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    focus.addListener(onFocusChange);
  }

  @override
  void dispose() {
    focus.addListener(onFocusChange);
    super.dispose();
  }

  void onFocusChange() {
    final formFocusNotifier = ref.read(formFocusProvider.notifier);
    if (focus.hasFocus) {
      hasFocus = true;
      formFocusNotifier.setVisibility(false);
      return;
    }

    hasFocus = false;
    formFocusNotifier.setVisibility(true);
    return;
  }

  @override
  Widget build(BuildContext context) {
    final formFocusState = ref.watch(formFocusProvider);

    return Visibility(
      visible: formFocusState.data || hasFocus,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: hasFocus ? Theme.of(context).colorScheme.surfaceContainerLow : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            if (hasFocus == false) BoxShadow(color: Colors.grey.withAlpha(40), spreadRadius: 2, blurRadius: 2, offset: Offset(0, 2)),
          ],
        ),
        child: TextField(
          onSubmitted: (value) => widget.onSubmitted(value),
          focusNode: focus,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: Theme.of(context).colorScheme.primary),
            hintText: widget.label,
            contentPadding: EdgeInsets.symmetric(vertical: 14.0),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
