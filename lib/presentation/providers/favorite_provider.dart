import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../model/product.dart';

class FavoriteProvider with ChangeNotifier {
  List<Product> _favorites = [];
  static const String _keyFavorites = 'favorite_products';

  List<Product> get favorites => _favorites;
  int get itemCount => _favorites.length;

  bool isFavorite(int productId) {
    return _favorites.any((product) => product.id == productId);
  }

  Future<void> toggleFavorite(Product product) async {
    final index = _favorites.indexWhere((p) => p.id == product.id);
    
    if (index >= 0) {
      // Remove from favorites
      _favorites.removeAt(index);
    } else {
      // Add to favorites
      _favorites.add(product);
    }
    
    await _saveToPreferences();
    notifyListeners();
  }

  Future<void> removeFavorite(int productId) async {
    _favorites.removeWhere((product) => product.id == productId);
    await _saveToPreferences();
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    _favorites.clear();
    await _saveToPreferences();
    notifyListeners();
  }

  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> favoritesJson = _favorites
          .map((product) => json.encode(product.toJson()))
          .toList();
      await prefs.setStringList(_keyFavorites, favoritesJson);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  Future<void> loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? favoritesJson = prefs.getStringList(_keyFavorites);
      
      if (favoritesJson != null) {
        _favorites = favoritesJson
            .map((item) => Product.fromJson(json.decode(item)))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }
}
