import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/states/widget_state.dart';
import 'package:red_flags/models/person.model.dart';
import 'package:red_flags/models/zone.model.dart';
import 'package:red_flags/providers/cities/get_zones.provider.dart';
import 'package:red_flags/providers/persons/get_persons.provider.dart';

final searchScreenState = StateNotifierProvider<SearchScreenNotifier, SearchScreenState>((ref) {
  return SearchScreenNotifier(ref);
});

class SearchScreenNotifier extends StateNotifier<SearchScreenState> {
  final Ref ref;

  SearchScreenNotifier(this.ref) : super(SearchScreenState(status: WidgetStatus.init, persons: [], zones: []));

  Future<void> searchFromInput(String firstname, String lastname, String zonename, String jobname) async {
    try {
      /// * If no arguments provided, then back to default state.
      if (firstname.isEmpty && lastname.isEmpty && zonename.isEmpty && jobname.isEmpty) {
        state = SearchScreenState(status: WidgetStatus.init, persons: [], zones: []);
        return;
      }

      /// * Loading status now, we're fetching some data.
      state = SearchScreenState(status: WidgetStatus.loading, persons: state.persons, zones: state.zones);

      /// * Fetch data for each.
      final getPersonsParams = GetPersonsProviderParams(firstname: firstname, lastname: lastname, jobname: jobname, zonename: zonename);
      final getPersons = ref.read(getPersonsProvider(getPersonsParams).future);

      final getZonesParams = GetZonesProviderParams(zonename: zonename);
      final getZones = ref.read(getZonesProvider(getZonesParams).future);

      final responses = await Future.wait([getPersons, getZones]);

      /// * And now update the state with new data.
      state = SearchScreenState(status: WidgetStatus.success, persons: responses[0] as List<Person>, zones: responses[1] as List<Zone>);
    } catch (e, stack) {
      state = SearchScreenState(status: WidgetStatus.failure, persons: state.persons, zones: state.zones);
      log("$e $stack");
    }
  }
}

class SearchScreenState extends WidgetState {
  final List<Person> persons;
  final List<Zone> zones;

  SearchScreenState({required super.status, required this.persons, required this.zones});
}
