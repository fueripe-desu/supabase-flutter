import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  group('integed-valued float', () {
    test('should work correctly with positive base and exponent', () {
      final baseValue = Decimal(value: '3.0', precision: 2, scale: 1);
      const exponent = 4;
      final expected = Decimal(value: '81.0', precision: 3, scale: 1);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should work correctly with zero base and positive exponent', () {
      final baseValue = Decimal(value: '0.0', precision: 2, scale: 1);
      const exponent = 4;
      final expected = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should work correctly with positive base and zero exponent', () {
      final baseValue = Decimal(value: '3.0', precision: 2, scale: 1);
      const exponent = 0;
      final expected = Decimal(value: '1.0', precision: 2, scale: 1);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should work correctly with zero base and exponent', () {
      final baseValue = Decimal(value: '0.0', precision: 2, scale: 1);
      const exponent = 0;
      final expected = Decimal(value: '1.0', precision: 2, scale: 1);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should work correctly with negative base and positive odd exponent',
        () {
      final baseValue = Decimal(value: '-2.0', precision: 2, scale: 1);
      const exponent = 3;
      final expected = Decimal(value: '-8.0', precision: 2, scale: 1);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should work correctly with negative base and positive even exponent',
        () {
      final baseValue = Decimal(value: '-2.0', precision: 2, scale: 1);
      const exponent = 4;
      final expected = Decimal(value: '16.0', precision: 3, scale: 1);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should work correctly with positive base and negative exponent', () {
      final baseValue = Decimal(value: '2.0', precision: 2, scale: 1);
      const exponent = -1;
      final expected = Decimal(value: '0.5', precision: 2, scale: 1);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should work correctly with negative base and negative odd exponent',
        () {
      final baseValue = Decimal(value: '2.0', precision: 2, scale: 1);
      const exponent = -3;
      final expected = Decimal(value: '0.125', precision: 4, scale: 3);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should work correctly with negative base and negative even exponent',
        () {
      final baseValue = Decimal(value: '2.0', precision: 2, scale: 1);
      const exponent = -4;
      final expected = Decimal(value: '0.0625', precision: 5, scale: 4);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should throw ArgumentError when calculating zero base with negative exponent',
        () {
      final baseValue = Decimal(value: '0.0', precision: 2, scale: 1);
      const exponent = -4;
      expect(() => baseValue.pow(exponent), throwsArgumentError);
    });

    test('should return itself if exponent is 1', () {
      final baseValue = Decimal(value: '27.0', precision: 3, scale: 1);
      const exponent = 1;
      final expected = Decimal(value: '27.0', precision: 3, scale: 1);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should always return 1 if exponent is 0', () {
      final baseValue = Decimal(value: '27.0', precision: 3, scale: 1);
      const exponent = 0;
      final expected = Decimal(value: '1.0', precision: 2, scale: 1);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should always return 1 if base is 1', () {
      final baseValue = Decimal(value: '1.0', precision: 2, scale: 1);
      const exponent = 4;
      final expected = Decimal(value: '1.0', precision: 2, scale: 1);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });
  });

  group('fractional float', () {
    test('should work correctly with positive base and exponent', () {
      final baseValue = Decimal(value: '3.5', precision: 2, scale: 1);
      const exponent = 4;
      final expected = Decimal(value: '150.0625', precision: 7, scale: 4);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should work correctly with positive base and zero exponent', () {
      final baseValue = Decimal(value: '3.5', precision: 2, scale: 1);
      const exponent = 0;
      final expected = Decimal(value: '1.0', precision: 2, scale: 1);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should work correctly with negative base and positive odd exponent',
        () {
      final baseValue = Decimal(value: '-2.5', precision: 2, scale: 1);
      const exponent = 3;
      final expected = Decimal(value: '-15.625', precision: 5, scale: 3);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should work correctly with negative base and positive even exponent',
        () {
      final baseValue = Decimal(value: '-2.5', precision: 2, scale: 1);
      const exponent = 4;
      final expected = Decimal(value: '39.0625', precision: 6, scale: 4);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should work correctly with positive base and negative exponent', () {
      final baseValue = Decimal(value: '2.5', precision: 2, scale: 1);
      const exponent = -1;
      final expected = Decimal(value: '0.4', precision: 2, scale: 1);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should work correctly with negative base and negative odd exponent',
        () {
      final baseValue = Decimal(value: '-2.5', precision: 2, scale: 1);
      const exponent = -3;
      final expected = Decimal(value: '-0.064', precision: 4, scale: 3);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should work correctly with negative base and negative even exponent',
        () {
      final baseValue = Decimal(value: '-2.5', precision: 2, scale: 1);
      const exponent = -4;
      final expected = Decimal(value: '0.0256', precision: 5, scale: 4);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself if exponent is 1', () {
      final baseValue = Decimal(value: '27.5', precision: 3, scale: 1);
      const exponent = 1;
      final expected = Decimal(value: '27.5', precision: 3, scale: 1);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });

    test('should always return 1 if exponent is 0', () {
      final baseValue = Decimal(value: '27.5', precision: 3, scale: 1);
      const exponent = 0;
      final expected = Decimal(value: '1.0', precision: 2, scale: 1);
      final operation = baseValue.pow(exponent);
      expect(operation.identicalTo(expected), true);
    });
  });
}
