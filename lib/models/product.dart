class Product {
  final String id;
  final String name;
  final double price;
  final double discountPercent; // від 0 до 100

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.discountPercent = 0.0,
  });

  double get discountedPrice {
    if (discountPercent <= 0) return price;
    if (discountPercent >= 100) return 0.0;
    return price * (1 - discountPercent / 100);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'discountPercent': discountPercent,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    double? discountPercent,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      discountPercent: discountPercent ?? this.discountPercent,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.discountPercent == discountPercent;
  }

  @override
  int get hashCode => Object.hash(id, name, price, discountPercent);
}
