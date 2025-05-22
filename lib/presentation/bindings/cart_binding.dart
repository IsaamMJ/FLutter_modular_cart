import 'package:get/get.dart';
import '../../cart_module_config.dart';
import '../../controller/cart_controller.dart';
import '../../core/events/cart_event_bus.dart';
import '../../core/services/cart_service.dart';
import '../../core/services/i_cart_service.dart';
import '../../data/repository/cart_repository_impl.dart';
import '../../domain/repository/cart_repository.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';

class CartBinding extends Bindings {
  final CartModuleConfig config;

  CartBinding(this.config);

  @override
  void dependencies() {
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
        config, // ✅ Pass full config (for user + log hook)
        Get.find<CartEventBus>(),
      ),
      permanent: true,
    );

    // 🔹 Cart Service (interface)
    Get.lazyPut<ICartService>(
          () => CartService(Get.find<CartController>()),
      fenix: true,
    );
  }
}
