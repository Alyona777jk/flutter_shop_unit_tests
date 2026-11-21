abstract class PromoCodeRepository {
  /// Повертає відсоток знижки (наприклад, 10.0, 20.0, 30.0) або null, якщо промокод не існує
  double? getDiscount(String code);
}
