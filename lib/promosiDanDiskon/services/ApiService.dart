import 'dart:convert';
// import 'package:depokrasa_mobile/promosiDanDiskon/screen/promotion_page.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/discounts.dart';
import '../models/promotions.dart';
// import '../models/Restoran.dart';

class ApiService {
  // Sementara gini dulu
  final String baseUrl = kDebugMode ? "http://127.0.0.1:8000" : "https://sx6s6j6f-8000.asse.devtunnels.ms/"; 

  Future<List<Discounts>> fetchDiscounts() async {
    final response = await http.get(Uri.parse('$baseUrl/promotions/api/discounts/'));
    if (response.statusCode == 200) {
      return discountsFromJson(response.body);
    } else {
      throw Exception('Gagal load discounts');
    }
  }

  Future<List<Promotions>> fetchPromotions() async {
    final response = await http.get(Uri.parse('$baseUrl/promotions/api/promotions/'));
    if (response.statusCode == 200) {
      return promotionsFromJson(response.body);
    } else {
      throw Exception('Gagal load promotions');
    }
  }

  Future<List<String>> fetchRestaurantNames() async {
    final response = await http.get(Uri.parse('$baseUrl/restaurants/'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<String>.from(data); // Pastikan parsing sebagai List<String>
    } else {
      throw Exception('Failed to fetch restaurant names');
    }
  }
}
