import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/secure_storage_helper.dart';

class MemberService {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';

  final _storage = SecureStorageHelper();

  // ─── 이메일 중복 확인 ─────────────────────────────
  Future<bool> checkEmailDuplicate(String email) async {
    try {
      final url = Uri.parse('$baseUrl/api/member/exists/$email');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) == true;
      }
      return false;
    } catch (e) {
      print('중복 확인 에러: $e');
      return true;
    }
  }

  // ─── 로그인 ───────────────────────────────────────
  Future<Map<String, dynamic>?> login(String mid, String mpw) async {
    try {
      final url = Uri.parse('$baseUrl/api/member/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mid': mid, 'mpw': mpw}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData =
        jsonDecode(utf8.decode(response.bodyBytes));

        // 회원 정보 보안 저장소에 저장
        await _storage.saveUserInfo(
          mid: userData['mid'] ?? mid,
          name: userData['mname'] ?? '사용자',
          email: userData['email'] ?? '',
        );

        // 토큰 저장
        if (userData['accessToken'] != null) {
          await _storage.saveAccessToken(userData['accessToken']);
        }
        if (userData['refreshToken'] != null) {
          await _storage.saveRefreshToken(userData['refreshToken']);
        }

        print("========================================");
        print("✅ 로그인 성공!");
        print("🎫 토큰: ${await _storage.getAccessToken()}");
        print("👤 사용자: ${await _storage.getUserName()}");
        print("========================================");

        return userData;
      }
      return null;
    } catch (e) {
      print('로그인 에러: $e');
      return null;
    }
  }

  // ─── 로그아웃 ─────────────────────────────────────
  // 변경
  Future<void> logout() async {
    // SharedPreferences 삭제
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // SecureStorage도 삭제 ← 이게 빠져있어서 문제!
    await SecureStorageHelper().logout();

    print("로그아웃 완료: 전체 데이터 삭제됨");
  }

  // ─── 로그인 상태 체크 ─────────────────────────────
  Future<bool> checkLoginStatus() async {
    return await _storage.isLoggedIn();
  }

  // ─── 회원가입 ─────────────────────────────────────
  Future<bool> register(Map<String, String> userData) async {
    try {
      final url = Uri.parse('$baseUrl/api/member/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ 회원가입 성공!");
        return true;
      } else {
        print("❌ 서버 에러: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print('회원가입 에러: $e');
      return false;
    }
  }

  // ─── 토큰 가져오기 ────────────────────────────────
  Future<String?> getAccessToken() async {
    return await _storage.getAccessToken();
  }

  // ─── 현재 사용자 정보 가져오기 ───────────────────
  Future<Map<String, String?>> getUserInfo() async {
    return {
      'mid': await _storage.getUserMid(),
      'name': await _storage.getUserName(),
      'email': await _storage.getUserEmail(),
    };
  }
}