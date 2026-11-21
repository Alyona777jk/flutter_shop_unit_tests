import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_shop_unit_tests/models/product.dart';
import 'package:flutter_shop_unit_tests/repositories/promo_code_repository.dart';
import 'package:flutter_shop_unit_tests/services/shopping_cart.dart';

class MockPromoCodeRepository extends Mock implements PromoCodeRepository {}

void main() {
  late MockPromoCodeRepository mockPromoRepo;
  late ShoppingCart cart;

  const product1 = Product(id: '1', name: 'Book', price: 200.0); // без знижки
  const product2 = Product(id: '2', name: 'Headphones', price: 1000.0, discountPercent: 10.0); // зі знижкою = 900

  setUp(() {
    mockPromoRepo = MockPromoCodeRepository();
    cart = ShoppingCart(mockPromoRepo);
  });

  group('ShoppingCart Items Management', () {
    test('addItem adds new product and increments quantity if already exists', () {
      // Arrange & Act
      cart.addItem(product1, 2);
      cart.addItem(product1, 1);

      // Assert
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 3);
    });

    test('addItem throws ArgumentError when quantity is 0 or negative', () {
      // Arrange & Act & Assert
      expect(() => cart.addItem(product1, 0), throwsArgumentError);
      expect(() => cart.addItem(product1, -2), throwsArgumentError);
    });

    test('removeItem deletes product from cart by productId', () {
      // Arrange
      cart.addItem(product1, 1);
      cart.addItem(product2, 1);

      // Act
      cart.removeItem('1');

      // Assert
      expect(cart.items.length, 1);
      expect(cart.items.first.product.id, '2');
    });
  });

  group('ShoppingCart Total & PromoCode Calculation', () {
    test('total returns 0.0 for an empty cart', () {
      // Arrange & Act
      final total = cart.total;

      // Assert
      expect(total, 0.0);
    });

    test('total calculates sum considering product discounts', () {
      // Arrange
      cart.addItem(product1, 2); // 2 * 200 = 400
      cart.addItem(product2, 1); // 1 * 900 = 900

      // Act
      final total = cart.total;

      // Assert
      expect(total, 1300.0);
    });

    test('applyPromoCode applies 10%, 20%, or 30% discount and calls repository', () {
      // Arrange
      when(() => mockPromoRepo.getDiscount('SAVE20')).thenReturn(20.0);
      cart.addItem(product1, 5); // 5 * 200 = 1000

      // Act
      final isApplied = cart.applyPromoCode('SAVE20');

      // Assert
      expect(isApplied, isTrue);
      expect(cart.total, 800.0); // 1000 - 20%
      verify(() => mockPromoRepo.getDiscount('SAVE20')).called(1);
    });

    test('applyPromoCode returns false when promo code does not exist', () {
      // Arrange
      when(() => mockPromoRepo.getDiscount('INVALID')).thenReturn(null);
      cart.addItem(product1, 2); // 400

      // Act
      final isApplied = cart.applyPromoCode('INVALID');

      // Assert
      expect(isApplied, isFalse);
      expect(cart.total, 400.0);
      verify(() => mockPromoRepo.getDiscount('INVALID')).called(1);
    });

    test('applyPromoCode ignores empty string without calling repository', () {
      // Arrange
      cart.addItem(product1, 1);

      // Act
      final isApplied = cart.applyPromoCode('   ');

      // Assert
      expect(isApplied, isFalse);
      verifyNever(() => mockPromoRepo.getDiscount(any()));
    });
  });
}
