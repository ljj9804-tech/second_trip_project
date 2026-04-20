import 'package:dio/dio.dart';

import '../../constants.dart';
import '../../util/secure_storage_helper.dart';
import '../model/car_reservation_cursor_request_dto.dart';
import '../model/car_reservation_cursor_response_dto.dart';
import '../model/car_rental_reservation_dto.dart';

class CarReservationService {
  final _storage = SecureStorageHelper();

  Future<String?> _getToken() async {
    return await _storage.getAccessToken();
  }

  Future<({CarRentalReservationDTO? rental, String? error})> createRental(int carId, String startDate, String endDate) async {
    final token = await _getToken();
    if (token == null) return (rental: null, error: '로그인이 필요합니다.');

    try {
      final response = await dio.post(
        '/api/car/reservation',
        data: {'carId': carId, 'startDate': startDate, 'endDate': endDate},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return (rental: CarRentalReservationDTO.fromJson(response.data), error: null);
    } catch (e) {
      if (e is DioException && e.response != null) {
        final data = e.response?.data;
        final String message = data is String ? data : ((data?['message'] as String?) ?? '이 날짜에 이미 예약이 있습니다.');
        return (rental: null, error: message);
      }
      return (rental: null, error: '예약 실패: $e');
    }
  }

  Future<({CarReservationCursorResponseDTO? response, String? error})> fetchMyRentals(
    CarReservationCursorRequestDTO request,
  ) async {
    final token = await _getToken();
    if (token == null) return (response: null, error: '로그인이 필요합니다.');

    try {
      final response = await dio.get(
        '/api/car/reservation/my',
        queryParameters: request.toQueryParameters(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return (response: CarReservationCursorResponseDTO.fromJson(response.data), error: null);
    } catch (e) {
      return (response: null, error: '목록 조회 실패: $e');
    }
  }

  Future<({bool success, String? error})> cancelRental(int rentalId) async {
    final token = await _getToken();
    if (token == null) return (success: false, error: '로그인이 필요합니다.');

    try {
      await dio.delete(
        '/api/car/reservation/$rentalId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return (success: true, error: null);
    } catch (e) {
      return (success: false, error: '취소 실패: $e');
    }
  }
}