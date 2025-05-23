import '../../domain/entity/cart_item.dart';
import '../state/cart_state.dart';

abstract class ICartService {
  List<CartItem> get items;
  bool get isLoading;
  String get errorMessage;

  Stream<CartState> get cartStream;

  Future<void> fetchCart();
  Future<void> addItem(
      String productId,
      int quantity, {
        required String name,
        required double price,
        required String imageUrl,
      });

  Future<void> removeItem(String? itemId);
  Future<void> clearCart();
}
