import 'package:flutter/material.dart';
import 'package:red_flags/core/extensions/datetime_extension.dart';

/// TODO : Nothing shaky rn.
class ShakleDatepicker extends StatefulWidget {
  final String label;
  final void Function(String) onChanged;

  const ShakleDatepicker(this.label, {super.key, required this.onChanged});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ShakleDatepicker> with TickerProviderStateMixin {
  DateTime? _selectedDate;

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
            }
          },
          child: AbsorbPointer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedDate == null ? widget.label : _selectedDate!.format(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: _selectedDate == null ? Theme.of(context).colorScheme.onSurfaceVariant : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 10),
                Container(height: 1, width: double.infinity, color: Theme.of(context).colorScheme.outline),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
