class OrderValidator {
  static const double minOrderAmount = 50.0;

  /// Перевірка адреси доставки: вулиця, місто (не порожні), індекс (5 цифр для України)
  bool isValidAddress({
    required String street,
    required String city,
    required String postalCode,
  }) {
    if (street.trim().isEmpty || city.trim().isEmpty) {
      return false;
    }
    final postalRegex = RegExp(r'^\d{5}$');
    return postalRegex.hasMatch(postalCode.trim());
  }

  /// Перевірка кредитної картки: рівно 16 цифр та валідний термін дії (MM/YY у майбутньому)
  bool isValidCreditCard({
    required String cardNumber,
    required String expiryDate,
    DateTime? currentDate,
  }) {
    final cleanedNumber = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^\d{16}$').hasMatch(cleanedNumber)) {
      return false;
    }

    final expiryRegex = RegExp(r'^(0[1-9]|1[0-2])\/(\d{2})$');
    final match = expiryRegex.firstMatch(expiryDate.trim());
    if (match == null) {
      return false;
    }

    final month = int.parse(match.group(1)!);
    final year = 2000 + int.parse(match.group(2)!);
    final now = currentDate ?? DateTime.now();

    if (year < now.year) return false;
    if (year == now.year && month < now.month) return false;

    return true;
  }

  /// Перевірка мінімальної суми замовлення (50 грн)
  bool isValidOrderAmount(double totalAmount) {
    return totalAmount >= minOrderAmount;
  }
}
