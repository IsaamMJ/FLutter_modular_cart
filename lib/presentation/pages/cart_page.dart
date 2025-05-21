import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/cart_controller.dart';
import '../widgets/cart_item_card.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => c.fetchCart(), // ✅ Manual refresh
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              if (c.cartItems.isNotEmpty) {
                Get.defaultDialog(
                  title: 'Clear Cart',
                  middleText: 'Are you sure you want to clear the cart?',
                  textConfirm: 'Yes',
                  textCancel: 'No',
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    c.clearCart();
                    Get.back();
                  },
                );
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (c.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.cartItems.isEmpty) {
          return const Center(
            child: Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        final total = c.cartItems.fold<double>(
          0.0,
              (sum, item) => sum + (item.product?.price ?? 0) * item.quantity,
        );

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => c.fetchCart(), // ✅ Pull-to-refresh
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  physics: const AlwaysScrollableScrollPhysics(), // ensures gesture works even if few items
                  itemCount: c.cartItems.length,
                  itemBuilder: (_, i) {
                    final item = c.cartItems[i];
                    return CartItemCard(
                      item: item,
                      onRemove: () => c.removeItem(item.id),
                      onIncrease: () =>
                          c.addItem(item.productId, item.quantity + 1),
                      onDecrease: item.quantity > 1
                          ? () => c.addItem(item.productId, item.quantity - 1)
                          : null,
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: const Border(
                  top: BorderSide(color: Colors.grey),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
