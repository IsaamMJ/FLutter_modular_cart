import '../entity/cart_item.dart';
import '../repository/cart_repository.dart';

class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  Future<List<CartItem>> call(String userId) async {
    final items = await repository.getCart(userId);

    // Example: filter out zero-quantity items (if needed)
    // final filtered = items.where((item) => item.quantity > 0).toList();

    // Example: sort items alphabetically by product name
    // final sorted = filtered..sort((a, b) => (a.product?.name ?? '').compareTo(b.product?.name ?? ''));

    return items;
  }
}
