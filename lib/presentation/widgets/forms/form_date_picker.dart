import 'package:flutter/material.dart';
import 'package:red_flags/core/extensions/datetime_extension.dart';

class FormDatePicker extends StatefulWidget {
  final String label;
  final DateTime? value;
  final IconData icon;
  final void Function(DateTime) onSubmitted;

  const FormDatePicker({required this.label, required this.icon, this.value, required this.onSubmitted, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<FormDatePicker> with TickerProviderStateMixin {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// * The picker.
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDatePickerMode: DatePickerMode.year,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              setState(() => _selectedDate = pickedDate);
              widget.onSubmitted(_selectedDate!);
            }
          },
          child: AbsorbPointer(
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
                    if (_selectedDate == null)
                      Text(widget.label, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    if (_selectedDate != null)
                      Text(_selectedDate!.format(), style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
