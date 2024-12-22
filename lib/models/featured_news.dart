class FeaturedNews {
  final String id;
  final String title;
  final String iconImage;
  final String grandTitle;
  final String content;
  final String author;
  final String grandImage;
  final int cookingTime;
  final int calories;
  final String timeAdded;
  final String createdAt;
  final String updatedAt;

  FeaturedNews({
    required this.id,
    required this.title,
    required this.iconImage,
    required this.grandTitle,
    required this.content,
    required this.author,
    required this.grandImage,
    required this.cookingTime,
    required this.calories,
    required this.timeAdded,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeaturedNews.fromJson(Map<String, dynamic> json) {
    return FeaturedNews(
      id: json['pk'] ?? '',
      title: json['fields']['title'] ?? '',
      iconImage: json['fields']['icon_image'] ?? '',
      grandTitle: json['fields']['grand_title'] ?? '',
      content: json['fields']['content'] ?? '',
      author: json['fields']['author'] ?? '',
      grandImage: json['fields']['grand_image'] ?? '',
      cookingTime: json['fields']['cooking_time'] ?? 0,
      calories: json['fields']['calories'] ?? 0,
      timeAdded: json['fields']['time_added'] ?? '',
      createdAt: json['fields']['created_at'] ?? '',
      updatedAt: json['fields']['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fields': {
        'title': title,
        'icon_image': iconImage,
        'grand_title': grandTitle,
        'content': content,
        'author': author,
        'grand_image': grandImage,
        'cooking_time': cookingTime,
        'calories': calories,
        'time_added': timeAdded,
        'created_at': createdAt,
        'updated_at': updatedAt,
      },
    };
  }

  FeaturedNews copyWith({
    String? id,
    String? title,
    String? iconImage,
    String? grandTitle,
    String? content,
    String? author,
    String? grandImage,
    int? cookingTime,
    int? calories,
    String? timeAdded,
    String? createdAt,
    String? updatedAt,
  }) {
    return FeaturedNews(
      id: id ?? this.id,
      title: title ?? this.title,
      iconImage: iconImage ?? this.iconImage,
      grandTitle: grandTitle ?? this.grandTitle,
      content: content ?? this.content,
      author: author ?? this.author,
      grandImage: grandImage ?? this.grandImage,
      cookingTime: cookingTime ?? this.cookingTime,
      calories: calories ?? this.calories,
      timeAdded: timeAdded ?? this.timeAdded,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}