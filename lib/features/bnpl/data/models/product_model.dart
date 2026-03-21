import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? 'Unnamed Product',
      description: json['description'] as String? ?? 'No description available',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price.toStringAsFixed(2),
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  factory ProductModel.fromEntity(ProductEntity entity) => ProductModel(
    id: entity.id,
    name: entity.name,
    description: entity.description,
    price: entity.price,
    imageUrl: entity.imageUrl,
    category: entity.category,
  );
}
