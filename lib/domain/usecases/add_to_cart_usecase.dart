import 'package:collection/collection.dart';
import '../entity/cart_item.dart';
import '../repository/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<void> call(CartItem item) async {
    final existingItems = await repository.getCart(item.userId);

    final existing = existingItems.firstWhereOrNull(
          (i) => i.productId == item.productId,
    );

    if (existing != null && existing.id != null && existing.id!.isNotEmpty) {
      await repository.updateCartItemQuantity(existing.id!, item.quantity);
    } else {
      await repository.addToCart(item);
    }
  }
}
