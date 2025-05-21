import '../../domain/entity/cart_item.dart';
import 'product_model.dart';

class CartItemModel {
  final String? id;
  final String userId;
  final String productId;
  final int quantity;
  final ProductModel? product;

  CartItemModel({
    this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    this.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'];
    return CartItemModel(
      id: json['id'],
      userId: json['user_id'] ?? '',
      productId: productJson?['id'] ?? '',
      quantity: json['quantity'] ?? 0,
      product: productJson != null ? ProductModel.fromJson(productJson) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
    };
  }

  CartItem toEntity() {
    return CartItem(
      id: id,
      userId: userId,
      productId: productId,
      quantity: quantity,
      product: product?.toEntity(),
    );
  }

  static CartItemModel fromEntity(CartItem entity) {
    return CartItemModel(
      id: entity.id,
      userId: entity.userId,
      productId: entity.productId,
      quantity: entity.quantity,
      product: entity.product != null ? ProductModel.fromEntity(entity.product!) : null,
    );
  }
}
