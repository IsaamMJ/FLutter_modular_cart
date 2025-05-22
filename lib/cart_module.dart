library cart;

export 'presentation/pages/cart_page.dart';
export 'routes/app_routes.dart';
export 'cart_module_config.dart';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'cart_module_config.dart';
import 'controller/cart_controller.dart';
import 'core/events/cart_event_bus.dart';
import 'core/services/cart_service.dart';
import 'core/services/i_cart_service.dart';
import 'core/services/i_user_context.dart';
import 'core/facade/cart_facade.dart';
import 'core/facade/cart_facade_impl.dart';
import 'data/repository/cart_repository_impl.dart';
import 'domain/repository/cart_repository.dart';
import 'domain/usecases/get_cart_usecase.dart';
import 'domain/usecases/add_to_cart_usecase.dart';
import 'domain/usecases/remove_from_cart_usecase.dart';
import 'domain/usecases/update_cart_quantity_usecase.dart';
import 'routes/app_routes.dart';
import 'presentation/pages/cart_page.dart';

class CartModule {
  static void init(CartModuleConfig config) {
    // 🔹 Repository
    Get.put<CartRepository>(
      CartRepositoryImpl(config.supabaseClient),
      permanent: true,
    );

    // 🔹 Use Cases
    Get.lazyPut(() => GetCartUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => AddToCartUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => RemoveFromCartUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdateCartQuantityUseCase(Get.find()), fenix: true);

    // 🔹 Event Bus
    Get.put<CartEventBus>(CartEventBus(), permanent: true);

    // 🔹 Controller
    Get.put<CartController>(
      CartController(
        Get.find<GetCartUseCase>(),
        Get.find<AddToCartUseCase>(),
        Get.find<RemoveFromCartUseCase>(),
        Get.find<UpdateCartQuantityUseCase>(),
        config, // ✅ Now passing full config (not just userContext)
        Get.find<CartEventBus>(),
      ),
      permanent: true,
    );

    // 🔹 Cart Service
    Get.lazyPut<ICartService>(
          () => CartService(Get.find<CartController>()),
      fenix: true,
    );

    // 🔹 Cart Facade
    Get.lazyPut<CartFacade>(
          () => CartFacadeImpl(Get.find<CartController>()),
      fenix: true,
    );
  }

  static List<GetPage> getRoutes() {
    return [
      GetPage(
        name: AppRoutes.cart,
        page: () => const CartPage(),
        binding: _EmptyCartBinding(),
        participatesInRootNavigator: false, // nested routes should be false
        transition: Transition.noTransition,
      ),
    ];
  }

}

// Satisfies GetX route requirement; bindings already handled in init()
class _EmptyCartBinding extends Bindings {
  @override
  void dependencies() {}
}
