class DishModel {
  final String id;
  final String ownerId;
  final String name;
  final String imageUrl;
  final double price;
  final bool isAvailable;
  final DateTime updatedAt;

  DishModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.isAvailable,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'isAvailable': isAvailable,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DishModel.fromMap(Map<String, dynamic> map, String id) {
    return DishModel(
      id: id,
      ownerId: map['ownerId'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      price: map['price'].toDouble(),
      isAvailable: map['isAvailable'] ?? false,
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
