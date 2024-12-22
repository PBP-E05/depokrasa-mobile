import 'dart:convert';

List<CategoryEntry> categoryEntryFromJson(String str) => List<CategoryEntry>.from(json.decode(str).map((x) => CategoryEntry.fromJson(x)));

String categoryEntryToJson(List<CategoryEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryEntry {
    String name;

    CategoryEntry({
        required this.name,
    });

    factory CategoryEntry.fromJson(Map<String, dynamic> json) => CategoryEntry(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}