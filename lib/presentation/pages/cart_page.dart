import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/cart_controller.dart';
import '../../core/events/cart_event_bus.dart';
import '../../core/events/cart_events.dart';
import '../widgets/cart_item_card.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final CartController c;
  late final CartEventBus eventBus;

  @override
  void initState() {
    super.initState();
    c = Get.find<CartController>();
    eventBus = Get.find<CartEventBus>();

    // 🔔 Listen to cart events
    eventBus.events.listen((event) {
      if (event is ItemAddedToCart) {
        Get.snackbar(
          'Cart Updated',
          'Added ${event.quantity} x item(s)',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else if (event is ItemRemovedFromCart) {
        Get.snackbar(
          'Item Removed',
          'Item removed from cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else if (event is CartCleared) {
        Get.snackbar(
          'Cart Cleared',
          'All items removed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => c.fetchCart(),
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
        if (c.isLoading) {
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
                onRefresh: () => c.fetchCart(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  physics: const AlwaysScrollableScrollPhysics(),
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
