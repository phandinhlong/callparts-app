import 'package:callparts/model/product.dart';
import 'package:callparts/service/method_api.dart';
import 'package:dio/dio.dart';

class ProductService {
  Future<List<Product>> search({
    String? codes,
    int? makerId,
    int? classId,
  }) async {
      Map<String, String> queryParams = {};

      if (codes != null && codes.isNotEmpty) {
        queryParams['codes'] = codes;
      }

      if (makerId != null) {
        queryParams['car_maker'] = makerId.toString();
      }

      if (classId != null) {
        queryParams['car_class'] = classId.toString();
      }

      String endpoint = 'products/search';
      if (queryParams.isNotEmpty) {
        final uri = Uri(queryParameters: queryParams);
        endpoint = 'products/search?${uri.query}';
      }

      final response = await getRequest(
        url: urlAPI,
        endpoint: endpoint,
        timeout: const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final product = data['product'];
          if (product != null && product['items'] != null) {
            final List<dynamic> productList = product['items'];
            return productList.map((json) => Product.fromJson(json)).toList();
          }
        }
      } 
      return [];
  }

  Future<List<Product>> getRelatedProducts({
    required int productId,
    required String slug,
  }) async {
    try {
      final endpoint = 'products/detail/$productId-$slug';

      final response = await getRequest(
        url: urlAPI,
        endpoint: endpoint,
        timeout: const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['related_products'] != null) {
          final List<dynamic> relatedProductsList = data['related_products'];
          return relatedProductsList
              .map((json) => Product.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching related products: $e');
      return [];
    }
  }
}
