import '../../constants.dart';

class CarRentHomeService {
  Future<List<String>> fetchRegions() async {
    final response = await dio.get('/car/regions');
    return List<String>.from(response.data);
  }
}