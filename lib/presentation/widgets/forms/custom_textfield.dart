import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/presentation/widgets/forms/form_visibility.provider.dart';

class CustomTextfield extends ConsumerStatefulWidget {
  const CustomTextfield({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    final formFocusNotifier = ref.read(formFocusProvider.notifier);
    final formFocusState = ref.watch(formFocusProvider);

    return Visibility(
      visible: formFocusState.data,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [BoxShadow(color: Colors.grey.withAlpha(100), spreadRadius: 2, blurRadius: 5, offset: Offset(0, 3))],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Enter your name',
            prefixIcon: Icon(Icons.person),
            border: InputBorder.none, // No border because it's handled by the container
          ),
        ),
      ),
    );
  }
}
