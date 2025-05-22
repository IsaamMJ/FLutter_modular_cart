import 'dart:async';
import 'cart_events.dart';

class CartEventBus {
  final _controller = StreamController<CartEvent>.broadcast();

  Stream<CartEvent> get events => _controller.stream;

  void emit(CartEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
