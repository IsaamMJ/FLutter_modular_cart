import 'package:cart_module/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'routes/app_routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rdjdvatbbhwwzjtqvdru.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJkamR2YXRiYmh3d3pqdHF2ZHJ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0NTY5MjUsImV4cCI6MjA2MzAzMjkyNX0.JG2obBbs78w3WpIjXwT91SvpHIsC7H8axnw7mpfepWA',
  );

  const testUserId = '32500b6a-67e5-4df2-972d-bad675322aaa'; // ✅ Use test user for local preview

  runApp(CartApp(userId: testUserId, supabaseClient: Supabase.instance.client));
}

class CartApp extends StatelessWidget {
  final String userId;
  final SupabaseClient supabaseClient;

  const CartApp({
    super.key,
    required this.userId,
    required this.supabaseClient,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cart Module Preview',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.cart,
      getPages: CartPages.routes(
        supabaseClient: supabaseClient,
        userId: userId,
      ),
    );
  }
}
