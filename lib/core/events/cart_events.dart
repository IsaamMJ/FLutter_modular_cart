abstract class CartEvent {}

class CartFetched extends CartEvent {}

class ItemAddedToCart extends CartEvent {
  final String productId;
  final int quantity;

  ItemAddedToCart(this.productId, this.quantity);
}

class ItemRemovedFromCart extends CartEvent {
  final String itemId;

  ItemRemovedFromCart(this.itemId);
}

class CartCleared extends CartEvent {}
