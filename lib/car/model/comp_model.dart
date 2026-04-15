class CompModel {
  final int? id;
  final String? name;   // 관광지명
  final String? road;    // 부제목
  final String? address;    // 부제목
  final String? la;       // 대표 이미지
  final String? lo;       // 주소
  final String? phone;

  CompModel({
    this.id,
    this.name,
    this.road,
    this.address,
    this.la,
    this.lo,
    this.phone
  });

  static int _idCounter = 0;

  factory CompModel.fromJson(Map<String, dynamic> json) {
    return CompModel(
      id: ++_idCounter,
      name: json['entrpsNm'],
      road: json['rdnmadr'],
      address: json['lnmadr'],
      la: json['latitude'],
      lo: json['longitude'],
      phone: json['phoneNumber'],
    );
  }
}