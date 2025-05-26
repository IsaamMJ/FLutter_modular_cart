import 'package:supabase_flutter/supabase_flutter.dart';

import 'cart_module.dart';
import 'cart_module_config.dart';
import 'core/services/i_user_context.dart';

class CartModuleInitializer {
  static void init({
    required SupabaseClient supabaseClient,
    required IUserContext userContext,
    void Function(String event, Map<String, dynamic> data)? onEventLog,
  }) {
    final config = CartModuleConfig(
      supabaseClient: supabaseClient,
      userContext: userContext,
      onEventLog: onEventLog,
    );

    CartModule.init(config);
  }
}
