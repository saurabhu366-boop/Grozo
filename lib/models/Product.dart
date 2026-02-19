class Product {
  final int? id;
  final String barcode;
  final String name;
  final double price;
  final int stockQuantity;

  Product({
    this.id,
    required this.barcode,
    required this.name,
    required this.price,
    required this.stockQuantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      barcode: json['barcode'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      stockQuantity: json['stockQuantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'price': price,
      'stockQuantity': stockQuantity,
    };
  }
}
