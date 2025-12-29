import 'package:callparts/data/models/slider.dart';

import '../method_api.dart';

class SliderService {
  Future<List<Slider>?> getAll() async {
    final response = await getRequest(
      url: urlApp,
      endpoint: 'slider/',
      timeout: const Duration(seconds: 10),
    );
    if (response.statusCode == 200) {
      final data = response.data;
      if (data['status'] == true) {
        final dataContent = data['data'];
        List sliders;
        if (dataContent is List) {
          sliders = dataContent;
        } else if (dataContent is Map && dataContent.containsKey('sliders')) {
          sliders = dataContent['sliders'] as List;
        } else {
          return null;
        }
        final result = sliders.map((e) => Slider.fromJson(e)).toList();
        return result;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<List<String?>> getImg() async {
    final sliderList = await getAll();
    if (sliderList == null) {
      return [];
    }
    final images = sliderList.map((slider) => slider.image).toList();
    return images;
  }
}
