import '../models/product.dart';
import '../repositories/promo_code_repository.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class ShoppingCart {
  final PromoCodeRepository promoCodeRepository;
  final Map<String, CartItem> _items = {};
  double _promoDiscountPercent = 0.0;

  ShoppingCart(this.promoCodeRepository);

  List<CartItem> get items => _items.values.toList();
  double get promoDiscountPercent => _promoDiscountPercent;

  void addItem(Product product, int quantity) {
    if (quantity <= 0) {
      throw ArgumentError('Кількість товару має бути більшою за 0');
    }
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItem(product: product, quantity: quantity);
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
  }

  /// Застосовує промокод (підтримуються знижки 10%, 20%, 30%)
  bool applyPromoCode(String code) {
    if (code.trim().isEmpty) return false;

    final discount = promoCodeRepository.getDiscount(code);
    if (discount != null && (discount == 10.0 || discount == 20.0 || discount == 30.0)) {
      _promoDiscountPercent = discount;
      return true;
    }
    return false;
  }

  /// Загальна сума з урахуванням знижок на товари та промокоду
  double get total {
    if (_items.isEmpty) return 0.0;

    final subtotal = _items.values.fold<double>(
      0.0,
      (sum, item) => sum + (item.product.discountedPrice * item.quantity),
    );

    if (_promoDiscountPercent > 0) {
      return subtotal * (1 - _promoDiscountPercent / 100);
    }
    return subtotal;
  }
}
