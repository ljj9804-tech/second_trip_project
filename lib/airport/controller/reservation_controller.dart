import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';  // ✅ [추가]
import '../../common/constants/api_constants.dart';
import '../model/reservation_item.dart';

// 토큰 사용으로 변경 20250416
// ✅ shared_preferences import 추가
// ✅ _getHeaders() 메서드 추가
// ✅ fetchReservations() 토큰 헤더 추가
// ✅ addReservation() 토큰 헤더 추가
// ✅ cancelReservation() 토큰 헤더 추가
// ✅ URL 앞에 api/ 추가

class ReservationController with ChangeNotifier {

  // ── 상태 변수 ─────────────────────────────────────────────
  final List<ReservationItem> _items = [];
  bool    _isLoading    = false;
  String? _errorMessage;

  List<ReservationItem> get items        => _items;
  bool                  get isLoading    => _isLoading;
  String?               get errorMessage => _errorMessage;

  // ✅ [추가] 토큰 헤더 가져오기
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    // ✅ [추가] 토큰 확인 로그
    debugPrint('[ReservationController] 토큰: $token');

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ── 예약 목록 조회 (스프링부트 GET) ──────────────────────
  Future<void> fetchReservations(String mid) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    debugPrint('[ReservationController] 예약 목록 조회 → mid: $mid');

    try {
      final baseUrl = ApiConstants.baseUrl;
      // final url = '${baseUrl}api/airport/reservations/my?mid=$mid';
      final url = '$baseUrl/api/airport/reservations/my?mid=$mid';

      debugPrint('[ReservationController] 요청 URL: $url');

      // ✅ [변경 전] http.get(Uri.parse(url))
      // ✅ [변경 후] 토큰 헤더 추가
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      debugPrint('[ReservationController] 상태코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data =
        jsonDecode(utf8.decode(response.bodyBytes));
        _items.clear();
        _items.addAll(
          data.map((e) => ReservationItem.fromJson(e)).toList(),
        );
        debugPrint('[ReservationController] 조회 완료 → ${_items.length}건');
      } else {
        _errorMessage = '서버 오류: ${response.statusCode}';
        debugPrint('[ReservationController] 서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = '네트워크 오류: $e';
      debugPrint('[ReservationController] 네트워크 오류: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // ── 예약 추가 (스프링부트 POST) ───────────────────────────
  Future<void> addReservation(ReservationItem item) async {
    debugPrint('[ReservationController] 예약 등록 → 탑승객: ${item.passengerName}');

    try {
      final baseUrl = ApiConstants.baseUrl;
      // final url = '${baseUrl}api/airport/reservations';
      final url = '$baseUrl/api/airport/reservations';

      debugPrint('[ReservationController] 요청 URL: $url');

      // ✅ [변경 전] headers: {'Content-Type': 'application/json'}
      // ✅ [변경 후] 토큰 헤더 추가
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(item.toJson()),
      );

      debugPrint('[ReservationController] 상태코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        if (item.mid != null) {
          await fetchReservations(item.mid!);
        }
        debugPrint('[ReservationController] 예약 등록 완료');
      } else {
        _errorMessage = '서버 오류: ${response.statusCode}';
        debugPrint('[ReservationController] 서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = '네트워크 오류: $e';
      debugPrint('[ReservationController] 네트워크 오류: $e');
    }

    notifyListeners();
  }

  // ── 예약 취소 (스프링부트 DELETE) ────────────────────────
  Future<void> cancelReservation(int index) async {
    final item = _items[index];

    debugPrint('[ReservationController] 예약 취소 → id: ${item.id}');

    try {
      final baseUrl = ApiConstants.baseUrl;
      // final url = '${baseUrl}api/airport/reservations/${item.id}';
      final url = '$baseUrl/api/airport/reservations/${item.id}';

      debugPrint('[ReservationController] 요청 URL: $url');

      // ✅ [변경 전] http.delete(Uri.parse(url))
      // ✅ [변경 후] 토큰 헤더 추가
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );
      debugPrint('[ReservationController] 상태코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        _items.removeAt(index);
        debugPrint('[ReservationController] 취소 완료 → '
            '남은 예약: ${_items.length}건');
      } else {
        _errorMessage = '서버 오류: ${response.statusCode}';
        debugPrint('[ReservationController] 서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = '네트워크 오류: $e';
      debugPrint('[ReservationController] 네트워크 오류: $e');
    }

    notifyListeners();
  }

  // ── 국내 예약만 필터 ──────────────────────────────────────
  List<ReservationItem> get domesticItems =>
      _items.where((e) => !e.isRoundTrip || e.depAirportId != null).toList();
}