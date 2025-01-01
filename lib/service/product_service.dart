
import 'package:dio/dio.dart';
import 'package:untitled/model/product.dart';

class ProductService{
  final Dio _dio;
  ProductService() : _dio = Dio(BaseOptions(baseUrl: "https://dummyjson.com"));
  Future<List<Product>> getProducts() async{
    try{
      final res =  await _dio.get("/products?limit=12");
      final data = res.data as List;
      return data.map((json) => Product.fromJson(json)).toList();
    }on DioException {
      return[];
    }
  }
}