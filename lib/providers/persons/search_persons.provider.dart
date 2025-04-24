import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/models/person.model.dart';
import 'package:red_flags/providers/dio/get_dio.provider.dart';

/// Provider access.
/// Used in HomeScreen widget.
final searchPersonsProvider =
    StateNotifierProvider<SearchPersonsNotifier, SearchPersonsState>((ref) {
      return SearchPersonsNotifier(ref);
    });

/// Usecase provider : search for persons given the firstname, lastname, job name and zone name (city).
/// Data response structure : SearchPersonsState
class SearchPersonsNotifier extends StateNotifier<SearchPersonsState> {
  final Ref ref;

  SearchPersonsNotifier(this.ref)
    : super(SearchPersonsState(state: SearchPersonsState.none, data: []));

  Future search(
    String? firstname,
    String? lastname,
    String? zoneName,
    String? jobname,
  ) async {
    try {
      // Notify that the app is loading data.
      state = SearchPersonsState(state: SearchPersonsState.loading, data: []);
      // Fetching persons…
      final response = await ref
          .read(getDio)
          .get<List<Person>>(
            "${dotenv.env["HOST"]}/persons",
            queryParameters: {
              "firstname": firstname,
              "lastname": lastname,
              "zonename": zoneName,
              "jobname": jobname,
            },
          );
      // Checking response type. If it's not a 200, I consider this like a failure response. Same for data nullable.
      if (response.statusCode != 200 || response.data == null) {
        state = SearchPersonsState(state: SearchPersonsState.failure, data: []);
      }
      // The response is ok, send the result.
      state = SearchPersonsState(
        state: SearchPersonsState.success,
        data: response.data!,
      );
    } catch (err) {
      state = SearchPersonsState(state: SearchPersonsState.failure, data: []);
    }
  }
}

/// State structure : data as List of Persons and information about the state.
class SearchPersonsState {
  List<Person> data;
  int state;

  static int none = 0;
  static int loading = 1;
  static int success = 2;
  static int failure = 3;

  SearchPersonsState({required this.data, required this.state});
}
