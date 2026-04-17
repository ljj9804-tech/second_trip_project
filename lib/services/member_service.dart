import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MemberService {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:8080';

  Future<Map<String, dynamic>?> login(String mid, String mpw) async {
    try {
      final url = Uri.parse('$baseUrl/api/member/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mid': mid, 'mpw': mpw}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(utf8.decode(response.bodyBytes));

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        // 1. 기본 정보 저장
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userMid', userData['mid'] ?? mid);
        await prefs.setString('userName', userData['mname'] ?? "사용자");
        await prefs.setString('userEmail', userData['email'] ?? "");

        // 2. ⭐ 토큰 저장
        if (userData['accessToken'] != null) {
          await prefs.setString('accessToken', userData['accessToken']);
        }
        if (userData['refreshToken'] != null) {
          await prefs.setString('refreshToken', userData['refreshToken']);
        }

        // 3. ⭐ 눈으로 확인하기 위한 '확인 도장' 코드 추가!
        print("========================================");
        print("✅ 로그인 성공 및 데이터 저장 완료!");
        print("🎫 저장된 토큰: ${prefs.getString('accessToken')}");
        print("👤 저장된 사용자: ${prefs.getString('userName')}");
        print("========================================");

        return userData;
      }
      return null;
    } catch (e) {
      print('로그인 에러: $e');
      return null;
    }
  }

  // --- 이하 회원가입, 로그아웃, 상태체크 함수는 그대로 유지 ---
  Future<bool> register(Map<String, String> userData) async {
    try {
      final url = Uri.parse('$baseUrl/api/member/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('회원가입 에러: $e');
      return false;
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("로그아웃 완료: 로컬 데이터 삭제됨");
  }

  Future<bool> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}