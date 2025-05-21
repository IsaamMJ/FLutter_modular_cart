import 'package:get/get.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';
import '../../domain/entity/cart_item.dart';

class CartController extends GetxController {
  final GetCartUseCase getCart;
  final AddToCartUseCase addToCart;
  final RemoveFromCartUseCase removeFromCart;
  final UpdateCartQuantityUseCase updateCartQuantity;
  final String userId;

  CartController(
      this.getCart,
      this.addToCart,
      this.removeFromCart,
      this.updateCartQuantity,
      this.userId,
      );

  final cartItems = <CartItem>[].obs;
  final loading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> fetchCart() async {
    loading.value = true;
    errorMessage.value = '';
    try {
      final items = await getCart(userId);
      cartItems.value = items;
    } catch (e) {
      errorMessage.value = 'Failed to fetch cart: $e';
      print(errorMessage.value);
    } finally {
      loading.value = false;
    }
  }

  Future<void> addItem(String productId, int quantity) async {
    try {
      final item = CartItem(
        userId: userId,
        productId: productId,
        quantity: quantity,
      );

      await addToCart(item);

      // update only the changed item locally
      final index = cartItems.indexWhere((i) => i.productId == productId);
      if (index != -1) {
        cartItems[index] = cartItems[index].copyWith(quantity: quantity);
      } else {
        cartItems.add(item);
      }
    } catch (e) {
      print('Failed to add item: $e');
    }
  }

  Future<void> removeItem(String? itemId) async {
    if (!_isValidUuid(itemId)) return;

    try {
      await removeFromCart(itemId!);
      cartItems.removeWhere((item) => item.id == itemId);
    } catch (e) {
      print('Failed to remove item: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      for (final item in List<CartItem>.from(cartItems)) {
        if (_isValidUuid(item.id)) {
          await removeFromCart(item.id!);
        }
      }
      cartItems.clear();
    } catch (e) {
      print('Failed to clear cart: $e');
    }
  }

  bool _isValidUuid(String? id) {
    return id != null && id.isNotEmpty;
  }
}
