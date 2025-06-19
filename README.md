# 🛒 Cart Module (Flutter + GetX + Supabase)

A **fully modular, clean architecture-compliant Cart system** for Flutter apps. Designed to be **plug-and-play** within any host app using **GetX** for state management and **Supabase** as the backend.
This module is reusable, testable, and decoupled from the UI — making it suitable for production-grade e-commerce solutions.

---

## ✅ What’s Implemented

### ⚙️ Architecture Highlights

* **Clean Architecture**: Domain → Use Cases → Repository → Controller → UI
* **State Management**: Reactive `Rx<CartState>`
* **Event Bus**: Emits `CartCleared`, `ItemAddedToCart`, etc.
* **Facade & Service Layers**: Clear API for host app usage
* **Stream Support**: Exposes reactive `cartStream` for UI updates
* **Logging Hook**: Optional `onEventLog()` for custom analytics

### 📦 Core Features

* Add, update, and remove items from the cart
* Calculate totals and item counts
* Pull-to-refresh and external refresh trigger
* Headless interaction via `ICartService` and `CartFacade`
* Stateless design for flexible host integration
* Event-based UX (e.g., snackbars, logging)

---

## 🧩 What the Host App Must Provide

| Requirement        | Type          | Description                    |
| ------------------ | ------------- | ------------------------------ |
| `SupabaseClient`   | Supabase SDK  | Used for backend operations    |
| `IUserContext`     | Interface     | Supplies authenticated user ID |
| `CartModuleConfig` | Config Object | Passed to `CartModule.init()`  |

---

## 🧪 Integration Steps (Host App)

### 1. Implement a Concrete `IUserContext`

```dart
class AppUserContext extends IUserContext {
  final String userId;
  AppUserContext(this.userId);

  @override
  String get currentUserId => userId;
}
```

---

### 2. Initialize the Cart Module

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://your-project.supabase.co',
    anonKey: 'your-anon-key',
  );

  // Inject user context into GetX
  Get.put<IUserContext>(AppUserContext('user-uuid-here'));

  // Initialize the cart module
  CartModule.init(
    CartModuleConfig(
      supabaseClient: Supabase.instance.client,
      userContext: Get.find<IUserContext>(),
      onEventLog: (event, data) {
        print('LOG EVENT: $event → $data');
      },
    ),
  );

  runApp(MyApp());
}
```

---

### 3. Navigate to Cart

```dart
Get.toNamed('/cart'); // Or use CartRoutes.cart
```

---

## 🧠 Future Prompt for ChatGPT (Incase You find difficulty in understanding the project please be free to use this)

> *"You are looking at a modular Flutter e-commerce app with a decoupled cart module built using Clean Architecture, GetX, and Supabase. The `cart_module` exposes:*
>
> * *A controller using Rx<CartState>*
> * *An event bus (`CartEventBus`) that emits events like `CartCleared`, `ItemAddedToCart`*
> * *`CartModule.init(config)` for host integration*
> * *A service (`ICartService`) and facade (`CartFacade`) for headless interaction*
> * *Host injects `SupabaseClient` and `IUserContext`*
>
> *You can view/update cart, expose `cartStream`, track actions via optional `onEventLog`, and reuse the module across apps.*
>
> *If I face issues or want to enhance features (badges, cache, unit tests), help me build on this modular foundation without breaking separation of concerns."*

---

## ✅ Next Steps (Optional Enhancements)

* ✅ Add unit & widget tests
* 🌐 Add localization
* 📦 Implement caching layer
* 🔔 Add UI badge using `cartStream`
* 🚨 Improve error modeling and edge-case handling

Thank You - MOHAMED ISAAM M J
