import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/states/widget_state.dart';
import 'package:red_flags/models/company.model.dart';
import 'package:red_flags/actions/companies/get_companies.provider.dart';

final companiesStateProvider = StateNotifierProvider<CompaniesStateNotifier, CompaniesState>((ref) => CompaniesStateNotifier(ref));

class CompaniesStateNotifier extends StateNotifier<CompaniesState> {
  final Ref ref;

  CompaniesStateNotifier(this.ref) : super(CompaniesState(status: WidgetStatus.init, companies: []));

  Future<void> search(String name) async {
    state = CompaniesState(status: WidgetStatus.loading, companies: state.companies);
    try {
      final companies = await ref.read(getCompaniesProvider(GetCompaniesProviderParams(companyName: name)).future);
      state = CompaniesState(status: WidgetStatus.success, companies: companies);
    } catch (err) {
      state = CompaniesState(status: WidgetStatus.failure, companies: state.companies);
    }
  }

  void reset() => state = CompaniesState(status: WidgetStatus.init, companies: []);
}

class CompaniesState extends WidgetState {
  final List<Company> companies;

  CompaniesState({required super.status, required this.companies});
}
