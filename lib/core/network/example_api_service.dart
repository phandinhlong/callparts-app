import 'api_client.dart';
import 'api_service.dart';
import 'api_response.dart';
import 'api_config.dart';
import 'api_interceptor.dart';
import '../error/errors.dart';

// Example User model
class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (avatar != null) 'avatar': avatar,
    };
  }

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}

// Example Product model
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> images;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      category: json['category'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'images': images,
    };
  }

  @override
  String toString() => 'Product(id: $id, name: $name, price: \$${price.toStringAsFixed(2)})';
}

// Example User API Service
class UserApiService extends ApiService {
  UserApiService(super.client);

  // Get user profile
  Future<Result<User>> getUserProfile(String userId) async {
    final result = await get<User>(
      '/users/$userId',
      fromJson: User.fromJson,
    );

    return result.fold(
      onSuccess: (response) => handleApiResponse(response),
      onFailure: (error) => Failure(error),
    );
  }

  // Update user profile
  Future<Result<User>> updateUserProfile(String userId, Map<String, dynamic> data) async {
    final result = await put<User>(
      '/users/$userId',
      body: data,
      fromJson: User.fromJson,
    );

    return result.fold(
      onSuccess: (response) => handleApiResponse(response),
      onFailure: (error) => Failure(error),
    );
  }

  // Get users with pagination
  Future<Result<PaginatedResponse<User>>> getUsers({
    int page = 1,
    int limit = 10,
    String? search,
    String? category,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (search != null) 'search': search,
      if (category != null) 'category': category,
    };

    final result = await get<Map<String, dynamic>>(
      '/users',
      queryParams: queryParams,
    );

    return result.fold(
      onSuccess: (response) => handlePaginatedResponse(response, User.fromJson),
      onFailure: (error) => Failure(error),
    );
  }

  // Create new user
  Future<Result<User>> createUser(Map<String, dynamic> userData) async {
    final result = await post<User>(
      '/users',
      body: userData,
      fromJson: User.fromJson,
    );

    return result.fold(
      onSuccess: (response) => handleApiResponse(response),
      onFailure: (error) => Failure(error),
    );
  }

  // Delete user
  Future<Result<bool>> deleteUser(String userId) async {
    final result = await delete<bool>(
      '/users/$userId',
    );

    return result.fold(
      onSuccess: (response) => Success(response.success),
      onFailure: (error) => Failure(error),
    );
  }
}

// Example Product API Service
class ProductApiService extends ApiService {
  ProductApiService(super.client);

  // Get product by ID
  Future<Result<Product>> getProduct(String productId) async {
    final result = await get<Product>(
      '/products/$productId',
      fromJson: Product.fromJson,
    );

    return result.fold(
      onSuccess: (response) => handleApiResponse(response),
      onFailure: (error) => Failure(error),
    );
  }

  // Get products with filters
  Future<Result<PaginatedResponse<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? sortOrder,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (category != null) 'category': category,
      if (search != null) 'search': search,
      if (minPrice != null) 'min_price': minPrice.toString(),
      if (maxPrice != null) 'max_price': maxPrice.toString(),
      if (sortBy != null) 'sort_by': sortBy,
      if (sortOrder != null) 'sort_order': sortOrder,
    };

    final result = await get<Map<String, dynamic>>(
      '/products',
      queryParams: queryParams,
    );

    return result.fold(
      onSuccess: (response) => handlePaginatedResponse(response, Product.fromJson),
      onFailure: (error) => Failure(error),
    );
  }

  // Create new product
  Future<Result<Product>> createProduct(Map<String, dynamic> productData) async {
    final result = await post<Product>(
      '/products',
      body: productData,
      fromJson: Product.fromJson,
    );

    return result.fold(
      onSuccess: (response) => handleApiResponse(response),
      onFailure: (error) => Failure(error),
    );
  }

  // Update product
  Future<Result<Product>> updateProduct(String productId, Map<String, dynamic> data) async {
    final result = await put<Product>(
      '/products/$productId',
      body: data,
      fromJson: Product.fromJson,
    );

    return result.fold(
      onSuccess: (response) => handleApiResponse(response),
      onFailure: (error) => Failure(error),
    );
  }

  // Delete product
  Future<Result<bool>> deleteProduct(String productId) async {
    final result = await delete<bool>(
      '/products/$productId',
    );

    return result.fold(
      onSuccess: (response) => Success(response.success),
      onFailure: (error) => Failure(error),
    );
  }

  // Upload product images
  Future<Result<List<String>>> uploadProductImages(String productId, List<String> imagePaths) async {
    // This would typically use multipart/form-data
    // For simplicity, we'll simulate it here
    final result = await post<List<String>>(
      '/products/$productId/images',
      body: {'images': imagePaths},
    );

    return result.fold(
      onSuccess: (response) => handleApiResponse(response),
      onFailure: (error) => Failure(error),
    );
  }
}

