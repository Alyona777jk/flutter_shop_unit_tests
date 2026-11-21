import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shop_unit_tests/utils/order_validator.dart';

void main() {
  late OrderValidator validator;

  setUp(() {
    validator = OrderValidator();
  });

  group('OrderValidator - Address Validation', () {
    test('returns true for valid street, city, and 5-digit postal code', () {
      // Arrange & Act
      final result = validator.isValidAddress(
        street: 'просп. Дмитра Яворницького, 50',
        city: 'Дніпро',
        postalCode: '49000',
      );

      // Assert
      expect(result, isTrue);
    });

    test('returns false when street or city is empty or postal code is invalid', () {
      // Arrange & Act & Assert
      expect(
        validator.isValidAddress(street: '', city: 'Київ', postalCode: '01001'),
        isFalse,
      );
      expect(
        validator.isValidAddress(street: 'Хрещатик 1', city: '   ', postalCode: '01001'),
        isFalse,
      );
      expect(
        validator.isValidAddress(street: 'Хрещатик 1', city: 'Київ', postalCode: '123'),
        isFalse,
      );
    });
  });

  group('OrderValidator - Credit Card Validation', () {
    final fixedDate = DateTime(2026, 11, 21);

    test('returns true for valid 16-digit card and future expiry date', () {
      // Arrange & Act
      final result = validator.isValidCreditCard(
        cardNumber: '4149 4991 0000 1234',
        expiryDate: '12/28',
        currentDate: fixedDate,
      );

      // Assert
      expect(result, isTrue);
    });

    test('returns false when card number is not 16 digits', () {
      // Arrange & Act
      final result = validator.isValidCreditCard(
        cardNumber: '414949910000',
        expiryDate: '12/28',
        currentDate: fixedDate,
      );

      // Assert
      expect(result, isFalse);
    });

    test('returns false when card is expired or format is invalid', () {
      // Arrange & Act & Assert
      expect(
        validator.isValidCreditCard(
          cardNumber: '4149499100001234',
          expiryDate: '05/25', // прострочена
          currentDate: fixedDate,
        ),
        isFalse,
      );
      expect(
        validator.isValidCreditCard(
          cardNumber: '4149499100001234',
          expiryDate: '13/28', // неіснуючий місяць
          currentDate: fixedDate,
        ),
        isFalse,
      );
    });
  });

  group('OrderValidator - Minimum Order Amount', () {
    test('returns true when amount is equal to or greater than 50 UAH', () {
      // Arrange & Act & Assert
      expect(validator.isValidOrderAmount(50.0), isTrue); // граничне значення
      expect(validator.isValidOrderAmount(150.5), isTrue);
    });

    test('returns false when amount is less than 50 UAH', () {
      // Arrange & Act & Assert
      expect(validator.isValidOrderAmount(49.99), isFalse); // граничне значення
      expect(validator.isValidOrderAmount(0.0), isFalse);
    });
  });
}
