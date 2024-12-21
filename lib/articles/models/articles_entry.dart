import 'dart:convert';

import 'package:intl/intl.dart';

List<ArticleEntry> articleEntryFromJson(String str) => List<ArticleEntry>.from(json.decode(str).map((x) => ArticleEntry.fromJson(x)));

String articleEntryToJson(List<ArticleEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ArticleEntry {
    int id;
    String title;
    String featuredImg;
    String body;
    String createdOn;
    DateTime lastModified;
    List<String> categories;

    ArticleEntry({
        required this.id,
        required this.title,
        required this.featuredImg,
        required this.body,
        required this.createdOn,
        required this.lastModified,
        required this.categories,
    });

    factory ArticleEntry.fromJson(Map<String, dynamic> json) {
      DateFormat formatter = DateFormat('dd MMMM yy HH:mm');

      return ArticleEntry(
          id: json["id"],
          title: json["title"],
          featuredImg: json["featured_img"],
          body: json["body"],
          createdOn: formatter.format(DateTime.parse(json["created_on"])),
          lastModified: DateTime.parse(json["last_modified"]),
          categories: List<String>.from(json["categories"].map((x) => x)),
      );      

    } 
    

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "featured_img": featuredImg,
        "body": body,
        "created_on": DateTime.parse(createdOn).toIso8601String(),
        "last_modified": lastModified.toIso8601String(),
        "categories": List<dynamic>.from(categories.map((x) => x)),
    };
}

