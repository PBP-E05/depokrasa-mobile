import 'dart:convert';

List<RestaurantEntry> restaurantEntryFromJson(String str) => List<RestaurantEntry>.from(json.decode(str).map((x) => RestaurantEntry.fromJson(x)));

String restaurantEntryToJson(List<RestaurantEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RestaurantEntry {
    String name;
    List<Menu> menu;

    RestaurantEntry({
        required this.name,
        required this.menu,
    });

    factory RestaurantEntry.fromJson(Map<String, dynamic> json) => RestaurantEntry(
        name: json["name"],
        menu: List<Menu>.from(json["menu"].map((x) => Menu.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "menu": List<dynamic>.from(menu.map((x) => x.toJson())),
    };
}

class Menu {
    String foodName;
    int price;

    Menu({
        required this.foodName,
        required this.price,
    });

    factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        foodName: json["food_name"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "food_name": foodName,
        "price": price,
    };
}