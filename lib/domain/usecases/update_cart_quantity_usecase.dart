import '../repository/cart_repository.dart';

class UpdateCartQuantityUseCase {
  final CartRepository repository;

  UpdateCartQuantityUseCase(this.repository);

  Future<void> call(String? itemId, int quantity) async {
    if (itemId == null || itemId.isEmpty) {
      // Optionally: log error or handle invalid state
      return;
    }

    if (quantity <= 0) {
      // Optionally: remove item instead if quantity drops to zero
      // await repository.removeFromCart(itemId);
      return;
    }

    await repository.updateCartItemQuantity(itemId, quantity);
  }
}
