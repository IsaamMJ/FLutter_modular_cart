import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../cart_module_config.dart';
import '../presentation/bindings/cart_binding.dart';
import '../presentation/pages/cart_page.dart';
import 'app_routes.dart';
import '../core/services/i_user_context.dart';

class CartPages {
  static List<GetPage> routes({ required CartModuleConfig config })


  {
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
