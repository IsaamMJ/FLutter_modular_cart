class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price)';
  }
}
