// To parse this JSON data, do
//
//     final promotions = promotionsFromJson(jsonString);

import 'dart:convert';

List<Promotions> promotionsFromJson(String str) => List<Promotions>.from(json.decode(str).map((x) => Promotions.fromJson(x)));

String promotionsToJson(List<Promotions> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Promotions {
    int id;
    String restaurantName;
    String promotionType;
    String description;
    DateTime startDate;
    DateTime endDate;

    Promotions({
        required this.id,
        required this.restaurantName,
        required this.promotionType,
        required this.description,
        required this.startDate,
        required this.endDate,
    });

    factory Promotions.fromJson(Map<String, dynamic> json) => Promotions(
        id: json["id"],
        restaurantName: json["restaurant_name"],
        promotionType: json["promotion_type"],
        description: json["description"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "restaurant_name": restaurantName,
        "promotion_type": promotionType,
        "description": description,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
    };
}
