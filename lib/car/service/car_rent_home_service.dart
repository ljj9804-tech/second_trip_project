import '../../constants.dart';

class CarRentHomeService {
  Future<List<String>> fetchRegions() async {
    final response = await dio.get('/rent/regions');
    return List<String>.from(response.data);
  }
}