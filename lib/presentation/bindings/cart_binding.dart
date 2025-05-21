import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controller/cart_controller.dart';
import '../../data/repository/cart_repository_impl.dart';
import '../../domain/repository/cart_repository.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';

class CartBinding extends Bindings {
  final SupabaseClient supabaseClient;
  final String userId;

  CartBinding({
    required this.supabaseClient,
    required this.userId,
  });

  @override
  void dependencies() {
    // ✅ Repository
    Get.put<CartRepository>(
      CartRepositoryImpl(supabaseClient),
      permanent: true,
    );

    // ✅ Use Cases (singleton, recreated only when needed)
    Get.lazyPut(() => GetCartUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => AddToCartUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => RemoveFromCartUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdateCartQuantityUseCase(Get.find()), fenix: true);

    // ✅ Cart Controller (permanently alive, available globally)
    Get.put(
      CartController(
        Get.find<GetCartUseCase>(),
        Get.find<AddToCartUseCase>(),
        Get.find<RemoveFromCartUseCase>(),
        Get.find<UpdateCartQuantityUseCase>(),
        userId,
      ),
      permanent: true,
    );
  }
}
