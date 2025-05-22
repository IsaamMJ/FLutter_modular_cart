import '../../domain/entity/cart_item.dart';

class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? errorMessage;

  const CartState({
    required this.items,
    required this.isLoading,
    this.errorMessage,
  });

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  static const empty = CartState(items: [], isLoading: false);

  @override
  String toString() =>
      'CartState(items: ${items.length}, loading: $isLoading, error: $errorMessage)';
}
