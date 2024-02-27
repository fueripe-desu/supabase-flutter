import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/filters/filter_type_caster.dart';
import 'package:supabase_flutter/src/testing/range_type/range_type.dart';

void main() {
  late final bool Function(dynamic baseValue, dynamic castValue) cast;
  late final bool Function(dynamic baseValue, dynamic castValue) invalidCast;
  late final bool Function(dynamic baseValue, dynamic castValue) checkType;

  late final RangeType Function(String range) range;

  setUpAll(() {
    cast = (baseValue, castValue) {
      final result = FilterTypeCaster().cast(baseValue, castValue);

      if (result.baseValue is Map && result.castValue is Map) {
        return const MapEquality().equals(result.baseValue, result.castValue);
      }

      if (result.baseValue is List && result.castValue is List) {
        return const DeepCollectionEquality.unordered()
            .equals(result.baseValue, result.castValue);
      }

      return result.baseValue == result.castValue;
    };

    invalidCast = (baseValue, castValue) {
      final result = FilterTypeCaster().cast(baseValue, castValue);
      return result.wasSucessful == false;
    };

    checkType = (baseValue, castValue) {
      final result = FilterTypeCaster().cast(baseValue, castValue);

      if (result.baseValue is Map && result.castValue is Map) {
        return true;
      }

      if (result.baseValue is List && result.castValue is List) {
        return true;
      }

      if (result.baseValue is RangeType && result.castValue is RangeType) {
        return true;
      }

      return result.baseValue.runtimeType == result.castValue.runtimeType;
    };

    range = (range) => RangeType.createRange(range: range);
  });

  group('string base value', () {
    test('should not affect if value is already string', () {
      expect(cast('sample', 'sample'), true);
    });

    test('should be able to cast int', () {
      expect(cast('22', 22), true);
    });

    test('should be able to cast double', () {
      expect(cast('22.5', 22.5), true);
    });

    test('should be able to cast bool', () {
      expect(cast('true', true), true);
      expect(cast('false', false), true);
    });

    test('should be able to cast DateTime', () {
      expect(checkType('sample', DateTime(2022, 12, 31)), true);
    });

    test('should be able to cast range', () {
      expect(cast('[10,20]', range('[10,20]')), true);
    });

    test('should be able to cast JSON', () {
      expect(cast('{"value": 12}', {"value": 12}), true);
      expect(checkType('{"value": 12}', {"value": 12}), true);
    });

    test('should be able to cast List', () {
      expect(cast('[10, 20, 30]', [10, 20, 30]), true);
      expect(checkType('sample', [10, 20, 30]), true);
    });
  });

  group('int base value', () {
    test('should not affect if value is already int', () {
      expect(cast(22, 22), true);
    });

    test('should be able to cast a valid string', () {
      expect(cast(22, '22'), true);
      expect(checkType(22, '33'), true);
    });

    test('should not cast an invalid string', () {
      expect(invalidCast(22, 'invalid'), true);
    });

    test('should not cast double', () {
      expect(invalidCast(22, 22.5), true);
    });

    test('should not cast bool', () {
      expect(invalidCast(22, true), true);
      expect(invalidCast(22, false), true);
    });

    test('should not cast DateTime', () {
      expect(invalidCast(22, DateTime(2022, 12, 31)), true);
    });

    test('should not cast range', () {
      expect(invalidCast(22, range('[10, 20]')), true);
    });

    test('should not cast JSON', () {
      expect(invalidCast(22, {'value': 20}), true);
    });

    test('should not cast List', () {
      expect(invalidCast(22, [1, 2, 3]), true);
    });
  });

  group('double base value', () {
    test('should not affect if value is already double', () {
      expect(cast(22.5, 22.5), true);
    });

    test('should be able to cast a valid string', () {
      expect(cast(22.5, '22.5'), true);
      expect(checkType(22.5, '33.5'), true);
    });
    test('should be able to cast int', () {
      expect(cast(22.0, 22), true);
    });

    test('should not cast an invalid string', () {
      expect(invalidCast(22.5, 'invalid'), true);
    });

    test('should not cast bool', () {
      expect(invalidCast(22.5, true), true);
      expect(invalidCast(22.5, false), true);
    });

    test('should not cast DateTime', () {
      expect(invalidCast(22.5, DateTime(2022, 12, 31)), true);
    });

    test('should not cast range', () {
      expect(invalidCast(22.5, range('[10, 20]')), true);
    });

    test('should not cast JSON', () {
      expect(invalidCast(22.5, {'value': 20}), true);
    });

    test('should not cast List', () {
      expect(invalidCast(22.5, [1, 2, 3]), true);
    });
  });

  group('json base value', () {
    test('should not affect if value is already JSON', () {
      expect(cast({'value': 1}, {'value': 1}), true);
    });

    test('should be able to cast a valid string', () {
      expect(cast({'value': 1}, '{"value": 1}'), true);
      expect(checkType({'value': 1}, '{"value": 2}'), true);
    });

    test('should be able to cast an invalid string (considered as String)', () {
      expect(checkType({'value': 1}, 'invalid'), true);
    });

    test('should be able to cast int (considered as String)', () {
      expect(checkType({'value': 1}, 22), true);
    });

    test('should be able to cast double (considered as String)', () {
      expect(checkType({'value': 1}, 22.5), true);
    });

    test('should be able to cast bool (considered as String)', () {
      expect(checkType({'value': 1}, true), true);
      expect(checkType({'value': 1}, false), true);
    });

    test('should be able to cast DateTime', () {
      expect(checkType({'value': 1}, DateTime(2022, 12, 31)), true);
    });

    test('should be able to cast range', () {
      expect(checkType({'value': 1}, range('[10, 20]')), true);
    });

    test('should be able to cast List', () {
      expect(checkType({'value': 1}, [1, 2, 3]), true);
    });
  });

  group('datetime base value', () {
    test('should not affect if value is already DateTime', () {
      expect(cast(DateTime(2022, 12, 31), DateTime(2022, 12, 31)), true);
    });

    test('should be able to cast a valid string', () {
      expect(cast(DateTime(2022, 12, 31), '2022-12-31'), true);
      expect(checkType(DateTime(2022, 12, 31), '2023-01-01'), true);
    });

    test('should not cast an invalid string', () {
      expect(invalidCast(DateTime(2022, 12, 31), 'invalid'), true);
    });

    test('should not cast int', () {
      expect(invalidCast(DateTime(2022, 12, 31), 22), true);
    });

    test('should not cast double', () {
      expect(invalidCast(DateTime(2022, 12, 31), 22.5), true);
    });

    test('should not cast bool', () {
      expect(invalidCast(DateTime(2022, 12, 31), true), true);
      expect(invalidCast(DateTime(2022, 12, 31), false), true);
    });

    test('should not cast JSON', () {
      expect(invalidCast(DateTime(2022, 12, 31), {'value': 1}), true);
    });

    test('should not cast range', () {
      expect(invalidCast(DateTime(2022, 12, 31), range('[10, 20]')), true);
    });

    test('should not cast List', () {
      expect(invalidCast(DateTime(2022, 12, 31), [1, 2, 3]), true);
    });
  });

  group('bool base value', () {
    test('should not affect if value is already range', () {
      expect(cast(true, true), true);
    });

    test('should be able to cast a valid string', () {
      expect(cast(true, 'true'), true);
      expect(checkType(true, 'false'), true);
    });

    test('should not cast an invalid string', () {
      expect(invalidCast(true, 'invalid'), true);
    });

    test('should not cast int', () {
      expect(invalidCast(true, 22), true);
    });

    test('should not cast double', () {
      expect(invalidCast(true, 22.5), true);
    });

    test('should not cast DateTime', () {
      expect(invalidCast(true, DateTime(2022, 12, 31)), true);
    });

    test('should not cast JSON', () {
      expect(invalidCast(true, {'value': 1}), true);
    });

    test('should not cast range', () {
      expect(invalidCast(true, range('[10, 20]')), true);
    });

    test('should not cast List', () {
      expect(invalidCast(true, [1, 2, 3]), true);
    });
  });

  group('range base value', () {
    test('should not affect if value is already bool', () {
      expect(cast(range('[10, 20]'), range('[10, 20]')), true);
    });

    test('should be able to cast a valid string', () {
      expect(cast(range('[10, 20]'), '[10, 20]'), true);
      expect(checkType(range('[10, 20]'), '[2022-01-01, 2022-12-31]'), true);
    });

    test('should not cast an invalid string', () {
      expect(invalidCast(range('[10, 20]'), 'invalid'), true);
    });

    test('should not cast int', () {
      expect(invalidCast(range('[10, 20]'), 22), true);
    });

    test('should not cast double', () {
      expect(invalidCast(range('[10, 20]'), 22.5), true);
    });

    test('should not cast bool', () {
      expect(invalidCast(range('[10, 20]'), true), true);
    });

    test('should not cast DateTime', () {
      expect(invalidCast(range('[10, 20]'), DateTime(2022, 12, 31)), true);
    });

    test('should not cast JSON', () {
      expect(invalidCast(range('[10, 20]'), {'value': 1}), true);
    });

    test('should not cast List', () {
      expect(invalidCast(range('[10, 20]'), [1, 2, 3]), true);
    });
  });

  group('list base value', () {
    test('should not affect if value is already a list', () {
      expect(cast([1, 2, 3, 4], [1, 2, 3, 4]), true);
    });

    test('should be able to cast a valid string', () {
      expect(cast([1, 2, 3, 4], '[1, 2, 3, 4]'), true);
      expect(cast([1, 2, 3, 4], '{1, 2, 3, 4}'), true);
      expect(
        checkType([1, 2, 3, 4], '[2022-01-01, 2022-12-31, 2023-01-01]'),
        true,
      );
    });

    test('should be able to cast nested list strings', () {
      expect(
        cast(
          [
            [1, 2],
            [
              3,
              [4, 5, 6]
            ]
          ],
          '[{1, 2}, [3, [4, 5, 6]]]',
        ),
        true,
      );
      expect(cast([1, 2, 3, 4], '{1, 2, 3, 4}'), true);
    });

    test('should be able to cast nested lists of one element', () {
      expect(
        cast(
          [
            1,
            [2]
          ],
          '[1, [2]]',
        ),
        true,
      );
    });

    test(
        'should be able to cast nested lists with a range in the innermost level',
        () {
      expect(
        cast(
          ['sample', range('[2, 4]')],
          '["sample", [2, 4]]',
        ),
        true,
      );
    });

    test(
        'should be able to cast nested lists with a range in the outermost level',
        () {
      expect(
        cast(
          [
            range('[1, 5]'),
            ['sample']
          ],
          '[[1, 5], ["sample"]]',
        ),
        true,
      );
    });

    test('should be able to cast empty nested lists in the innermost level',
        () {
      expect(
        cast(
          [1, []],
          '[1, []]',
        ),
        true,
      );
    });

    test('should be able to cast empty nested lists in the outermost level',
        () {
      expect(
        cast(
          [
            [],
            [2]
          ],
          '[[], [2]]',
        ),
        true,
      );
    });

    test('should not cast an invalid string', () {
      expect(invalidCast([1, 2, 3, 4], 'invalid'), true);
    });

    test('should not cast int', () {
      expect(invalidCast([1, 2, 3, 4], 22), true);
    });

    test('should not cast double', () {
      expect(invalidCast([1, 2, 3, 4], 22.5), true);
    });

    test('should not cast bool', () {
      expect(invalidCast([1, 2, 3, 4], true), true);
    });

    test('should not cast DateTime', () {
      expect(invalidCast([1, 2, 3, 4], DateTime(2022, 12, 31)), true);
    });

    test('should not cast JSON', () {
      expect(invalidCast([1, 2, 3, 4], {'value': 1}), true);
    });

    test('should not cast range', () {
      expect(invalidCast([1, 2, 3, 4], range('[10, 20]')), true);
    });
  });
}
