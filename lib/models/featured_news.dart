class FeaturedNews {
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

  factory FeaturedNews.fromJson(Map<String, dynamic> json, String baseUrl) {
    return FeaturedNews(
      title: json['fields']['title'],
      iconImage: '$baseUrl/${json['fields']['icon_image']}',
      grandTitle: json['fields']['grand_title'],
      content: json['fields']['content'],
      author: json['fields']['author'],
      grandImage: json['fields']['grand_image'].isNotEmpty
          ? '$baseUrl/${json['fields']['grand_image']}'
          : 'images/image1.jpg',
      cookingTime: json['fields']['cooking_time'],
      calories: json['fields']['calories'],
      timeAdded: json['fields']['time_added'],
      createdAt: json['fields']['created_at'],
      updatedAt: json['fields']['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
}