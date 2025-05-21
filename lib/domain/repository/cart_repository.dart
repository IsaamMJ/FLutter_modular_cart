
import '../entity/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCart(String userId);
  Future<void> addToCart(CartItem item);
  Future<void> removeFromCart(String itemId);
  Future<void> updateCartItemQuantity(String itemId, int quantity);

}