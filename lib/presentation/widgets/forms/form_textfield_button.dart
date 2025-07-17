import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormTextfieldButton extends ConsumerStatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final void Function() onTap;

  const FormTextfieldButton({required this.label, required this.value, required this.icon, required this.onTap, super.key});

  @override
  ConsumerState<FormTextfieldButton> createState() => _FormTextfieldButtonState();
}

class _FormTextfieldButtonState extends ConsumerState<FormTextfieldButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [BoxShadow(color: Colors.grey.withAlpha(40), spreadRadius: 2, blurRadius: 2, offset: Offset(0, 2))],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(widget.icon, color: Theme.of(context).colorScheme.primary),
              SizedBox(width: 14),
              if (widget.value.isEmpty)
                Expanded(
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              if (widget.value.isNotEmpty)
                Expanded(
                  child: Text(
                    widget.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
