import 'package:callparts/data/models/maker.dart';
import 'package:callparts/service/method_api.dart';

class MakerService {

  Future<List<Maker>> getAll() async {
    try {
      final response = await getRequest(
        url: urlApp,
        endpoint: 'makers/get-maker',
        timeout: const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic> && 
            responseData['status'] == 200 && 
            responseData['data'] != null) {
          final List<dynamic> makersList = responseData['data'];
          return makersList.map((json) => Maker.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching makers: $e');
      return [];
    }
  }

  Future<List<Maker>> getCarClass() async {
    try {
      final response = await getRequest(
        url: urlApp,
        endpoint: 'makers/get-car',
        timeout: const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic> && 
            responseData['status'] == 200 && 
            responseData['data'] != null) {
          final List<dynamic> makersList = responseData['data'];
          return makersList.map((json) => Maker.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching makers with car classes: $e');
      return [];
    }
  }
}