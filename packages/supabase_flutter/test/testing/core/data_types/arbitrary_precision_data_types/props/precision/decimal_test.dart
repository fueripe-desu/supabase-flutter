import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  group('positive values', () {
    test('should return the precision', () {
      final numeric = Decimal(precision: 5, scale: 3, value: '0');
      expect(numeric.precision, 5);
    });

    test('should calculate precision automatically if unconstrained', () {
      final numeric = Decimal(value: '0');
      expect(numeric.precision, 1);
    });

    test('should return the precision of int Decimal', () {
      final numeric = Decimal(precision: 5, scale: 0, value: '12345');
      expect(numeric.precision, 5);
    });

    test('should return the precision of float Decimal', () {
      final numeric = Decimal(precision: 5, scale: 2, value: '12345.67');
      expect(numeric.precision, 5);
    });

    test('should return the precision of negative scale Decimal', () {
      final numeric = Decimal(precision: 2, scale: -1, value: '34');
      expect(numeric.precision, 2);
    });

    test('should return the precision of fractional Decimal', () {
      final numeric = Decimal(precision: 2, scale: 2, value: '0.14');
      expect(numeric.precision, 2);
    });
  });

  group('negative values', () {
    test('should calculate precision automatically if unconstrained', () {
      final numeric = Decimal(value: '-23');
      expect(numeric.precision, 2);
    });

    test('should return the precision of int Decimal', () {
      final numeric = Decimal(precision: 5, scale: 0, value: '-12345');
      expect(numeric.precision, 5);
    });

    test('should return the precision of float Decimal', () {
      final numeric = Decimal(precision: 5, scale: 2, value: '-12345.67');
      expect(numeric.precision, 5);
    });

    test('should return the precision of negative scale Decimal', () {
      final numeric = Decimal(precision: 2, scale: -1, value: '-34');
      expect(numeric.precision, 2);
    });

    test('should return the precision of fractional Decimal', () {
      final numeric = Decimal(precision: 2, scale: 2, value: '-0.14');
      expect(numeric.precision, 2);
    });
  });
}
