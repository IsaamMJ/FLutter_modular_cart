import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entity/cart_item.dart';
import '../../domain/repository/cart_repository.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final SupabaseClient client;

  CartRepositoryImpl(this.client);

  @override
  Future<List<CartItem>> getCart(String userId) async {
    final response = await client
        .from('cart_items')
        .select('id, quantity, product:products(id, name, price, image_url)')
        .eq('user_id', userId)
        .withConverter(
          (data) => (data as List)
          .map((json) => CartItemModel.fromJson(json).toEntity())
          .toList(),
    );

    return response;
  }

  @override
  Future<void> addToCart(CartItem item) async {
    final model = CartItemModel.fromEntity(item);
    await client.from('cart_items').insert(model.toJson());
  }

  @override
  Future<void> updateCartItemQuantity(String itemId, int quantity) async {
    await client
        .from('cart_items')
        .update({'quantity': quantity})
        .eq('id', itemId);
  }

  @override
  Future<void> removeFromCart(String itemId) async {
    await client.from('cart_items').delete().eq('id', itemId);
  }
}
