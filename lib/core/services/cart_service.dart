import '../../controller/cart_controller.dart';
import '../../domain/entity/cart_item.dart';
import '../state/cart_state.dart';
import 'i_cart_service.dart';

class CartService implements ICartService {
  final CartController _controller;

  CartService(this._controller);

  @override
  List<CartItem> get items => _controller.state.value.items;

  @override
  bool get isLoading => _controller.state.value.isLoading;

  @override
  Stream<CartState> get cartStream => _controller.cartStream;

  @override
  String get errorMessage => _controller.state.value.errorMessage ?? '';

  @override
  Future<void> fetchCart() => _controller.fetchCart();

  @override
  Future<void> addItem(String productId, int quantity) =>
      _controller.addItem(productId, quantity);

  @override
  Future<void> removeItem(String? itemId) =>
      _controller.removeItem(itemId);

  @override
  Future<void> clearCart() => _controller.clearCart();
}
