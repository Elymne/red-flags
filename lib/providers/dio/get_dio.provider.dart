import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _dio = Dio();
final getDio = Provider((ref) => _dio);
