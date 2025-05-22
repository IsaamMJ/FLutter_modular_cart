import '../../domain/entity/cart_item.dart';

abstract class CartFacade {
  Future<void> addItem(String productId, int quantity);
  Future<void> removeItem(String? itemId);
  Future<void> clearCart();
  Future<void> refreshCart();
  List<CartItem> get items;
  double get total;
}
