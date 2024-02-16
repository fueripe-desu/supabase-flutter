import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/postrest_syntax_parser.dart';
import 'package:supabase_flutter/src/testing/range_type.dart';

void main() {
  late final bool Function(Object?, Object?) deepEq;
  late final bool Function(Map<String, dynamic>, Map<String, dynamic>) mapEq;

  setUpAll(() {
    deepEq = const DeepCollectionEquality.unordered().equals;
    mapEq = const MapEquality<String, dynamic>().equals;
  });

  group('value parsing', () {
    late final dynamic Function(String value) parseValue;
    late final RangeType Function(String rangeString) range;

    setUpAll(() {
      parseValue = (value) {
        final parser = PostrestSyntaxParser([]);
        return parser.parseValue(value);
      };

      range = (rangeString) => RangeType.createRange(range: rangeString);
    });

    test('should trim the value', () {
      expect(parseValue('    sample     '), 'sample');
    });

    test('should be able to parse an int value', () {
      expect(parseValue('22'), 22);
    });

    test('should ensure the value is of integer type', () {
      expect(parseValue('22'), isA<int>());
    });

    test('the value \'0\' should be num', () {
      expect(parseValue('0'), isA<num>());
    });

    test('should be able to parse a float value', () {
      expect(parseValue('22.5'), 22.5);
    });

    test('should ensure the value is of float type', () {
      expect(parseValue('22.5'), isA<double>());
    });

    test('should be able to parse boolean true', () {
      expect(parseValue('true'), true);
    });

    test('should ensure the value true is of boolean type', () {
      expect(parseValue('true'), isA<bool>());
    });

    test('should be able to parse boolean false', () {
      expect(parseValue('false'), false);
    });

    test('should ensure the value false is of boolean type', () {
      expect(parseValue('false'), isA<bool>());
    });

    test('should be able to parse a string', () {
      expect(parseValue('A sample string'), 'A sample string');
    });

    test('should ensure the value is of string type', () {
      expect(parseValue('A sample string'), isA<String>());
    });

    test('should treat double quoted text as a string', () {
      expect(parseValue('"A sample string"'), 'A sample string');
    });

    test('should ensure double quoted text is of string type', () {
      expect(parseValue('"A sample string"'), isA<String>());
    });

    test('should treat single quoted text as a string', () {
      expect(parseValue("'A sample string'"), 'A sample string');
    });

    test('should ensure single quoted text is of string type', () {
      expect(parseValue("'A sample string'"), isA<String>());
    });

    test('should treat the value \'true\' as string if quoted', () {
      expect(parseValue('"true"'), 'true');
    });

    test('should treat the value \'false\' as string if quoted', () {
      expect(parseValue('"false"'), 'false');
    });

    test('should be able to parse a date', () {
      expect(parseValue('2022-01-01'), DateTime(2022, 01, 01));
    });

    test('should ensure that the date is of DateTime type', () {
      expect(parseValue('2022-01-01'), isA<DateTime>());
    });

    test('should be able to parse a timestamp', () {
      expect(
        parseValue('2022-01-01T12:00:00'),
        DateTime(2022, 01, 01, 12, 00, 00),
      );
    });

    test('should ensure that the timestamp is of DateTime type', () {
      expect(parseValue('2022-01-01T12:00:00'), isA<DateTime>());
    });

    test('should be able to parse a timestamptz', () {
      expect(
        parseValue('2022-01-01T12:00:00+01'),
        DateTime.utc(2022, 01, 01, 11, 00, 00),
      );
    });

    test('should ensure that the timestamptz is of DateTime type', () {
      expect(parseValue('2022-01-01T12:00:00+01'), isA<DateTime>());
    });

    test('should be able to parse an UTC timestamptz', () {
      expect(
        parseValue('2022-01-01T12:00:00Z'),
        DateTime.utc(2022, 01, 01, 12, 00, 00),
      );
    });

    test('should ensure that the UTZ timestamptz is of DateTime type', () {
      expect(parseValue('2022-01-01T12:00:00Z'), isA<DateTime>());
    });

    test('should be able to parse an array of int', () {
      expect(parseValue('{1, 2, 3, 4}'), [1, 2, 3, 4]);
    });

    test('should ensure that the array of integer is of type list', () {
      expect(parseValue('{1, 2, 3, 4}'), isA<List>());
    });

    test('should be able to parse an array of double', () {
      expect(parseValue('{1.0, 2.0, 3.0, 4.0}'), [1.0, 2.0, 3.0, 4.0]);
    });

    test('should ensure that the array of double is of type list', () {
      expect(parseValue('{1.0, 2.0, 3.0, 4.0}'), isA<List>());
    });

    test('should be able to parse an array of bool', () {
      expect(
        parseValue('{true, false, false, true}'),
        [true, false, false, true],
      );
    });

    test('should ensure that the array is of type bool', () {
      expect(parseValue('{true, false, false, true}'), isA<List>());
    });

    test('should be able to parse an array of DateTime', () {
      expect(
        parseValue('{2022-01-01, 2022-12-31, 2023-01-01, 2023-12-31}'),
        [
          DateTime(2022, 01, 01),
          DateTime(2022, 12, 31),
          DateTime(2023, 01, 01),
          DateTime(2023, 12, 31),
        ],
      );
    });

    test('should ensure that the array is of type DateTime', () {
      expect(
        parseValue('{2022-01-01, 2022-12-31, 2023-01-01, 2023-12-31}'),
        isA<List>(),
      );
    });

    test('should be able to parse an array of string', () {
      expect(
        parseValue('{"one", "two", "three", "four"}'),
        ['one', 'two', 'three', 'four'],
      );
    });

    test('should ensure that the string array is of type list', () {
      expect(
        parseValue('{"one", "two", "three", "four"}'),
        isA<List>(),
      );
    });

    test('should be able to parse a range of type int', () {
      expect(
        parseValue('[10, 20]'),
        range('[10, 20]'),
      );
    });

    test('should be able to parse ranges of various inclusivities', () {
      expect(
        parseValue('[10, 20]'),
        range('[10, 20]'),
      );
      expect(
        parseValue('(10, 20]'),
        range('(10, 20]'),
      );
      expect(
        parseValue('[10, 20)'),
        range('[10, 20)'),
      );
      expect(
        parseValue('(10, 20)'),
        range('(10, 20)'),
      );
    });

    test('empty values should be of an empty list', () {
      expect(
        parseValue(''),
        [],
      );
    });

    test('completely unbounded ranges should be of type IntegerRangeType', () {
      expect(
        parseValue('[,]'),
        isA<IntegerRangeType>(),
      );
    });

    test('infinite ranges should be of type IntegerRangeType', () {
      expect(
        parseValue('[-infinity,infinity]'),
        isA<IntegerRangeType>(),
      );
    });

    test('should ensure that an int range is of IntegerRangeType ', () {
      expect(
        parseValue('[10, 20]'),
        isA<IntegerRangeType>(),
      );
    });

    test('should be able to parse a range of type float', () {
      expect(
        parseValue('[10.0, 20.0]'),
        range('[10.0, 20.0]'),
      );
    });

    test('should ensure that an int range is of FloatRangeType ', () {
      expect(
        parseValue('[10.0, 20.0]'),
        isA<FloatRangeType>(),
      );
    });

    test('should be able to parse a range of type date', () {
      expect(
        parseValue('[2022-01-01, 2022-12-31]'),
        range('[2022-01-01, 2022-12-31]'),
      );
    });

    test('should ensure that an int range is of DateRangeType ', () {
      expect(
        parseValue('[2022-01-01, 2022-12-31]'),
        isA<DateRangeType>(),
      );
    });

    test('should be able to parse an array of ranges', () {
      expect(
        parseValue('{[10, 20], [40, 60], [200, 400]}'),
        [range('[10, 20]'), range('[40, 60]'), range('[200, 400]')],
      );
    });

    test('should be able to parse an array of JSON', () {
      expect(
        parseValue(
            '{{"number": "one"}, {"number": "two"}, {"number": "three"}, {"number": "four"}}'),
        [
          {'number': 'one'},
          {'number': 'two'},
          {'number': 'three'},
          {'number': 'four'}
        ],
      );
    });

    test('should be able to parse an array of arrays', () {
      expect(
        parseValue('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}'),
        [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
      );
    });

    test('should be able to parse an array of arrays many levels deep', () {
      expect(
        parseValue('{{{{{{{{1, 2, 3}}}}}}}, {{{{{4, 5, 6}}}}}, {{7, 8, 9}}}'),
        [
          [
            [
              [
                [
                  [
                    [
                      [1, 2, 3]
                    ]
                  ]
                ]
              ]
            ]
          ],
          [
            [
              [
                [
                  [4, 5, 6]
                ]
              ]
            ]
          ],
          [
            [7, 8, 9]
          ]
        ],
      );
    });

    test('should be able to parse a JSON of int', () {
      expect(
        deepEq(
          parseValue('{"column1": 1, "column2": 2}'),
          {'column1': 1, 'column2': 2},
        ),
        true,
      );
    });

    test('should be able to parse a JSON of float', () {
      expect(
        deepEq(
          parseValue('{"column1": 1.0, "column2": 2.0}'),
          {'column1': 1.0, 'column2': 2.0},
        ),
        true,
      );
    });

    test('should be able to parse a JSON of bool', () {
      expect(
        deepEq(
          parseValue('{"column1": true, "column2": false}'),
          {'column1': true, 'column2': false},
        ),
        true,
      );
    });

    test('should be able to parse a JSON of DateTime type', () {
      expect(
        deepEq(
          parseValue('{"column1": "2022-01-01", "column2": "2022-12-31"}'),
          {
            'column1': DateTime(2022, 01, 01),
            'column2': DateTime(2022, 12, 31),
          },
        ),
        true,
      );
    });

    test('should be able to parse a JSON of string type', () {
      expect(
        deepEq(
          parseValue('{"column1": "sample", "column2": "string"}'),
          {'column1': 'sample', 'column2': 'string'},
        ),
        true,
      );
    });

    test('should be able to parse a JSON of range type', () {
      expect(
        mapEq(
          parseValue('{"range1": "[10, 20]", "range2": "(30, 40)"}'),
          {
            'range1': range('[10, 20]'),
            'range2': range('(30, 40)'),
          },
        ),
        true,
      );
    });

    test('should be able to parse a JSON of list type', () {
      expect(
        deepEq(
          parseValue('{"column1": [10, 20, 30], "column2": [40, 50, 60]}'),
          {
            'column1': [10, 20, 30],
            'column2': [40, 50, 60],
          },
        ),
        true,
      );
    });

    test('should return unclosed ranges as strings inside a JSON', () {
      expect(
        mapEq(
          parseValue('{"range1": "[10, 20", "range2": "[30, 40]"}'),
          {'range1': '[10, 20', 'range2': range('[30, 40]')},
        ),
        true,
      );
      expect(
        mapEq(
          parseValue('{"range1": "10, 20]", "range2": "[30, 40]"}'),
          {'range1': '10, 20]', 'range2': range('[30, 40]')},
        ),
        true,
      );
    });
  });

  group('token validation', () {
    late final dynamic Function(String value) parseValue;

    setUpAll(() {
      parseValue = (value) {
        final parser = PostrestSyntaxParser([]);
        return parser.parseValue(value);
      };
    });

    test(
        'should throw an Exception when the first character is a closing list operator',
        () {
      expect(() => parseValue('}1, 2, 3, 4}'), throwsException);
    });

    test('should throw an Exception when the first character is a comma', () {
      expect(() => parseValue(',{1, 2, 3, 4}'), throwsException);
    });

    test(
        'should throw an Exception when the first character is an assignment opeartor',
        () {
      expect(() => parseValue(':{1, 2, 3, 4}'), throwsException);
    });

    test(
        'should throw an Exception when the first character is a upper bound inclusivity operator',
        () {
      expect(() => parseValue(']1, 2, 3, 4}'), throwsException);
      expect(() => parseValue(')1, 2, 3, 4}'), throwsException);
    });

    test(
        'should throw an Exception when the last character is a opening list operator',
        () {
      expect(() => parseValue('{1, 2, 3, 4{'), throwsException);
    });

    test(
        'should throw an Exception when the last character is a lower bound inclusivity operator',
        () {
      expect(() => parseValue('{1, 2, 3, 4['), throwsException);
      expect(() => parseValue('{1, 2, 3, 4('), throwsException);
    });

    test('should throw an Exception when the last character is a comma', () {
      expect(() => parseValue('{1, 2, 3, 4},'), throwsException);
    });

    test(
        'should throw an Exception when the last character is an assignment opeartor',
        () {
      expect(() => parseValue('{1, 2, 3, 4}:'), throwsException);
    });

    test('should throw an Exception when there are consecutive commas', () {
      expect(() => parseValue('{1, 2,, 3, 4},'), throwsException);
    });

    test(
        'should throw an Exception when the first curly bracket of an array is missing',
        () {
      expect(() => parseValue('1, 2, 3, 4}'), throwsException);
    });

    test('should throw an Exception when there is an unclosed range', () {
      expect(() => parseValue('[10, 20'), throwsException);
      expect(() => parseValue('10, 20]'), throwsException);
    });

    test(
        'should throw an Exception when there is an unclosed range inside a list',
        () {
      expect(() => parseValue('{[10, 20, [30, 40]}'), throwsException);
      expect(() => parseValue('{10, 20], [30, 40]}'), throwsException);
    });

    test(
        'should throw an Exception when the last curly bracket of an array is missing',
        () {
      expect(() => parseValue('{1, 2, 3, 4'), throwsException);
    });

    test(
        'should throw an Exception when there is a trailing comma in the beginning of an array',
        () {
      expect(() => parseValue('{,1, 2, 3, 4}'), throwsException);
    });

    test(
        'should throw an Exception when there is a trailing comma in the end of an array',
        () {
      expect(() => parseValue('{1, 2, 3, 4,}'), throwsException);
    });

    test('should throw an Exception when there is a type mismatch in an array',
        () {
      expect(() => parseValue('{1, 2, three, 4}'), throwsException);
    });
  });

  group('filter execution', () {
    late final List<Map<String, dynamic>> Function(
      String column,
      String filter,
      dynamic value,
    ) exec;

    setUpAll(() {
      exec = (column, filter, value) => PostrestSyntaxParser([])
          .executeFilter(column: column, filterName: filter, value: value)
          .execute();
    });

    test('should be able to execute a filter', () {
      expect(exec('name', 'eq', 'Anne'), []);
    });

    test('should convert list to array when calling the in filter', () {
      expect(exec('name', 'in', '("John", "Paul", "George")'), []);
    });
  });
}
