import '../repository/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<void> call(String? itemId) async {
    if (itemId == null || itemId.isEmpty) {
      // Optional: log or handle this case in future
      return;
    }

    await repository.removeFromCart(itemId);
  }
}
