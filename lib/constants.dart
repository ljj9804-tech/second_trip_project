import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String baseUrl = 'http://10.0.2.2:8080';

final dio = Dio(BaseOptions(baseUrl: baseUrl));

const secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);