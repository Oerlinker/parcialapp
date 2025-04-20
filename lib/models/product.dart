class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double finalPrice;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.finalPrice,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {

    double _toDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      throw FormatException('No se puede convertir $value a double');
    }


    int _toInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        return int.tryParse(value) ?? 0;
      }
      throw FormatException('No se puede convertir $value a int');
    }

    return Product(
      id:           _toInt(json['id']),
      name:         json['name'] as String,
      description:  json['description'] as String? ?? '',
      price:        _toDouble(json['price']),
      finalPrice:   _toDouble(json['final_price']),
      stock:        _toInt(json['stock']),
    );
  }
}
