# Практична робота 12 (Частина 1): Unit тести у Flutter

**Варіант 1:** Інтернет-магазин  
**Дисципліна:** Програмування для мобільних платформ

## Структура тестів
```text
test/
└── unit/
    ├── models/
    │   └── product_test.dart
    ├── services/
    │   └── shopping_cart_test.dart
    └── utils/
        └── order_validator_test.dart
Як запустити тести
Встановити залежності:

Bash
flutter pub get
Запустити unit-тести:

Bash
flutter test
Запустити тести з перевіркою покриття коду (coverage):

Bash
flutter test --coverage
Результат виконання flutter test --coverage
Plaintext
$ flutter test --coverage
00:02 +21: All tests passed!

Total Coverage: 90.00% (63/70 lines)