// Example of how to use the API services with Dio
class ApiServiceExample {
  static void demonstrateUsage() async {
    // 1. Create API configuration
    final config = ApiConfig.development();
    
    // 2. Create interceptors
    final interceptors = [
      DefaultApiInterceptor(),
      LoggingInterceptor(),
      CacheInterceptor(cacheExpiry: const Duration(minutes: 10)),
      if (config.enableAuth) AuthInterceptor(
        getToken: () => 'your-auth-token-here',
        onTokenExpired: () => print('Token expired, redirect to login'),
      ),
    ];
    
    // 3. Create API client
    final client = ApiClient(
      baseUrl: config.baseUrl,
      timeout: config.timeout,
      headers: config.headers,
    );
    
    // 4. Add interceptors to client
    for (final interceptor in interceptors) {
      client.addInterceptor(interceptor);
    }
    
    // 5. Create API services
    final userService = UserApiService(client);
    final productService = ProductApiService(client);
    
    // 6. Example API calls
    
    // Get user profile
    final userResult = await userService.getUserProfile('user123');
    userResult.fold(
      onSuccess: (user) => print('User: $user'),
      onFailure: (error) => print('Error: ${error.message}'),
    );
    
    // Get products with pagination
    final productsResult = await productService.getProducts(
      page: 1,
      limit: 10,
      category: 'electronics',
      minPrice: 100.0,
      maxPrice: 1000.0,
      sortBy: 'price',
      sortOrder: 'asc',
    );
    
    productsResult.fold(
      onSuccess: (paginatedProducts) {
        print('Products: ${paginatedProducts.data}');
        print('Page ${paginatedProducts.currentPage} of ${paginatedProducts.totalPages}');
        print('Total items: ${paginatedProducts.totalItems}');
      },
      onFailure: (error) => print('Error: ${error.message}'),
    );
    
    // Create new product
    final newProductData = {
      'name': 'New Smartphone',
      'description': 'Latest smartphone with amazing features',
      'price': 999.99,
      'category': 'electronics',
      'images': ['image1.jpg', 'image2.jpg'],
    };
    
    final createResult = await productService.createProduct(newProductData);
    createResult.fold(
      onSuccess: (product) => print('Product created: $product'),
      onFailure: (error) => print('Error: ${error.message}'),
    );
    
    // 7. Clean up
    client.dispose();
  }
}

// Example of error handling with API services
class ApiErrorHandlingExample {
  static void demonstrateErrorHandling() async {
    final config = ApiConfig.development();
    final client = ApiClient(baseUrl: config.baseUrl);
    final userService = UserApiService(client);
    
    try {
      // This will likely fail with a 404
      final result = await userService.getUserProfile('nonexistent-user');
      
      result.fold(
        onSuccess: (user) => print('User found: $user'),
        onFailure: (error) {
          // Handle different types of errors
          if (error is NetworkException) {
            switch (error.statusCode) {
              case 404:
                print('User not found');
                break;
              case 401:
                print('Unauthorized - please login');
                break;
              case 500:
                print('Server error - please try again later');
                break;
              default:
                print('Network error: ${error.message}');
            }
          } else if (error is BusinessException) {
            print('Business error: ${error.message}');
          } else {
            print('Unknown error: ${error.message}');
          }
          
          // Log error for debugging
          ErrorHandler.handleError(error, context: 'UserApiService.getUserProfile');
        },
      );
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      client.dispose();
    }
  }
}

// Example of advanced Dio usage
class AdvancedDioExample {
  static void demonstrateAdvancedFeatures() async {
    final config = ApiConfig.development();
    final client = ApiClient(baseUrl: config.baseUrl);
    
    // Get Dio instance for advanced usage
    final dio = client.dio;
    
    // Add custom interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🚀 Custom interceptor: ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ Custom interceptor: ${response.statusCode}');
          handler.next(response);
        },
        onError: (error, handler) {
          print('❌ Custom interceptor: ${error.message}');
          handler.next(error);
        },
      ),
    );
    
    // Example of using Dio directly for complex requests
    try {
      // Multipart form data
      final formData = FormData.fromMap({
        'name': 'Test Product',
        'price': '99.99',
        'file': await MultipartFile.fromFile('path/to/file.jpg'),
      });
      
      final response = await dio.post(
        '/products/upload',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      
      print('Upload response: ${response.statusCode}');
      
    } catch (e) {
      print('Upload error: $e');
    }
    
    // Clean up
    client.dispose();
  }
}
