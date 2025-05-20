import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:red_flags/core/exceptions/bad_response_exception.dart';
import 'package:red_flags/core/exceptions/network_exception.dart';
import 'package:red_flags/models/company.model.dart';
import 'package:red_flags/providers/response.model.dart';

final Map<GetCompaniesProviderParams, List<Company>> _cached = {};
Timer? _timer;

final getCompaniesProvider = FutureProvider.autoDispose.family<List<Company>, GetCompaniesProviderParams>((ref, params) async {
  /// * Check if we should clear the cache or not.
  if (_timer != null) {
    _timer = Timer(Duration(milliseconds: 10_000), () {
      _cached.clear();
      _timer = null;
    });
  }

  /// * Check if cached data exists. Return if it's teh case.
  final cached = _cached[params];
  if (cached != null) {
    return cached;
  }

  /// * Make http request.
  final response = await Dio().get<String>("${dotenv.env["HOST"]}/companies", queryParameters: {"name": params.companyName});

  /// * Check response code.
  if (response.statusCode != 200) {
    throw NetworkException(code: response.statusCode!, expected: 200);
  }

  /// * Check data type.
  if (response.data == null) {
    throw BadResponseException(type: response.data.runtimeType, expected: String);
  }

  /// * get resp
  final ResponseData<List> raw = jsonDecode(response.data!);

  /// * Parse json data.
  final companies = raw.data.cast<Map<String, dynamic>>().map((json) => Company.fromJson(json)).toList();

  /// * Cache result.
  _cached[params] = companies;

  /// * Return companies fetched.
  return companies;
});

class GetCompaniesProviderParams {
  final String companyName;
  GetCompaniesProviderParams({required this.companyName});
}
