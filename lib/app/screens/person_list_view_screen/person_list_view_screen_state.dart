import 'package:red_flags/core/states/widget_state.dart';
import 'package:red_flags/models/person.model.dart';

class PersonListViewScreenState extends WidgetState {
  final List<Person> persons;

  PersonListViewScreenState({required super.status, required this.persons});
}
