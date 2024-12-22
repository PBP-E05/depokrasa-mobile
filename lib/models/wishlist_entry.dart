class WishlistEntry {
  final String id;
  final String userId;
  final String productId;
  final String name;
  final String imageUrl;
  final String price;
  final DateTime createdAt;
  final DateTime updatedAt;

  WishlistEntry({
    required this.id,
    required this.userId,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WishlistEntry.fromJson(Map<String, dynamic> json) {
    return WishlistEntry(
      id: json['id'],
      userId: json['user'],
      productId: json['product'],
      name: json['name'],
      imageUrl: json['image_url'],
      price: json['price'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'product': productId,
      'name': name,
      'image_url': imageUrl,
      'price': price,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
