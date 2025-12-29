import 'package:callparts/data/models/category.dart';
import 'package:callparts/model/product.dart';
import 'package:callparts/service/method_api.dart';

class CategoryService {
  static Category? _cachedCategories;
  static DateTime? _lastFetchTime;
  static const Duration _cacheExpiration = Duration(hours: 1);

  Future<Category?> getCategories({bool forceRefresh = false}) async {
    if (!forceRefresh &&
        _cachedCategories != null &&
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheExpiration) {
      return _cachedCategories;
    }

    final response = await getRequest(
      url: urlApp,
      endpoint: 'category',
      timeout: const Duration(seconds: 10),
    );
    print(response.data);
    if (response.statusCode == 200) {
      final data = response.data;
      if (data['status'] == true && data['categories'] != null) {
        _cachedCategories = Category.fromJson(data['categories']);
        _lastFetchTime = DateTime.now();
        return _cachedCategories;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<Category?> refreshCategories() async {
    _cachedCategories = null;
    _lastFetchTime = null;
    return await getCategories(forceRefresh: true);
  }

  void clearCache() {
    _cachedCategories = null;
    _lastFetchTime = null;
  }

  Future<List<Category>> getParentCategories() async {
    final rootCategory = await getCategories();
    if (rootCategory == null) return [];
    return rootCategory.children;
  }

  Future<List<Category>> getCategoriesByParentId(int parentId) async {
    final rootCategory = await getCategories();
    if (rootCategory == null) return [];

    Category? findCategory(Category cat, int id) {
      if (cat.id == id) return cat;
      for (var child in cat.children) {
        final found = findCategory(child, id);
        if (found != null) return found;
      }
      return null;
    }

    final parent = findCategory(rootCategory, parentId);
    return parent?.children ?? [];
  }

  Future<Category?> getCategoryById(int categoryId) async {
    final rootCategory = await getCategories();
    if (rootCategory == null) return null;

    Category? findCategory(Category cat, int id) {
      if (cat.id == id) return cat;
      for (var child in cat.children) {
        final found = findCategory(child, id);
        if (found != null) return found;
      }
      return null;
    }

    return findCategory(rootCategory, categoryId);
  }

  Future<List<Category>> getAllCategoriesFlat() async {
    final rootCategory = await getCategories();
    if (rootCategory == null) return [];

    List<Category> flatList = [];

    void addCategoryAndChildren(Category cat) {
      flatList.add(cat);
      for (var child in cat.children) {
        addCategoryAndChildren(child);
      }
    }

    addCategoryAndChildren(rootCategory);
    return flatList;
  }

  Future<List<Product>> getProductsByCategorySlug(String slug) async {
    try {
      final response = await getRequest(
        url: urlApp,
        endpoint: 'category/$slug',
        timeout: const Duration(seconds: 10),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        final product = data['data']['products'];
        if (data['success'] == true) {
          if (product != null) {
            if (product is Map && product['items'] != null) {
              final List<dynamic> productList = product['items'];
              return productList.map((json) => Product.fromJson(json)).toList();
            } else if (data['products'] is List) {
              final List<dynamic> productList = data['products'];
              return productList.map((json) => Product.fromJson(json)).toList();
            }
          }
          return [];
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print('Error loading products by slug: $e');
      return [];
    }
  }
}
