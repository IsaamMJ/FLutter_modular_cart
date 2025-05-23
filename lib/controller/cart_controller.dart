import 'package:get/get.dart';
import '../../cart_module_config.dart';
import '../../core/services/i_user_context.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';
import '../../domain/entity/cart_item.dart';
import '../core/events/cart_event_bus.dart';
import '../core/events/cart_events.dart';
import '../core/state/cart_state.dart';
import '../domain/entity/product.dart';

class CartController extends GetxController {
  final GetCartUseCase getCart;
  final AddToCartUseCase addToCart;
  final RemoveFromCartUseCase removeFromCart;
  final UpdateCartQuantityUseCase updateCartQuantity;
  final CartModuleConfig config;
  final CartEventBus eventBus;

  CartController(
      this.getCart,
      this.addToCart,
      this.removeFromCart,
      this.updateCartQuantity,
      this.config,
      this.eventBus,
      );

  IUserContext get userContext => config.userContext;

  final Rx<CartState> state = CartState.empty.obs;

  List<CartItem> get cartItems => state.value.items;
  bool get isLoading => state.value.isLoading;
  String? get errorMessage => state.value.errorMessage;

  Stream<CartState> get cartStream => state.stream;

  @override
  void onInit() {
    super.onInit();

    // ✅ Fetch cart only if user is authenticated
    if (userContext.currentUserId.isNotEmpty) {
      fetchCart();
    }
  }

  Future<void> fetchCart() async {
    state.value = state.value.copyWith(isLoading: true, errorMessage: null);

    try {
      final items = await getCart(userContext.currentUserId);
      state.value = state.value.copyWith(items: items);
      eventBus.emit(CartFetched());

      config.onEventLog?.call('cart_fetched', {
        'userId': userContext.currentUserId,
        'itemCount': items.length,
      });
    } catch (e) {
      final error = 'Failed to fetch cart: $e';
      state.value = state.value.copyWith(errorMessage: error);
      print(error);

      config.onEventLog?.call('cart_fetch_failed', {
        'userId': userContext.currentUserId,
        'error': error,
      });
    } finally {
      state.value = state.value.copyWith(isLoading: false);
    }
  }

  Future<void> addItem(
      String productId,
      int quantity, {
        required String name,
        required double price,
        required String imageUrl,
      }) async {
    try {
      final existing = cartItems.firstWhereOrNull((i) => i.productId == productId);
      final newQuantity = (existing?.quantity ?? 0) + quantity;

      final item = CartItem(
        id: existing?.id,
        userId: userContext.currentUserId,
        productId: productId,
        quantity: newQuantity,
        product: Product(
          id: productId,
          name: name,
          price: price,
          imageUrl: imageUrl,
        ),
      );

      await addToCart(item);

      final updatedItems = List<CartItem>.from(cartItems);
      final index = updatedItems.indexWhere((i) => i.productId == productId);

      if (index != -1) {
        updatedItems[index] = item;
      } else {
        updatedItems.add(item);
      }

      state.value = state.value.copyWith(items: updatedItems);

      eventBus.emit(ItemAddedToCart(productId, quantity));

      config.onEventLog?.call('item_added', {
        'productId': productId,
        'quantity': newQuantity,
        'userId': userContext.currentUserId,
      });
    } catch (e) {
      print('❌ Failed to add item: $e');
    }
  }

  Future<void> removeItem(String? itemId) async {
    if (!_isValidUuid(itemId)) return;

    try {
      await removeFromCart(itemId!);

      final updatedItems = cartItems.where((item) => item.id != itemId).toList();
      state.value = state.value.copyWith(items: updatedItems);

      eventBus.emit(ItemRemovedFromCart(itemId));

      config.onEventLog?.call('item_removed', {
        'itemId': itemId,
        'userId': userContext.currentUserId,
      });
    } catch (e) {
      print('❌ Failed to remove item: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      for (final item in cartItems) {
        if (_isValidUuid(item.id)) {
          await removeFromCart(item.id!);
        }
      }

      state.value = state.value.copyWith(items: []);
      eventBus.emit(CartCleared());

      config.onEventLog?.call('cart_cleared', {
        'itemCount': cartItems.length,
        'userId': userContext.currentUserId,
      });
    } catch (e) {
      print('❌ Failed to clear cart: $e');
    }
  }

  bool _isValidUuid(String? id) => id != null && id.isNotEmpty;
}
