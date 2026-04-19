import '../util/format_util.dart';

class CarRentalReservationDTO {
  final int id;
  final int carId;
  final String carName;
  final String startDate;
  final String endDate;
  final int totalPrice;
  final String status;

  CarRentalReservationDTO({
    required this.id,
    required this.carId,
    required this.carName,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
  });

  factory CarRentalReservationDTO.fromJson(Map<String, dynamic> json) {
    return CarRentalReservationDTO(
      id: json['id'],
      carId: json['carId'],
      carName: json['carName'] ?? '',
      startDate: formatDate(json['startDate'], showWeekDay: false, separator: '-'),
      endDate: formatDate(json['endDate'], showWeekDay: false, separator: '-'),
      totalPrice: json['totalPrice'] ?? 0,
      status: json['status'],
    );
  }
}