import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/exceptions/bad_response_exception.dart';
import 'package:red_flags/core/exceptions/network_exception.dart';
import 'package:red_flags/domain/models/company.model.dart';

final Map<GetCompaniesProviderParams, List<Company>> _cached = {};
Timer? _timer;

final getCompaniesProvider = FutureProvider.autoDispose.family<List<Company>, GetCompaniesProviderParams>((ref, params) async {
  if (_timer != null) {
    _timer = Timer(Duration(milliseconds: 10_000), () {
      _cached.clear();
      _timer = null;
    });
  }
  final cached = _cached[params];
  if (cached != null) {
    return cached;
  }
  final response = await Dio().get<String>("${dotenv.env["HOST"]}/companies", queryParameters: {"name": params.companyName});
  if (response.statusCode != 200) {
    throw NetworkException(code: response.statusCode!, expected: 200);
  }
  if (response.data == null) {
    throw BadResponseException(type: response.data.runtimeType, expected: String);
  }
  final List<dynamic> raw = jsonDecode(response.data!)["data"];
  final companies = raw.cast<Map<String, dynamic>>().map((json) => Company.fromJson(json)).toList();
  _cached[params] = companies;
  return companies;
});

class GetCompaniesProviderParams {
  final String companyName;
  GetCompaniesProviderParams({required this.companyName});
}
