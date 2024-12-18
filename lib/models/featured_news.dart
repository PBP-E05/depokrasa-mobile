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
  String? grandImageUrl;
  String? iconImageUrl;

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
    this.grandImageUrl,
    this.iconImageUrl,
  });

  factory FeaturedNews.fromJson(Map<String, dynamic> json, String baseUrl) {
    return FeaturedNews(
      id: json['pk'] ?? '',
      title: json['fields']['title'] ?? '',
      iconImage: json['fields']['icon_image'] != null ? '$baseUrl/${json['fields']['icon_image']}' : '',
      grandTitle: json['fields']['grand_title'] ?? '',
      content: json['fields']['content'] ?? '',
      author: json['fields']['author'] ?? '',
      grandImage: json['fields']['grand_image'] != null ? '$baseUrl/${json['fields']['grand_image']}' : 'images/image1.jpg',
      cookingTime: json['fields']['cooking_time'] ?? 0,
      calories: json['fields']['calories'] ?? 0,
      timeAdded: json['fields']['time_added'] ?? '',
      createdAt: json['fields']['created_at'] ?? '',
      updatedAt: json['fields']['updated_at'] ?? '',
      grandImageUrl: json['grand_image_url'] ?? '',
      iconImageUrl: json['icon_image_url'] ?? '',
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
      'grand_image_url': grandImageUrl,
      'icon_image_url': iconImageUrl,
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
    String? grandImageUrl,
    String? iconImageUrl,
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
      grandImageUrl: grandImageUrl ?? this.grandImageUrl,
      iconImageUrl: iconImageUrl ?? this.iconImageUrl,
    );
  }
}