import 'dart:convert';
// import 'package:depokrasa_mobile/promosiDanDiskon/screen/promotion_page.dart';
import 'package:http/http.dart' as http;
import '../models/discounts.dart';
import '../models/promotions.dart';
// import '../models/Restoran.dart';

class ApiService {
  // Sementara gini dulu
  final String baseUrl = 'http://muhammad-wendy-depokrasa.pbp.cs.ui.ac.id/promotions';

  Future<List<Discounts>> fetchDiscounts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/discounts/'));
    if (response.statusCode == 200) {
      return discountsFromJson(response.body);
    } else {
      throw Exception('Gagal load discounts');
    }
  }

  Future<List<Promotions>> fetchPromotions() async {
    final response = await http.get(Uri.parse('$baseUrl/api/promotions/'));
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
