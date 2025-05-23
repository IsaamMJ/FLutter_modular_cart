import 'package:get/get.dart';
import '../../controller/cart_controller.dart';
import '../../domain/entity/cart_item.dart';
import 'cart_facade.dart';

class CartFacadeImpl implements CartFacade {
  final CartController controller;

  CartFacadeImpl(this.controller);

  @override
  Future<void> addItem(String productId, int quantity) {
    return controller.addItem(productId, quantity);
  }

  @override
  Future<void> removeItem(String? itemId) {
    return controller.removeItem(itemId);
  }

  @override
  Future<void> clearCart() {
    return controller.clearCart();
  }

  @override
  Future<void> refreshCart() {
    return controller.fetchCart();
  }

  @override
  List<CartItem> get items => controller.cartItems;

  @override
  double get total => controller.cartItems.fold(
    0.0,
        (sum, item) => sum + (item.product?.price ?? 0) * item.quantity,
  );
}
