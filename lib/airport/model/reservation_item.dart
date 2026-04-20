import 'package:second_trip_project/airport/model/passenger_item.dart';
import '../constants/airport_constants.dart';
import '../utils/format_utils.dart';

class ReservationItem {

  // ── 1. 데이터 구조 정의 ──────────────────────────────────
  final int? id;                  // 스프링부트 DB id
  final String? mid;              // 회원 ID
  final String? airlineNm;        // 항공사명
  final String? flightNo;         // 항공편명
  final String? depAirportNm;     // 출발 공항명
  final String? arrAirportNm;     // 도착 공항명
  final String? depAirportId;     // 출발 공항코드
  final String? arrAirportId;     // 도착 공항코드
  final String? depPlandTime;     // 출발 시각
  final String? arrPlandTime;     // 도착 시각
  final int depPrice;             // 가는편 가격

  // ── 왕복일 때 ─────────────────────────────────────────────
  final String? retAirlineNm;     // 오는편 항공사명
  final String? retFlightNo;      // 오는편 항공편명
  final String? retDepPlandTime;  // 오는편 출발 시각
  final String? retArrPlandTime;  // 오는편 도착 시각
  final int? retPrice;            // 오는편 가격

  // ── 탑승객 목록 (passenger 테이블로 분리) ─────────────────
  final List<PassengerItem> passengers;

  // ── 예약 정보 ─────────────────────────────────────────────
  final bool isRoundTrip;         // 편도/왕복
  final String reservedAt;        // 예약 일시
  String status;                  // 예약완료 / 취소

  ReservationItem({
    this.id,
    this.mid,
    this.airlineNm,
    this.flightNo,
    this.depAirportNm,
    this.arrAirportNm,
    this.depAirportId,
    this.arrAirportId,
    this.depPlandTime,
    this.arrPlandTime,
    required this.depPrice,
    this.retAirlineNm,
    this.retFlightNo,
    this.retDepPlandTime,
    this.retArrPlandTime,
    this.retPrice,
    required this.passengers,
    required this.isRoundTrip,
    required this.reservedAt,
    required this.status,
  });

  // ── 2. 총 금액 계산 ──────────────────────────────────────
  // ✅ FormatUtils.totalPassengerPrice 사용 → 소아 75% / 유아 10% 반영
  int get totalPrice {
    if (passengers.isEmpty) {
      // 탑승객 정보 없을 때: 성인 1인 기준
      if (isRoundTrip && retPrice != null) {
        return depPrice + retPrice! + AirportConstants.issueFee;
      }
      return depPrice + AirportConstants.issueFee;
    }
    return FormatUtils.totalPassengerPrice(
      depPrice: depPrice,
      retPrice: isRoundTrip ? retPrice : null,
      passengerTypes: passengers.map((p) => p.passengerType).toList(),
      issueFee: AirportConstants.issueFee,
    );
  }

  // ── 탑승객 이름 요약 (화면 표시용) ───────────────────────
  // 예: '홍 길동 외 1명' 또는 '홍 길동'
  String get passengerSummary {
    if (passengers.isEmpty) return '-';
    final first = passengers.first.passengerName;
    if (passengers.length == 1) return first;
    return '$first 외 ${passengers.length - 1}명';
  }

  // ── 3. 스프링부트 JSON → ReservationItem 변환 ────────────
  factory ReservationItem.fromJson(Map<String, dynamic> json) {
    return ReservationItem(
      id:              json['id'],
      mid:             json['mid'],
      airlineNm:       json['airlineNm'],
      flightNo:        json['flightNo'],
      depAirportNm:    json['depAirportNm'],
      arrAirportNm:    json['arrAirportNm'],
      depAirportId:    json['depAirportId'],
      arrAirportId:    json['arrAirportId'],
      depPlandTime:    json['depPlandTime'],
      arrPlandTime:    json['arrPlandTime'],
      depPrice:        json['depPrice'] ?? 0,
      retAirlineNm:    json['retAirlineNm'],
      retFlightNo:     json['retFlightNo'],
      retDepPlandTime: json['retDepPlandTime'],
      retArrPlandTime: json['retArrPlandTime'],
      retPrice:        json['retPrice'],
      passengers: (json['passengers'] as List<dynamic>? ?? [])
          .map((e) => PassengerItem.fromJson(e))
          .toList(),
      isRoundTrip:     json['isRoundTrip'] ?? false,
      reservedAt:      json['reservedAt'] ?? '',
      status:          '예약완료',
    );
  }

  // ── 4. ReservationItem → 스프링부트 JSON 변환 ────────────
  Map<String, dynamic> toJson() {
    return {
      'mid':             mid,
      'airlineNm':       airlineNm,
      'flightNo':        flightNo,
      'depAirportNm':    depAirportNm,
      'arrAirportNm':    arrAirportNm,
      'depAirportId':    depAirportId,
      'arrAirportId':    arrAirportId,
      'depPlandTime':    depPlandTime,
      'arrPlandTime':    arrPlandTime,
      'depPrice':        depPrice,
      'retAirlineNm':    retAirlineNm,
      'retFlightNo':     retFlightNo,
      'retDepPlandTime': retDepPlandTime,
      'retArrPlandTime': retArrPlandTime,
      'retPrice':        retPrice,
      'passengers':      passengers.map((e) => e.toJson()).toList(),
      'isRoundTrip':     isRoundTrip,
      'reservedAt':      reservedAt,
    };
  }
}