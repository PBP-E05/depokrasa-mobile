// To parse this JSON data, do
//
//     final discounts = discountsFromJson(jsonString);

import 'dart:convert';

List<Discounts> discountsFromJson(String str) => List<Discounts>.from(json.decode(str).map((x) => Discounts.fromJson(x)));

String discountsToJson(List<Discounts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Discounts {
    int id;
    String foodName;
    String restaurantName;
    int originalPrice;
    int discountPercentage;
    int discountedPrice;
    DateTime startTime;
    DateTime endTime;

    Discounts({
        required this.id,
        required this.foodName,
        required this.restaurantName,
        required this.originalPrice,
        required this.discountPercentage,
        required this.discountedPrice,
        required this.startTime,
        required this.endTime,
    });

    factory Discounts.fromJson(Map<String, dynamic> json) => Discounts(
        id: json["id"],
        foodName: json["food_name"],
        restaurantName: json["restaurant_name"],
        originalPrice: json["original_price"],
        discountPercentage: json["discount_percentage"],
        discountedPrice: json["discounted_price"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "food_name": foodName,
        "restaurant_name": restaurantName,
        "original_price": originalPrice,
        "discount_percentage": discountPercentage,
        "discounted_price": discountedPrice,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
    };
}
