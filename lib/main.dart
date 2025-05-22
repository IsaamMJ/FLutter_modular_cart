import 'package:cart_module/cart_module.dart'; // ✅ updated entry point
import 'package:cart_module/core/services/i_user_context.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rdjdvatbbhwwzjtqvdru.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJkamR2YXRiYmh3d3pqdHF2ZHJ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0NTY5MjUsImV4cCI6MjA2MzAzMjkyNX0.JG2obBbs78w3WpIjXwT91SvpHIsC7H8axnw7mpfepWA',
  );

  const testUserId = '32500b6a-67e5-4df2-972d-bad675322aaa';

  // ✅ Bind test user context
  Get.put<IUserContext>(_TestUserContext(testUserId));

  // ✅ Initialize the cart module
  CartModule.init(CartModuleConfig(
    supabaseClient: Supabase.instance.client,
    userContext: Get.find<IUserContext>(),
  ));

  runApp(const CartApp());
}

class CartApp extends StatelessWidget {
  const CartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cart Module Preview',
      debugShowCheckedModeBanner: false,
      initialRoute: '/cart',
      getPages: CartModule.getRoutes(), // ✅ use new routing method
    );
  }
}

// ✅ Simple test implementation of IUserContext
class _TestUserContext implements IUserContext {
  final String _userId;

  _TestUserContext(this._userId);

  @override
  String get currentUserId => _userId;
}
