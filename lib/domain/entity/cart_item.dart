import 'product.dart';

class CartItem {
  final String? id;
  final String userId;
  final String productId;
  final int quantity;
  final Product? product;

  CartItem({
    this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    this.product,
  });

  CartItem copyWith({
    String? id,
    String? userId,
    String? productId,
    int? quantity,
    Product? product,
  }) {
    return CartItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }

  @override
  String toString() {
    return 'CartItem(id: $id, productId: $productId, quantity: $quantity)';
  }
}
