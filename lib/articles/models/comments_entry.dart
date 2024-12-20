import 'dart:convert';

List<CommentEntry> commentEntryFromJson(String str) => List<CommentEntry>.from(json.decode(str).map((x) => CommentEntry.fromJson(x)));

String commentEntryToJson(List<CommentEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentEntry {
    int id;
    String body;
    DateTime createdOn;
    Author author;
    int articleId;

    CommentEntry({
        required this.id,
        required this.body,
        required this.createdOn,
        required this.author,
        required this.articleId,
    });

    factory CommentEntry.fromJson(Map<String, dynamic> json) => CommentEntry(
        id: json["id"],
        body: json["body"],
        createdOn: DateTime.parse(json["created_on"]),
        author: Author.fromJson(json["author"]),
        articleId: json["article_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "body": body,
        "created_on": createdOn.toIso8601String(),
        "author": author.toJson(),
        "article_id": articleId,
    };
}

class Author {
    String username;
    String profilePicture;

    Author({
        required this.username,
        required this.profilePicture,
    });

    factory Author.fromJson(Map<String, dynamic> json) => Author(
        username: json["username"],
        profilePicture: json["profile_picture"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "profile_picture": profilePicture,
    };
}
