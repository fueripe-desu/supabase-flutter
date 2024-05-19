import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  group('positive values', () {
    test('should return the scale', () {
      final numeric = Numeric(precision: 5, scale: 3, value: '0');
      expect(numeric.scale, 3);
    });

    test('should return the scale of int Numeric', () {
      final numeric = Numeric(precision: 5, scale: 0, value: '12345');
      expect(numeric.scale, 0);
    });

    test('should return the scale of unconstrained int Numeric', () {
      final numeric = Numeric(value: '12345');
      expect(numeric.scale, 0);
    });

    test('should return the scale of float Numeric', () {
      final numeric = Numeric(precision: 5, scale: 3, value: '12345.678');
      expect(numeric.scale, 3);
    });

    test('should return the scale of unconstrained float Numeric', () {
      final numeric = Numeric(value: '12345.678');
      expect(numeric.scale, 3);
    });

    test('should return the scale of negative scale Numeric', () {
      final numeric = Numeric(precision: 2, scale: -1, value: '34');
      expect(numeric.scale, -1);
    });

    test('should return the scale of fractional Numeric', () {
      final numeric = Numeric(precision: 2, scale: 2, value: '0.14');
      expect(numeric.scale, 2);
    });

    test('should return 0 if scale is null', () {
      final numeric = Numeric(precision: 5, value: '0');
      expect(numeric.precision, 5);
      expect(numeric.scale, 0);
    });
  });

  group('negative values', () {
    test('should return the scale of int Numeric', () {
      final numeric = Numeric(precision: 5, scale: 0, value: '-12345');
      expect(numeric.scale, 0);
    });

    test('should return the scale of unconstrained int Numeric', () {
      final numeric = Numeric(value: '-12345');
      expect(numeric.scale, 0);
    });

    test('should return the scale of float Numeric', () {
      final numeric = Numeric(precision: 5, scale: 3, value: '-12345.678');
      expect(numeric.scale, 3);
    });

    test('should return the scale of unconstrained float Numeric', () {
      final numeric = Numeric(value: '-12345.678');
      expect(numeric.scale, 3);
    });

    test('should return the scale of negative scale Numeric', () {
      final numeric = Numeric(precision: 2, scale: -1, value: '-34');
      expect(numeric.scale, -1);
    });

    test('should return the scale of fractional Numeric', () {
      final numeric = Numeric(precision: 2, scale: 2, value: '-0.14');
      expect(numeric.scale, 2);
    });

    test('should return 0 if scale is null', () {
      final numeric = Numeric(precision: 5, value: '-1');
      expect(numeric.precision, 5);
      expect(numeric.scale, 0);
    });
  });
}
