import 'dart:convert';
import 'package:http/http.dart' as http;

class MemberService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/member';

  // ⭐ 로그인: 이제 bool만 주는 게 아니라 유저 정보를 담아서 주자!
  Future<Map<String, dynamic>?> login(String mid, String mpw) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mid': mid, 'mpw': mpw}),
      );

      if (response.statusCode == 200) {
        // 서버에서 준 JSON(mid, mname, email 등)을 Map으로 변환
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return null;
    } catch (e) {
      print('로그인 에러: $e');
      return null;
    }
  }

  // ⭐ 회원가입 함수 추가
  Future<bool> register(Map<String, String> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('회원가입 에러: $e');
      return false;
    }
  }
}