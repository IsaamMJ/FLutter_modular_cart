import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../presentation/bindings/cart_binding.dart';
import '../presentation/pages/cart_page.dart';
import 'app_routes.dart';

class CartPages {
  static List<GetPage> routes({
    required SupabaseClient supabaseClient,
    required String userId, // ✅ injected from host
  }) {
    return [
      GetPage(
        name: AppRoutes.cart,
        page: () => const CartPage(),
        binding: CartBinding(
          supabaseClient: supabaseClient,
          userId: userId,
        ),
        // optional: if cart page should persist controller forever
        // participates in GetX's routing stack
        participatesInRootNavigator: true,
      ),
    ];
  }
}
