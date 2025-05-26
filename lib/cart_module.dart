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
import 'core/facade/cart_facade.dart';
import 'core/facade/cart_facade_impl.dart';
import 'data/repository/cart_repository_impl.dart';
import 'domain/repository/cart_repository.dart';
import 'domain/usecases/get_cart_usecase.dart';
import 'domain/usecases/add_to_cart_usecase.dart';
import 'domain/usecases/remove_from_cart_usecase.dart';
import 'domain/usecases/update_cart_quantity_usecase.dart';

class CartModule {
  /// Exposed config for use in routing
  static late final CartModuleConfig config;

  static void init(CartModuleConfig cfg) {
    config = cfg;
    final client = cfg.supabaseClient;

    // 🔹 Repository
    Get.put<CartRepository>(
      CartRepositoryImpl(client),
      permanent: true,
    );

    // 🔹 Use Cases
    Get
      ..lazyPut(() => GetCartUseCase(Get.find()), fenix: true)
      ..lazyPut(() => AddToCartUseCase(Get.find()), fenix: true)
      ..lazyPut(() => RemoveFromCartUseCase(Get.find()), fenix: true)
      ..lazyPut(() => UpdateCartQuantityUseCase(Get.find()), fenix: true);

    // 🔹 Event Bus
    Get.put<CartEventBus>(CartEventBus(), permanent: true);

    // 🔹 Controller
    Get.put<CartController>(
      CartController(
        Get.find<GetCartUseCase>(),
        Get.find<AddToCartUseCase>(),
        Get.find<RemoveFromCartUseCase>(),
        Get.find<UpdateCartQuantityUseCase>(),
        cfg,
        Get.find<CartEventBus>(),
      ),
      permanent: true,
    );

    // 🔹 Service and Facade
    Get
      ..lazyPut<ICartService>(() => CartService(Get.find()), fenix: true)
      ..lazyPut<CartFacade>(() => CartFacadeImpl(Get.find()), fenix: true);
  }
}
