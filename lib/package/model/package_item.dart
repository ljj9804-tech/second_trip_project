class PackageItem {
  final String id; // 고유번호(PK)
  final String category; // 'Special', 'Best', 'Season' 등으로 분류 예정
  final String title; // 패키지 상품명
  final String description; // 여행 소개
  final String country; // 지역
  final String thumbnail; // 썸네일 이미지(작은 사이즈의 이미지만 사용 예정)
  final int price; // 가격
  final List<String> tags; //태그 묶음(#온천 #가족여행 #특가 등)

  // 상세 정보용 데이터
  final List<String> inclusions; //포함 사항
  final List<String> exclusions; //불포함 사항
  final Map<String, dynamic> flightInfo; //항공 정보
  final List<Map<String, dynamic>> itinerary; // day별 상세 일정

  PackageItem({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.country,
    required this.thumbnail,
    required this.price,
    required this.tags,
    required this.inclusions,
    required this.exclusions,
    required this.flightInfo,
    required this.itinerary,
  });

  factory PackageItem.fromJson(Map<String, dynamic> json) {
    return PackageItem(
      id: json['id'],
      category: json['category'],
      title: json['title'],
      description: json['description'],
      country: json['country'],
      thumbnail: json['thumbnail'],
      price: json['price'],
      tags: List<String>.from(json['tags']),
      inclusions: List<String>.from(json['inclusions']),
      exclusions: List<String>.from(json['exclusions']),
      flightInfo: Map<String, dynamic>.from(json['flightInfo']),
      itinerary: List<Map<String, dynamic>>.from(json['itinerary']),
    );
  }
}