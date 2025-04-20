import 'product.dart';

class CartItem {
  final int id;
  final Product product;
  int quantity;

  CartItem({ required this.id, required this.product, this.quantity = 1 });

  double get subtotal => product.finalPrice * quantity;
}
