import 'package:get/get.dart';

abstract class IUserContext {
  String get currentUserId;
  RxString get currentUserIdRx; // ✅ Added for reactive tracking
  bool get isLoggedIn;
}
