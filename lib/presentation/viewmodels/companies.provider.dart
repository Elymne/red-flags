import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/results/failure.dart';
import 'package:red_flags/core/states/reactive_state.dart';
import 'package:red_flags/di/usecases_providers.dart';
import 'package:red_flags/domain/entities/company.entity.dart';
import 'package:red_flags/domain/usecases/search_companies.usecase.dart';

final companiesProvider = StateNotifierProvider<CompaniesStateNotifier, CompaniesState>((ref) {
  return CompaniesStateNotifier(ref.read(searchCompaniesProvider));
});

class CompaniesStateNotifier extends StateNotifier<CompaniesState> {
  final SearchCompanies searchCompanies;

  CompaniesStateNotifier(this.searchCompanies) : super(CompaniesState(status: ReactiveStateStatus.inactive, data: []));

  Future<void> search(String name) async {
    try {
      state = CompaniesState(status: ReactiveStateStatus.loading, data: []);
      final result = await searchCompanies.perform(SearchCompaniesParams(name: name));
      result.fold(
        (failureType) {
          state = CompaniesState(status: ReactiveStateStatus.failure, data: [], failureType: failureType);
        },
        (companies) {
          state = CompaniesState(status: ReactiveStateStatus.success, data: companies);
        },
      );
    } catch (err) {
      state = CompaniesState(status: ReactiveStateStatus.failure, data: [], failureType: FailureType.unknown);
    }
  }

  void reset() => state = CompaniesState(status: ReactiveStateStatus.inactive, data: []);
}

class CompaniesState extends ReactiveState<List<Company>> {
  CompaniesState({required super.status, required super.data, super.failureType});
}
