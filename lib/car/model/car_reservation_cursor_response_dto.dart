import 'car_rental_reservation_dto.dart';

class CarReservationCursorResponseDTO {
  final List<CarRentalReservationDTO> rentals;
  final bool hasNext;
  final int? nextCursorStatusOrder;
  final String? nextCursorEndDate;
  final int? nextCursorId;

  CarReservationCursorResponseDTO({
    required this.rentals,
    required this.hasNext,
    this.nextCursorStatusOrder,
    this.nextCursorEndDate,
    this.nextCursorId,
  });

  factory CarReservationCursorResponseDTO.fromJson(Map<String, dynamic> json) {
    return CarReservationCursorResponseDTO(
      rentals: (json['content'] as List)
          .map((e) => CarRentalReservationDTO.fromJson(e))
          .toList(),
      hasNext: json['hasNext'],
      nextCursorStatusOrder: json['nextCursorStatusOrder'] as int?,
      nextCursorEndDate: json['nextCursorEndDate'] as String?,
      nextCursorId: json['nextCursorId'] as int?,
    );
  }
}