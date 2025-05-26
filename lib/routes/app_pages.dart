import 'package:get/get.dart';

import '../presentation/pages/cart_page.dart';
import '../presentation/bindings/cart_binding.dart';
import '../routes/app_routes.dart';
import '../cart_module.dart'; // ✅ To access CartModule.config

class CartPages {
  /// Returns the route definitions for the Cart Module.
  static List<GetPage> routes() {
    final config = CartModule.config;

    return [
      GetPage(
        name: AppRoutes.cart,
        page: () => const CartPage(),
        binding: CartBinding(config),
        participatesInRootNavigator: true,
      ),
    ];
  }
}
