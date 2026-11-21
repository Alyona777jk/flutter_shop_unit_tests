import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop_unit_tests/models/product.dart';

void main() {
  group('Product Model Tests', () {
    test('fromJson creates valid Product instance', () {
      // Arrange
      final json = {
        'id': 'p1',
        'name': 'Laptop',
        'price': 25000.0,
        'discountPercent': 10.0,
      };

      // Act
      final product = Product.fromJson(json);

      // Assert
      expect(product.id, 'p1');
      expect(product.name, 'Laptop');
      expect(product.price, 25000.0);
      expect(product.discountPercent, 10.0);
    });

    test('toJson converts Product instance to Map correctly', () {
      // Arrange
      const product = Product(
        id: 'p2',
        name: 'Mouse',
        price: 500.0,
        discountPercent: 20.0,
      );

      // Act
      final json = product.toJson();

      // Assert
      expect(json, {
        'id': 'p2',
        'name': 'Mouse',
        'price': 500.0,
        'discountPercent': 20.0,
      });
    });

    test('discountedPrice calculates price with discount correctly', () {
      // Arrange
      const product = Product(
        id: 'p3',
        name: 'Keyboard',
        price: 1000.0,
        discountPercent: 25.0,
      );

      // Act
      final discounted = product.discountedPrice;

      // Assert
      expect(discounted, 750.0);
    });

    test('discountedPrice returns full price when discount is 0', () {
      // Arrange
      const product = Product(id: 'p4', name: 'Monitor', price: 8000.0);

      // Act
      final discounted = product.discountedPrice;

      // Assert
      expect(discounted, 8000.0);
    });

    test('copyWith returns a new Product with updated fields', () {
      // Arrange
      const original = Product(id: 'p1', name: 'Phone', price: 15000.0);

      // Act
      final updated = original.copyWith(price: 14000.0, discountPercent: 5.0);

      // Assert
      expect(updated.id, 'p1');
      expect(updated.name, 'Phone');
      expect(updated.price, 14000.0);
      expect(updated.discountPercent, 5.0);
    });

    test('equality operator compares all fields properly', () {
      // Arrange
      const product1 = Product(id: 'p1', name: 'Tablet', price: 12000.0, discountPercent: 10.0);
      const product2 = Product(id: 'p1', name: 'Tablet', price: 12000.0, discountPercent: 10.0);
      const product3 = Product(id: 'p2', name: 'Tablet', price: 12000.0, discountPercent: 10.0);

      // Act & Assert
      expect(product1 == product2, isTrue);
      expect(product1.hashCode, equals(product2.hashCode));
      expect(product1 == product3, isFalse);
    });
  });
}
