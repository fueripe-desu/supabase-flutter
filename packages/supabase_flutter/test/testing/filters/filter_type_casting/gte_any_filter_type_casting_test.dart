// ignore_for_file: dead_code

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/filters/filter_builder.dart';
import 'package:supabase_flutter/src/testing/range_type/range_type.dart';

void main() {
  // Set this to 'true' if you want to print errors logs.
  // If no error occurs then 'null' will be printed.
  const bool logFilterErrors = false;

  group('int base type', () {
    late final bool Function(dynamic filterValue) filter;

    setUpAll(() {
      filter = (filterValue) {
        final result = FilterBuilder([
          {'value': 1}
        ]).gteAny('value', filterValue).execute();

        if (logFilterErrors) {
          print(result.error.toString());
        }

        return result.isValid;
      };
    });

    test('should return false when filtering with int', () {
      expect(filter(22), false);
    });

    test('should return false when filtering with float', () {
      expect(filter(22.5), false);
    });

    test('should return true when filtering with valid string', () {
      expect(filter('{1, 2, 3, 4}'), true);
    });

    test('should return false when filtering with invalid string', () {
      expect(filter('invalid'), false);
    });

    test('should return false when filtering with bool', () {
      expect(filter(true), false);
    });

    test('should return false when filtering with datetime literal', () {
      expect(filter(DateTime(2022, 1, 1)), false);
    });

    test('should return false when filtering with datetime string', () {
      expect(filter('2022-01-01'), false);
    });

    test('should return false when filtering with range string', () {
      expect(filter('[10,20]'), false);
    });

    test('should return false when filtering with range literal', () {
      expect(filter(RangeType.createRange(range: '[10,20]')), false);
    });

    test('should return false when filtering with json literal', () {
      expect(filter({'value': 10}), false);
    });

    test('should return false when filtering with json string', () {
      expect(filter('{"value": 10}'), false);
    });

    test('should return true when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), true);
    });

    test('should return true when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), true);
    });

    test('should return false when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), false);
    });

    test('should return false when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), false);
    });

    test('should return true when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), true);
    });

    test('should return true when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), true);
    });

    test('should return false when filtering with bool list', () {
      expect(filter([true, false, true, false]), false);
    });

    test('should return false when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), false);
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), false);
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), false);
    });

    test('should return false when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), false);
    });

    test('should return false when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), false);
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        false,
      );
    });
  });

  group('float base type', () {
    late final bool Function(dynamic filterValue) filter;

    setUpAll(() {
      filter = (filterValue) {
        final result = FilterBuilder([
          {'value': 1.5}
        ]).gteAny('value', filterValue).execute();

        if (logFilterErrors) {
          print(result.error.toString());
        }

        return result.isValid;
      };
    });

    test('should return false when filtering with int', () {
      expect(filter(22), false);
    });

    test('should return false when filtering with float', () {
      expect(filter(22.5), false);
    });

    test('should return true when filtering with valid string', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), true);
    });

    test('should return false when filtering with invalid string', () {
      expect(filter('invalid'), false);
    });

    test('should return false when filtering with bool', () {
      expect(filter(true), false);
    });

    test('should return false when filtering with datetime literal', () {
      expect(filter(DateTime(2022, 1, 1)), false);
    });

    test('should return false when filtering with datetime string', () {
      expect(filter('2022-01-01'), false);
    });

    test('should return false when filtering with range string', () {
      expect(filter('[10,20]'), false);
    });

    test('should return false when filtering with range literal', () {
      expect(filter(RangeType.createRange(range: '[10,20]')), false);
    });

    test('should return false when filtering with json literal', () {
      expect(filter({'value': 10}), false);
    });

    test('should return false when filtering with json string', () {
      expect(filter('{"value": 10}'), false);
    });

    test('should return true when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), true);
    });

    test('should return true when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), true);
    });

    test('should return true when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), true);
    });

    test('should return true when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), true);
    });

    test('should return true when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), true);
    });

    test('should return true when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), true);
    });

    test('should return false when filtering with bool list', () {
      expect(filter([true, false, true, false]), false);
    });

    test('should return false when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), false);
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), false);
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), false);
    });

    test('should return false when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), false);
    });

    test('should return false when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), false);
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        false,
      );
    });
  });

  group('string base type', () {
    late final bool Function(dynamic filterValue) filter;

    setUpAll(() {
      filter = (filterValue) {
        final result = FilterBuilder([
          {'value': 'sample string'}
        ]).gteAny('value', filterValue).execute();

        if (logFilterErrors) {
          print(result.error.toString());
        }

        return result.isValid;
      };
    });

    test('should return false when filtering with int', () {
      expect(filter(22), false);
    });

    test('should return false when filtering with float', () {
      expect(filter(22.5), false);
    });

    test('should return true when filtering with valid string', () {
      expect(filter('{"sample", "string"}'), true);
    });

    test('should return false when filtering with invalid string', () {
      expect(filter('invalid'), false);
    });

    test('should return false when filtering with bool', () {
      expect(filter(true), false);
    });

    test('should return false when filtering with datetime literal', () {
      expect(filter(DateTime(2022, 1, 1)), false);
    });

    test('should return false when filtering with datetime string', () {
      expect(filter('2022-01-01'), false);
    });

    test('should return false when filtering with range string', () {
      expect(filter('[10,20]'), false);
    });

    test('should return false when filtering with range literal', () {
      expect(filter(RangeType.createRange(range: '[10,20]')), false);
    });

    test('should return false when filtering with json literal', () {
      expect(filter({'value': 10}), false);
    });

    test('should return false when filtering with json string', () {
      expect(filter('{"value": 10}'), false);
    });

    test('should return true when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), true);
    });

    test('should return true when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), true);
    });

    test('should return true when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), true);
    });

    test('should return true when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), true);
    });

    test('should return true when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), true);
    });

    test('should return true when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), true);
    });

    test('should return true when filtering with bool list', () {
      expect(filter([true, false, true, false]), true);
    });

    test('should return true when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), true);
    });

    test('should return true when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        true,
      );
    });

    test('should return true when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), true);
    });

    test('should return true when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), true);
    });

    test('should return true when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), true);
    });

    test('should return true when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), true);
    });

    test('should return true when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        true,
      );
    });

    test('should return true when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        true,
      );
    });

    test('should return true when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        true,
      );
    });

    test('should return true when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        true,
      );
    });
  });

  group('bool base type', () {
    late final bool Function(dynamic filterValue) filter;

    setUpAll(() {
      filter = (filterValue) {
        final result = FilterBuilder([
          {'value': true}
        ]).gteAny('value', filterValue).execute();

        if (logFilterErrors) {
          print(result.error.toString());
        }

        return result.isValid;
      };
    });

    test('should return false when filtering with int', () {
      expect(filter(22), false);
    });

    test('should return false when filtering with float', () {
      expect(filter(22.5), false);
    });

    test('should return true when filtering with valid string', () {
      expect(filter('{false, true, false}'), true);
    });

    test('should return false when filtering with invalid string', () {
      expect(filter('invalid'), false);
    });

    test('should return false when filtering with bool', () {
      expect(filter(true), false);
    });

    test('should return false when filtering with datetime literal', () {
      expect(filter(DateTime(2022, 1, 1)), false);
    });

    test('should return false when filtering with datetime string', () {
      expect(filter('2022-01-01'), false);
    });

    test('should return false when filtering with range string', () {
      expect(filter('[10,20]'), false);
    });

    test('should return false when filtering with range literal', () {
      expect(filter(RangeType.createRange(range: '[10,20]')), false);
    });

    test('should return false when filtering with json literal', () {
      expect(filter({'value': 10}), false);
    });

    test('should return false when filtering with json string', () {
      expect(filter('{"value": 10}'), false);
    });

    test('should return false when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), false);
    });

    test('should return false when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), false);
    });

    test('should return false when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), false);
    });

    test('should return false when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), false);
    });

    test('should return false when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), false);
    });

    test('should return false when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), false);
    });

    test('should return true when filtering with bool list', () {
      expect(filter([true, false, true, false]), true);
    });

    test('should return true when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), true);
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), false);
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), false);
    });

    test('should return false when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), false);
    });

    test('should return false when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), false);
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        false,
      );
    });
  });

  group('datetime base type', () {
    late final bool Function(dynamic filterValue) filter;

    setUpAll(() {
      filter = (filterValue) {
        final result = FilterBuilder([
          {'value': DateTime(2022, 1, 1)}
        ]).gteAny('value', filterValue).execute();

        if (logFilterErrors) {
          print(result.error.toString());
        }

        return result.isValid;
      };
    });

    test('should return false when filtering with int', () {
      expect(filter(22), false);
    });

    test('should return false when filtering with float', () {
      expect(filter(22.5), false);
    });

    test('should return true when filtering with valid string', () {
      expect(filter('{2022-01-01, 2022-12-31, 2023-01-01}'), true);
    });

    test('should return false when filtering with invalid string', () {
      expect(filter('invalid'), false);
    });

    test('should return false when filtering with bool', () {
      expect(filter(true), false);
    });

    test('should return false when filtering with datetime literal', () {
      expect(filter(DateTime(2022, 1, 1)), false);
    });

    test('should return false when filtering with datetime string', () {
      expect(filter('2022-01-01'), false);
    });

    test('should return false when filtering with range string', () {
      expect(filter('[10,20]'), false);
    });

    test('should return false when filtering with range literal', () {
      expect(filter(RangeType.createRange(range: '[10,20]')), false);
    });

    test('should return false when filtering with json literal', () {
      expect(filter({'value': 10}), false);
    });

    test('should return false when filtering with json string', () {
      expect(filter('{"value": 10}'), false);
    });

    test('should return false when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), false);
    });

    test('should return false when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), false);
    });

    test('should return false when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), false);
    });

    test('should return false when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), false);
    });

    test('should return false when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), false);
    });

    test('should return false when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), false);
    });

    test('should return false when filtering with bool list', () {
      expect(filter([true, false, true, false]), false);
    });

    test('should return false when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), false);
    });

    test('should return true when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        true,
      );
    });

    test('should return true when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), true);
    });

    test('should return true when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), true);
    });

    test('should return false when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), false);
    });

    test('should return false when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), false);
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        false,
      );
    });
  });

  group('range base type', () {
    late final bool Function(dynamic filterValue) filter;

    setUpAll(() {
      filter = (filterValue) {
        final result = FilterBuilder([
          {'value': RangeType.createRange(range: '[10,20]')}
        ]).gteAny('value', filterValue).execute();

        if (logFilterErrors) {
          print(result.error.toString());
        }

        return result.isValid;
      };
    });

    test('should return false when filtering with int', () {
      expect(filter(22), false);
    });

    test('should return false when filtering with float', () {
      expect(filter(22.5), false);
    });

    test('should return true when filtering with valid string', () {
      expect(filter('{[10,20], [30,40], [200,400]}'), true);
    });

    test('should return false when filtering with invalid string', () {
      expect(filter('invalid'), false);
    });

    test('should return false when filtering with bool', () {
      expect(filter(true), false);
    });

    test('should return false when filtering with datetime literal', () {
      expect(filter(DateTime(2022, 1, 1)), false);
    });

    test('should return false when filtering with datetime string', () {
      expect(filter('2022-01-01'), false);
    });

    test('should return false when filtering with range string', () {
      expect(filter('[10,20]'), false);
    });

    test('should return false when filtering with range literal', () {
      expect(filter(RangeType.createRange(range: '[10,20]')), false);
    });

    test('should return false when filtering with json literal', () {
      expect(filter({'value': 10}), false);
    });

    test('should return false when filtering with json string', () {
      expect(filter('{"value": 10}'), false);
    });

    test('should return false when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), false);
    });

    test('should return false when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), false);
    });

    test('should return false when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), false);
    });

    test('should return false when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), false);
    });

    test('should return false when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), false);
    });

    test('should return false when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), false);
    });

    test('should return false when filtering with bool list', () {
      expect(filter([true, false, true, false]), false);
    });

    test('should return false when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), false);
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), false);
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), false);
    });

    test('should return true when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), true);
    });

    test('should return true when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), true);
    });

    test('should return true when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        true,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        false,
      );
    });
  });

  group('json base type', () {
    late final bool Function(dynamic filterValue) filter;

    setUpAll(() {
      filter = (filterValue) {
        final result = FilterBuilder([
          {
            'value': {'age': 10}
          }
        ]).gteAny('value', filterValue).execute();

        if (logFilterErrors) {
          print(result.error.toString());
        }

        return result.isValid;
      };
    });

    test('should return false when filtering with int', () {
      expect(filter(22), false);
    });

    test('should return false when filtering with float', () {
      expect(filter(22.5), false);
    });

    test('should return true when filtering with valid string', () {
      expect(filter('{{"age": 10}, {"age": 20}, {"age": 30}}'), true);
    });

    test('should return false when filtering with invalid string', () {
      expect(filter('invalid'), false);
    });

    test('should return false when filtering with bool', () {
      expect(filter(true), false);
    });

    test('should return false when filtering with datetime literal', () {
      expect(filter(DateTime(2022, 1, 1)), false);
    });

    test('should return false when filtering with datetime string', () {
      expect(filter('2022-01-01'), false);
    });

    test('should return false when filtering with range string', () {
      expect(filter('[10,20]'), false);
    });

    test('should return false when filtering with range literal', () {
      expect(filter(RangeType.createRange(range: '[10,20]')), false);
    });

    test('should return false when filtering with json literal', () {
      expect(filter({'age': 10}), false);
    });

    test('should return false when filtering with json string', () {
      expect(filter('{"age": 10}'), false);
    });

    test('should return true when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), true);
    });

    test('should return true when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), true);
    });

    test('should return true when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), true);
    });

    test('should return true when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), true);
    });

    test('should return true when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), true);
    });

    test('should return true when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), true);
    });

    test('should return true when filtering with bool list', () {
      expect(filter([true, false, true, false]), true);
    });

    test('should return true when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), true);
    });

    test('should return true when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        true,
      );
    });

    test('should return true when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), true);
    });

    test('should return true when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), true);
    });

    test('should return true when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), true);
    });

    test('should return true when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), true);
    });

    test('should return true when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        true,
      );
    });

    test('should return true when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        true,
      );
    });

    test('should return true when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        true,
      );
    });

    test('should return true when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        true,
      );
    });
  });

  group('int list base type', () {
    late final bool Function(dynamic filterValue) filter;

    setUpAll(() {
      filter = (filterValue) {
        final result = FilterBuilder([
          {
            'value': [1, 2, 3, 4]
          }
        ]).gteAny('value', filterValue).execute();

        if (logFilterErrors) {
          print(result.error.toString());
        }

        return result.isValid;
      };
    });

    test('should return false when filtering with int', () {
      expect(filter(22), false);
    });

    test('should return false when filtering with float', () {
      expect(filter(22.5), false);
    });

    test('should return false when filtering with valid string', () {
      expect(filter('{1, 2, 3, 4}'), false);
    });

    test('should return false when filtering with invalid string', () {
      expect(filter('invalid'), false);
    });

    test('should return false when filtering with bool', () {
      expect(filter(true), false);
    });

    test('should return false when filtering with datetime literal', () {
      expect(filter(DateTime(2022, 1, 1)), false);
    });

    test('should return false when filtering with datetime string', () {
      expect(filter('2022-01-01'), false);
    });

    test('should return false when filtering with range string', () {
      expect(filter('[10,20]'), false);
    });

    test('should return false when filtering with range literal', () {
      expect(filter(RangeType.createRange(range: '[10,20]')), false);
    });

    test('should return false when filtering with json literal', () {
      expect(filter({'value': 10}), false);
    });

    test('should return false when filtering with json string', () {
      expect(filter('{"value": 10}'), false);
    });

    test('should return false when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), false);
    });

    test('should return false when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), false);
    });

    test('should return false when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), false);
    });

    test('should return false when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), false);
    });

    test('should return false when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), false);
    });

    test('should return false when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), false);
    });

    test('should return false when filtering with bool list', () {
      expect(filter([true, false, true, false]), false);
    });

    test('should return false when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), false);
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), false);
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), false);
    });

    test('should return false when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), false);
    });

    test('should return false when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), false);
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        false,
      );
    });
  });

  group('float list base type', () {
    late final bool Function(dynamic filterValue) filter;

    setUpAll(() {
      filter = (filterValue) {
        final result = FilterBuilder([
          {
            'value': [1.5, 2.5, 3.5, 4.5]
          }
        ]).gteAny('value', filterValue).execute();

        if (logFilterErrors) {
          print(result.error.toString());
        }
        return result.isValid;
      };
    });

    test('should return false when filtering with int', () {
      expect(filter(22), false);
    });

    test('should return false when filtering with float', () {
      expect(filter(22.5), false);
    });

    test('should return false when filtering with valid string', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), false);
    });

    test('should return false when filtering with invalid string', () {
      expect(filter('invalid'), false);
    });

    test('should return false when filtering with bool', () {
      expect(filter(true), false);
    });

    test('should return false when filtering with datetime literal', () {
      expect(filter(DateTime(2022, 1, 1)), false);
    });

    test('should return false when filtering with datetime string', () {
      expect(filter('2022-01-01'), false);
    });

    test('should return false when filtering with range string', () {
      expect(filter('[10,20]'), false);
    });

    test('should return false when filtering with range literal', () {
      expect(filter(RangeType.createRange(range: '[10,20]')), false);
    });

    test('should return false when filtering with json literal', () {
      expect(filter({'value': 10}), false);
    });

    test('should return false when filtering with json string', () {
      expect(filter('{"value": 10}'), false);
    });

    test('should return false when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), false);
    });

    test('should return false when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), false);
    });

    test('should return false when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), false);
    });

    test('should return false when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), false);
    });

    test('should return false when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), false);
    });

    test('should return false when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), false);
    });

    test('should return false when filtering with bool list', () {
      expect(filter([true, false, true, false]), false);
    });

    test('should return false when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), false);
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), false);
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), false);
    });

    test('should return false when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), false);
    });

    test('should return false when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), false);
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        false,
      );
    });
  });

  group('string list base type', () {
    late final bool Function(dynamic filterValue) filter;

    setUpAll(() {
      filter = (filterValue) {
        final result = FilterBuilder([
          {
            'value': [
              'sample',
              'string',
              'to',
              'demonstrate',
              'an',
              'array',
            ]
          }
        ]).gteAny('value', filterValue).execute();

        if (logFilterErrors) {
          print(result.error.toString());
        }
        return result.isValid;
      };
    });

    test('should return false when filtering with int', () {
      expect(filter(22), false);
    });

    test('should return false when filtering with float', () {
      expect(filter(22.5), false);
    });

    test('should return false when filtering with valid string', () {
      expect(filter('{"sample", "string"}'), false);
    });

    test('should return false when filtering with invalid string', () {
      expect(filter('invalid'), false);
    });

    test('should return false when filtering with bool', () {
      expect(filter(true), false);
    });

    test('should return false when filtering with datetime literal', () {
      expect(filter(DateTime(2022, 1, 1)), false);
    });

    test('should return false when filtering with datetime string', () {
      expect(filter('2022-01-01'), false);
    });

    test('should return false when filtering with range string', () {
      expect(filter('[10,20]'), false);
    });

    test('should return false when filtering with range literal', () {
      expect(filter(RangeType.createRange(range: '[10,20]')), false);
    });

    test('should return false when filtering with json literal', () {
      expect(filter({'value': 10}), false);
    });

    test('should return false when filtering with json string', () {
      expect(filter('{"value": 10}'), false);
    });

    test('should return false when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), false);
    });

    test('should return false when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), false);
    });

    test('should return false when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), false);
    });

    test('should return false when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), false);
    });

    test('should return false when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), false);
    });

    test('should return false when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), false);
    });

    test('should return false when filtering with bool list', () {
      expect(filter([true, false, true, false]), false);
    });

    test('should return false when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), false);
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), false);
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), false);
    });

    test('should return false when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), false);
    });

    test('should return false when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), false);
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        false,
      );
    });
  });

  group('bool list base type', () {
    late final bool Function(dynamic filterValue) filter;

    setUpAll(() {
      filter = (filterValue) {
        final result = FilterBuilder([
          {
            'value': [true, false, true]
          }
        ]).gteAny('value', filterValue).execute();

        if (logFilterErrors) {
          print(result.error.toString());
        }

        return result.isValid;
      };
    });

    test('should return false when filtering with int', () {
      expect(filter(22), false);
    });

    test('should return false when filtering with float', () {
      expect(filter(22.5), false);
    });

    test('should return false when filtering with valid string', () {
      expect(filter('{true, false}'), false);
    });

    test('should return false when filtering with invalid string', () {
      expect(filter('invalid'), false);
    });

    test('should return false when filtering with bool', () {
      expect(filter(true), false);
    });

    test('should return false when filtering with datetime literal', () {
      expect(filter(DateTime(2022, 1, 1)), false);
    });

    test('should return false when filtering with datetime string', () {
      expect(filter('2022-01-01'), false);
    });

    test('should return false when filtering with range string', () {
      expect(filter('[10,20]'), false);
    });

    test('should return false when filtering with range literal', () {
      expect(filter(RangeType.createRange(range: '[10,20]')), false);
    });

    test('should return false when filtering with json literal', () {
      expect(filter({'value': 10}), false);
    });

    test('should return false when filtering with json string', () {
      expect(filter('{"value": 10}'), false);
    });

    test('should return false when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), false);
    });

    test('should return false when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), false);
    });

    test('should return false when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), false);
    });

    test('should return false when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), false);
    });

    test('should return false when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), false);
    });

    test('should return false when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), false);
    });

    test('should return false when filtering with bool list', () {
      expect(filter([true, false, true, false]), false);
    });

    test('should return false when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), false);
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), false);
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), false);
    });

    test('should return false when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), false);
    });

    test('should return false when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), false);
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        false,
      );
    });
  });

  group('datetime list base type', () {
    late final bool Function(dynamic filterValue) filter;

    setUpAll(() {
      filter = (filterValue) {
        final result = FilterBuilder([
          {
            'value': [
              DateTime(2022, 1, 1),
              DateTime(2022, 12, 31),
              DateTime(2023, 1, 1),
            ]
          }
        ]).gteAny('value', filterValue).execute();

        if (logFilterErrors) {
          print(result.error.toString());
        }

        return result.isValid;
      };
    });

    test('should return false when filtering with int', () {
      expect(filter(22), false);
    });

    test('should return false when filtering with float', () {
      expect(filter(22.5), false);
    });

    test('should return false when filtering with valid string', () {
      expect(filter('{2022-01-01, 2022-12-31}'), false);
    });

    test('should return false when filtering with invalid string', () {
      expect(filter('invalid'), false);
    });

    test('should return false when filtering with bool', () {
      expect(filter(true), false);
    });

    test('should return false when filtering with datetime literal', () {
      expect(filter(DateTime(2022, 1, 1)), false);
    });

    test('should return false when filtering with datetime string', () {
      expect(filter('2022-01-01'), false);
    });

    test('should return false when filtering with range string', () {
      expect(filter('[10,20]'), false);
    });

    test('should return false when filtering with range literal', () {
      expect(filter(RangeType.createRange(range: '[10,20]')), false);
    });

    test('should return false when filtering with json literal', () {
      expect(filter({'value': 10}), false);
    });

    test('should return false when filtering with json string', () {
      expect(filter('{"value": 10}'), false);
    });

    test('should return false when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), false);
    });

    test('should return false when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), false);
    });

    test('should return false when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), false);
    });

    test('should return false when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), false);
    });

    test('should return false when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), false);
    });

    test('should return false when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), false);
    });

    test('should return false when filtering with bool list', () {
      expect(filter([true, false, true, false]), false);
    });

    test('should return false when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), false);
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), false);
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), false);
    });

    test('should return false when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), false);
    });

    test('should return false when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), false);
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        false,
      );
    });
  });

  group('range list base type', () {
    late final bool Function(dynamic filterValue) filter;

    setUpAll(() {
      filter = (filterValue) {
        final result = FilterBuilder([
          {
            'value': [
              RangeType.createRange(range: '[10,20]'),
              RangeType.createRange(range: '[30,40]'),
              RangeType.createRange(range: '[200,400]'),
            ]
          }
        ]).gteAny('value', filterValue).execute();

        if (logFilterErrors) {
          print(result.error.toString());
        }
        return result.isValid;
      };
    });

    test('should return false when filtering with int', () {
      expect(filter(22), false);
    });

    test('should return false when filtering with float', () {
      expect(filter(22.5), false);
    });

    test('should return false when filtering with valid string', () {
      expect(filter('{[10,20], [30,40], [200,400]}'), false);
    });

    test('should return false when filtering with invalid string', () {
      expect(filter('invalid'), false);
    });

    test('should return false when filtering with bool', () {
      expect(filter(true), false);
    });

    test('should return false when filtering with datetime literal', () {
      expect(filter(DateTime(2022, 1, 1)), false);
    });

    test('should return false when filtering with datetime string', () {
      expect(filter('2022-01-01'), false);
    });

    test('should return false when filtering with range string', () {
      expect(filter('[10,20]'), false);
    });

    test('should return false when filtering with range literal', () {
      expect(filter(RangeType.createRange(range: '[10,20]')), false);
    });

    test('should return false when filtering with json literal', () {
      expect(filter({'value': 10}), false);
    });

    test('should return false when filtering with json string', () {
      expect(filter('{"value": 10}'), false);
    });

    test('should return false when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), false);
    });

    test('should return false when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), false);
    });

    test('should return false when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), false);
    });

    test('should return false when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), false);
    });

    test('should return false when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), false);
    });

    test('should return false when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), false);
    });

    test('should return false when filtering with bool list', () {
      expect(filter([true, false, true, false]), false);
    });

    test('should return false when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), false);
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), false);
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), false);
    });

    test('should return false when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), false);
    });

    test('should return false when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), false);
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        false,
      );
    });
  });

  group('json list base type', () {
    late final bool Function(dynamic filterValue) filter;

    setUpAll(() {
      filter = (filterValue) {
        final result = FilterBuilder([
          {
            'value': [
              {'age': 10},
              {'age': 20},
              {'age': 30}
            ]
          }
        ]).gteAny('value', filterValue).execute();

        if (logFilterErrors) {
          print(result.error.toString());
        }

        return result.isValid;
      };
    });

    test('should return false when filtering with int', () {
      expect(filter(22), false);
    });

    test('should return false when filtering with float', () {
      expect(filter(22.5), false);
    });

    test('should return false when filtering with valid string', () {
      expect(filter('{{"age": 10}, {"age": 20}, {"age": 30}}'), false);
    });

    test('should return false when filtering with invalid string', () {
      expect(filter('invalid'), false);
    });

    test('should return false when filtering with bool', () {
      expect(filter(true), false);
    });

    test('should return false when filtering with datetime literal', () {
      expect(filter(DateTime(2022, 1, 1)), false);
    });

    test('should return false when filtering with datetime string', () {
      expect(filter('2022-01-01'), false);
    });

    test('should return false when filtering with range string', () {
      expect(filter('[10,20]'), false);
    });

    test('should return false when filtering with range literal', () {
      expect(filter(RangeType.createRange(range: '[10,20]')), false);
    });

    test('should return false when filtering with json literal', () {
      expect(filter({'value': 10}), false);
    });

    test('should return false when filtering with json string', () {
      expect(filter('{"value": 10}'), false);
    });

    test('should return false when filtering with int list', () {
      expect(filter([1, 2, 3, 4]), false);
    });

    test('should return false when filtering with postgres int list', () {
      expect(filter('{1, 2, 3, 4}'), false);
    });

    test('should return false when filtering with float list', () {
      expect(filter([1.5, 2.5, 3.5, 4.5]), false);
    });

    test('should return false when filtering with postgres float list', () {
      expect(filter('{1.5, 2.5, 3.5, 4.5}'), false);
    });

    test('should return false when filtering with string list', () {
      expect(filter(['1', '2', '3', '4']), false);
    });

    test('should return false when filtering with postgres string list', () {
      expect(filter('{"1", "2", "3", "4"}'), false);
    });

    test('should return false when filtering with bool list', () {
      expect(filter([true, false, true, false]), false);
    });

    test('should return false when filtering with postgres bool list', () {
      expect(filter('{true, false, true, false}'), false);
    });

    test('should return false when filtering with datetime literal list', () {
      expect(
        filter([
          DateTime(2022, 1, 1),
          DateTime(2022, 12, 31),
          DateTime(2023, 1, 1)
        ]),
        false,
      );
    });

    test('should return false when filtering with datetime string list', () {
      expect(filter(['2022-01-01', '2022-12-31', '2023-01-01']), false);
    });

    test('should return false when filtering with postgres datetime list', () {
      expect(filter('{"2022-01-01", "2022-12-31", "2023-01-01"}'), false);
    });

    test('should return false when filtering with range string list', () {
      expect(filter(['[10,20]', '[30,40]', '[200,400]']), false);
    });

    test('should return false when filtering with postgres range list', () {
      expect(filter('{"[10,20]", "[30,40]", "[200,400]"}'), false);
    });

    test('should return false when filtering with range literal list', () {
      expect(
        filter([
          RangeType.createRange(range: '[10,20]'),
          RangeType.createRange(range: '[30,40]'),
          RangeType.createRange(range: '[200,400]'),
        ]),
        false,
      );
    });

    test('should return false when filtering with json literal list', () {
      expect(
        filter([
          {'value': 10},
          {'value': 20},
          {'value': 30},
        ]),
        false,
      );
    });

    test('should return false when filtering with json string list', () {
      expect(
        filter(['{"value": 10}', '{"value": 20}', '{"value": 30}']),
        false,
      );
    });

    test('should return false when filtering with postgres json list', () {
      expect(
        filter('{{"value": 10}, {"value": 20}, {"value": 30}}'),
        false,
      );
    });
  });
}
