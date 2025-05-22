import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/services/i_user_context.dart';

class CartModuleConfig {
  final SupabaseClient supabaseClient;
  final IUserContext userContext;

  /// Optional: host can listen to cart-related lifecycle events
  final void Function(String event, Map<String, dynamic> data)? onEventLog;

  const CartModuleConfig({
    required this.supabaseClient,
    required this.userContext,
    this.onEventLog,
  });
}

