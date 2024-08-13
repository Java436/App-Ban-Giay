import 'package:dio/dio.dart';
import 'package:flutter_doanlt/api_service/dio_config.dart';
import 'package:flutter_doanlt/models/category.dart';

class CategoryService {
  final Dio _dio = DioConfig.instance;

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _dio.get('/categories');
      List<Category> categories = (response.data as List).map((category) => Category.fromJson(category)).toList();
      return categories;
    } catch (e) {
      throw Exception('Failed to load categories');
    }
  }
}
