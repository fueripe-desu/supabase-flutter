import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/postgrest/supabase_test_postgrest.dart';
import 'package:supabase_flutter/src/testing/postgrest/postgrest_parser.dart';
import 'package:supabase_flutter/src/testing/postgrest/postgrest_tokens.dart';

void main() {
  late final bool Function(Object?, Object?) deepEq;
  late final bool Function(Map<String, dynamic>, Map<String, dynamic>) mapEq;

  setUpAll(() {
    deepEq = const DeepCollectionEquality.unordered().equals;
    mapEq = const MapEquality<String, dynamic>().equals;
  });

  group('value parsing', () {
    late final bool Function(
      String value,
      List<PostrestValueToken> compareList,
    ) parseValue;

    late final dynamic Function(String value) evalValue;

    setUpAll(() {
      parseValue = (value, compareList) {
        final tokens = PostrestValueParser().tokenize(value);
        return deepEq(tokens, compareList);
      };

      evalValue = (value) {
        final tokens = PostrestValueParser().tokenize(value);
        if (tokens.length == 1) {
          return tokens.first.evaluate();
        } else {
          final result = PostrestSyntaxParser([]).parseValue(value);
          return result;
        }
      };
    });

    test('should trim the value', () {
      expect(parseValue('    sample     ', [ValueToken('sample')]), true);
    });

    test('should be able to parse an int value', () {
      expect(parseValue('22', [ValueToken('22')]), true);
    });

    test('should ensure the value is of integer type', () {
      expect(evalValue('22'), isA<int>());
    });

    test('the value \'0\' should be num', () {
      expect(evalValue('0'), isA<num>());
    });

    test('should be able to parse a float value', () {
      expect(parseValue('22.5', [ValueToken('22.5')]), true);
    });

    test('should ensure the value is of float type', () {
      expect(evalValue('22.5'), isA<double>());
    });

    test('should be able to parse boolean true', () {
      expect(parseValue('true', [ValueToken('true')]), true);
    });

    test('should ensure the value true is of boolean type', () {
      expect(evalValue('true'), true);
    });

    test('should be able to parse boolean false', () {
      expect(parseValue('false', [ValueToken('false')]), true);
    });

    test('should ensure the value false is of boolean type', () {
      expect(evalValue('false'), false);
    });

    test('should be able to parse a null value', () {
      expect(parseValue('null', [ValueToken('null')]), true);
    });

    test('should ensure the value is of null type', () {
      expect(evalValue('null'), null);
    });

    test('should be able to parse a string', () {
      expect(
        parseValue(
          'A sample string',
          [ValueToken('A sample string')],
        ),
        true,
      );
    });

    test('should ensure the value is of string type', () {
      expect(evalValue('A sample string'), isA<String>());
    });

    test('should treat double quoted text as a string', () {
      expect(
        parseValue(
          '"A sample string"',
          [ValueToken("'A sample string'")],
        ),
        true,
      );
    });

    test('should ensure double quoted text is of string type', () {
      expect(evalValue('"A sample string"'), isA<String>());
    });

    test('should treat single quoted text as a string', () {
      expect(
        parseValue(
          "'A sample string'",
          [ValueToken("'A sample string'")],
        ),
        true,
      );
    });

    test('should ensure single quoted text is of string type', () {
      expect(evalValue("'A sample string'"), isA<String>());
    });

    test('should treat the value \'true\' as string if quoted', () {
      expect(parseValue('"true"', [ValueToken("'true'")]), true);
    });

    test('should treat the value \'false\' as string if quoted', () {
      expect(parseValue('"false"', [ValueToken("'false'")]), true);
    });

    test('should be able to parse a date', () {
      expect(parseValue('2022-01-01', [ValueToken('2022-01-01')]), true);
    });

    test('should ensure that the date is of DateTime type', () {
      expect(evalValue('2022-01-01'), isA<DateTime>());
    });

    test('should be able to escape a DateTime if quoted', () {
      expect(evalValue('"2022-01-01"'), isA<String>());
    });

    test('should be able to parse a timestamp', () {
      expect(
        parseValue('2022-01-01T12:00:00', [ValueToken('2022-01-01T12:00:00')]),
        true,
      );
    });

    test('should ensure that the timestamp is of DateTime type', () {
      expect(evalValue('2022-01-01T12:00:00'), isA<DateTime>());
    });

    test('should be able to parse a timestamptz', () {
      expect(
        parseValue(
          '2022-01-01T12:00:00+01',
          [ValueToken('2022-01-01T12:00:00+01')],
        ),
        true,
      );
    });

    test('should ensure that the timestamptz is of DateTime type', () {
      expect(evalValue('2022-01-01T12:00:00+01'), isA<DateTime>());
    });

    test('should be able to parse an UTC timestamptz', () {
      expect(
        parseValue(
          '2022-01-01T12:00:00Z',
          [ValueToken('2022-01-01T12:00:00Z')],
        ),
        true,
      );
    });

    test('should ensure that the UTZ timestamptz is of DateTime type', () {
      expect(evalValue('2022-01-01T12:00:00Z'), isA<DateTime>());
    });

    test('should be able to parse an array of int', () {
      expect(
        parseValue(
          '{1, 2, 3, 4}',
          [
            StartToken(),
            ValueToken('1'),
            SeparatorToken(),
            ValueToken('2'),
            SeparatorToken(),
            ValueToken('3'),
            SeparatorToken(),
            ValueToken('4'),
            EndToken(),
          ],
        ),
        true,
      );
    });

    test('should ensure that the array of integer is of type list', () {
      expect(evalValue('{1, 2, 3, 4}'), [1, 2, 3, 4]);
    });

    test('should be able to parse an array of double', () {
      expect(
        parseValue(
          '{1.0, 2.0, 3.0, 4.0}',
          [
            StartToken(),
            ValueToken('1.0'),
            SeparatorToken(),
            ValueToken('2.0'),
            SeparatorToken(),
            ValueToken('3.0'),
            SeparatorToken(),
            ValueToken('4.0'),
            EndToken(),
          ],
        ),
        true,
      );
    });

    test('should ensure that the array of double is of type list', () {
      expect(evalValue('{1.0, 2.0, 3.0, 4.0}'), [1.0, 2.0, 3.0, 4.0]);
    });

    test('should be able to parse an array of null', () {
      expect(
        parseValue(
          '{null, null, null, null}',
          [
            StartToken(),
            ValueToken('null'),
            SeparatorToken(),
            ValueToken('null'),
            SeparatorToken(),
            ValueToken('null'),
            SeparatorToken(),
            ValueToken('null'),
            EndToken(),
          ],
        ),
        true,
      );
    });

    test('should ensure that the array of null is of type list', () {
      expect(evalValue('{null, null, null, null}'), [null, null, null, null]);
    });

    test('should be able to parse an array of bool', () {
      expect(
        parseValue(
          '{true, false, false, true}',
          [
            StartToken(),
            ValueToken('true'),
            SeparatorToken(),
            ValueToken('false'),
            SeparatorToken(),
            ValueToken('false'),
            SeparatorToken(),
            ValueToken('true'),
            EndToken(),
          ],
        ),
        true,
      );
    });

    test('should ensure that the array is of type bool', () {
      expect(
        evalValue('{true, false, false, true}'),
        [true, false, false, true],
      );
    });

    test('should be able to parse an array of DateTime', () {
      expect(
        parseValue(
          '{2022-01-01, 2022-12-31, 2023-01-01, 2023-12-31}',
          [
            StartToken(),
            ValueToken('2022-01-01'),
            SeparatorToken(),
            ValueToken('2022-12-31'),
            SeparatorToken(),
            ValueToken('2023-01-01'),
            SeparatorToken(),
            ValueToken('2023-12-31'),
            EndToken(),
          ],
        ),
        true,
      );
    });

    test('should ensure that the array is of type DateTime', () {
      expect(
        deepEq(
          evalValue('{2022-01-01, 2022-12-31, 2023-01-01, 2023-12-31}'),
          [
            DateTime(2022, 01, 01),
            DateTime(2022, 12, 31),
            DateTime(2023, 01, 01),
            DateTime(2023, 12, 31),
          ],
        ),
        true,
      );
    });

    test('should be able to parse an array of string', () {
      expect(
        parseValue(
          '{"one", "two", "three", "four"}',
          [
            StartToken(),
            ValueToken("'one'"),
            SeparatorToken(),
            ValueToken("'two'"),
            SeparatorToken(),
            ValueToken("'three'"),
            SeparatorToken(),
            ValueToken("'four'"),
            EndToken(),
          ],
        ),
        true,
      );
    });

    test('should ensure that the string array is of type list', () {
      expect(
        evalValue('{"one", "two", "three", "four"}'),
        ['one', 'two', 'three', 'four'],
      );
    });

    test('should be able to parse a range of type int', () {
      expect(
        parseValue(
          '[10, 20]',
          [
            ValueToken('[10, 20]'),
          ],
        ),
        true,
      );
    });

    test('should be able to parse ranges of various inclusivities', () {
      expect(
        parseValue(
          '[10, 20]',
          [
            ValueToken('[10, 20]'),
          ],
        ),
        true,
      );
      expect(
        parseValue(
          '(10, 20]',
          [
            ValueToken('(10, 20]'),
          ],
        ),
        true,
      );
      expect(
        parseValue(
          '[10, 20)',
          [
            ValueToken('[10, 20)'),
          ],
        ),
        true,
      );
      expect(
        parseValue(
          '(10, 20)',
          [
            ValueToken('(10, 20)'),
          ],
        ),
        true,
      );
    });

    test('empty values should be of an empty list', () {
      expect(
        evalValue(''),
        [],
      );
    });

    test('should be able to parse a range of type float', () {
      expect(
        parseValue(
          '[10.0, 20.0]',
          [
            ValueToken('[10.0, 20.0]'),
          ],
        ),
        true,
      );
    });

    test('should be able to parse a range of type date', () {
      expect(
        parseValue(
          '[2022-01-01, 2022-12-31]',
          [
            ValueToken('[2022-01-01, 2022-12-31]'),
          ],
        ),
        true,
      );
    });

    test('should be able to parse an array of ranges', () {
      expect(
        evalValue('{[10, 20], [40, 60], [200, 400]}'),
        ['[10, 20]', '[40, 60]', '[200, 400]'],
      );
    });

    test('should be able to parse an array of JSON', () {
      expect(
        evalValue(
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
        evalValue('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}'),
        [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ],
      );
    });

    test('should be able to parse an array of arrays many levels deep', () {
      expect(
        evalValue('{{{{{{{{1, 2, 3}}}}}}}, {{{{{4, 5, 6}}}}}, {{7, 8, 9}}}'),
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
          evalValue('{"column1": 1, "column2": 2}'),
          {'column1': 1, 'column2': 2},
        ),
        true,
      );
    });

    test('should be able to parse a JSON of float', () {
      expect(
        deepEq(
          evalValue('{"column1": 1.0, "column2": 2.0}'),
          {'column1': 1.0, 'column2': 2.0},
        ),
        true,
      );
    });

    test('should be able to parse a JSON of bool', () {
      expect(
        deepEq(
          evalValue('{"column1": true, "column2": false}'),
          {'column1': true, 'column2': false},
        ),
        true,
      );
    });

    test('should be able to parse a JSON of null', () {
      expect(
        deepEq(
          evalValue('{"column1": null, "column2": null}'),
          {'column1': null, 'column2': null},
        ),
        true,
      );
    });

    test('should be able to parse a JSON of DateTime type', () {
      expect(
        deepEq(
          evalValue('{"column1": "2022-01-01", "column2": "2022-12-31"}'),
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
          evalValue('{"column1": "sample", "column2": "string"}'),
          {'column1': 'sample', 'column2': 'string'},
        ),
        true,
      );
    });

    test('should be able to parse a JSON of range type', () {
      expect(
        mapEq(
          evalValue('{"range1": "[10,20]", "range2": "(30,40)"}'),
          {
            'range1': '[10,20]',
            'range2': '(30,40)',
          },
        ),
        true,
      );
    });

    test(
        'should be able to parse a JSON of list type (should be considered as Strings)',
        () {
      expect(
        deepEq(
          evalValue('{"column1": [10, 20, 30], "column2": [40, 50, 60]}'),
          {
            'column1': '[10, 20, 30]',
            'column2': '[40, 50, 60]',
          },
        ),
        true,
      );
    });

    test('should return unclosed ranges as strings inside a JSON', () {
      expect(
        mapEq(
          evalValue('{"range1": "[10, 20", "range2": "[30, 40]"}'),
          {'range1': '[10, 20', 'range2': '[30, 40]'},
        ),
        true,
      );
      expect(
        mapEq(
          evalValue('{"range1": "10, 20]", "range2": "[30, 40]"}'),
          {'range1': '10, 20]', 'range2': '[30, 40]'},
        ),
        true,
      );
    });
  });

  group('expression parsing', () {
    late final List<PostrestExpToken> Function(String filters) expr;

    setUpAll(() {
      expr = (filters) => PostrestExpParser().tokenizeExpression(filters);
    });

    test('should be able to parse a simple expression', () {
      expect(
        expr('id.eq.2'),
        [PostrestFilterParams(column: 'id', filter: 'eq', value: '2')],
      );
    });

    test('should be able to parse an expression with more than one filter', () {
      expect(
        expr('gpa.gt.3.5, name.in.("John", "Anne", "Carl"), age.gt.21'),
        [
          PostrestFilterParams(column: 'gpa', filter: 'gt', value: '3.5'),
          PostrestFilterParams(
            column: 'name',
            filter: 'in',
            value: '("John", "Anne", "Carl")',
          ),
          PostrestFilterParams(column: 'age', filter: 'gt', value: '21'),
        ],
      );
    });

    test('should be able to parse an expression with a value of type int', () {
      expect(
        expr('id.eq.2'),
        [PostrestFilterParams(column: 'id', filter: 'eq', value: '2')],
      );
    });

    test('should be able to parse an expression with a value of type float',
        () {
      expect(
        expr('gpa.lt.3.5'),
        [PostrestFilterParams(column: 'gpa', filter: 'lt', value: '3.5')],
      );
    });

    test('should be able to parse an expression with a value of type string',
        () {
      expect(
        expr('name.eq."Carl"'),
        [PostrestFilterParams(column: 'name', filter: 'eq', value: '"Carl"')],
      );
    });

    test('should be able to parse an expression with a single quoted string',
        () {
      expect(
        expr("name.eq.'Carl'"),
        [PostrestFilterParams(column: 'name', filter: 'eq', value: "'Carl'")],
      );
    });

    test('should be able to parse an expression with a value of type bool', () {
      expect(
        expr("email_confirmed.eq.true"),
        [
          PostrestFilterParams(
            column: 'email_confirmed',
            filter: 'eq',
            value: "true",
          ),
        ],
      );
    });

    test('should be able to parse an expression with a value of type DateTime',
        () {
      expect(
        expr("created_at.eq.2022-01-01"),
        [
          PostrestFilterParams(
            column: 'created_at',
            filter: 'eq',
            value: "2022-01-01",
          ),
        ],
      );
    });

    test('should be able to parse an expression with a value of type array',
        () {
      expect(
        expr("number.cs.{1, 2, 3, 4}"),
        [
          PostrestFilterParams(
            column: 'number',
            filter: 'cs',
            value: "{1, 2, 3, 4}",
          ),
        ],
      );
    });

    test('should be able to parse an expression with a value of type list', () {
      expect(
        expr("number.in.(1, 2, 3, 4)"),
        [
          PostrestFilterParams(
            column: 'number',
            filter: 'in',
            value: "(1, 2, 3, 4)",
          ),
        ],
      );
    });

    test('should be able to parse an expression with a value of type JSON', () {
      expect(
        expr("address.cd.{'postcode': 90210}"),
        [
          PostrestFilterParams(
            column: 'address',
            filter: 'cd',
            value: "{'postcode': 90210}",
          ),
        ],
      );
    });

    test('should be able to parse a logical operator OR', () {
      expect(
        expr('or(name.eq."Anne", age.gt.18)'),
        [
          LogicalStart(precedence: PostrestFilterPrecedence.or),
          PostrestFilterParams(column: 'name', filter: 'eq', value: '"Anne"'),
          PostrestFilterParams(column: 'age', filter: 'gt', value: "18"),
          LogicalEnd(),
        ],
      );
    });

    test('should be able to parse a logical operator AND', () {
      expect(
        expr('and(name.eq."Anne", age.gt.18)'),
        [
          LogicalStart(precedence: PostrestFilterPrecedence.and),
          PostrestFilterParams(column: 'name', filter: 'eq', value: '"Anne"'),
          PostrestFilterParams(column: 'age', filter: 'gt', value: "18"),
          LogicalEnd(),
        ],
      );
    });

    test('should be able to parse nested operators', () {
      expect(
        expr(
          'and(or(name.eq."Anne", name.eq."Carl"), and(age.gt.18, age.lt.27), gpa.in.(3.0, 3.5, 4.0))',
        ),
        [
          LogicalStart(precedence: PostrestFilterPrecedence.and),
          LogicalStart(precedence: PostrestFilterPrecedence.or),
          PostrestFilterParams(column: 'name', filter: 'eq', value: '"Anne"'),
          PostrestFilterParams(column: 'name', filter: 'eq', value: '"Carl"'),
          LogicalEnd(),
          LogicalStart(precedence: PostrestFilterPrecedence.and),
          PostrestFilterParams(column: 'age', filter: 'gt', value: '18'),
          PostrestFilterParams(column: 'age', filter: 'lt', value: '27'),
          LogicalEnd(),
          PostrestFilterParams(
            column: 'gpa',
            filter: 'in',
            value: '(3.0, 3.5, 4.0)',
          ),
          LogicalEnd(),
        ],
      );
    });
  });

  group('_allowDartLists option', () {
    late final bool Function(
      String value,
      List<PostrestValueToken> compareList,
    ) parseValue;

    setUpAll(() {
      parseValue = (value, compareList) {
        final tokens = PostrestValueParser().tokenize(
          value,
          allowDartLists: true,
        );
        return deepEq(tokens, compareList);
      };
    });

    test('should be able to parse a list if it has more than two elements', () {
      expect(
        parseValue(
          '[10, 20, 30]',
          [
            StartToken(),
            ValueToken('10'),
            SeparatorToken(),
            ValueToken('20'),
            SeparatorToken(),
            ValueToken('30'),
            EndToken(),
          ],
        ),
        true,
      );
    });

    test('should be able to parse a list if it has less than two elements', () {
      expect(
        parseValue(
          '[10]',
          [
            StartToken(),
            ValueToken('10'),
            EndToken(),
          ],
        ),
        true,
      );
    });

    test('should be able to parse an empty list', () {
      expect(
        parseValue(
          '[]',
          [
            StartToken(),
            EndToken(),
          ],
        ),
        true,
      );
    });

    test('should be able to parse nested lists', () {
      expect(
        parseValue(
          '[10, 20, 30, [10, 20, 30]]',
          [
            StartToken(),
            ValueToken('10'),
            SeparatorToken(),
            ValueToken('20'),
            SeparatorToken(),
            ValueToken('30'),
            SeparatorToken(),
            StartToken(),
            ValueToken('10'),
            SeparatorToken(),
            ValueToken('20'),
            SeparatorToken(),
            ValueToken('30'),
            EndToken(),
            EndToken(),
          ],
        ),
        true,
      );
    });

    test('should be able to parse empty lists in the innermost level', () {
      expect(
        parseValue(
          '[10, 20, 30, []]',
          [
            StartToken(),
            ValueToken('10'),
            SeparatorToken(),
            ValueToken('20'),
            SeparatorToken(),
            ValueToken('30'),
            SeparatorToken(),
            StartToken(),
            EndToken(),
            EndToken(),
          ],
        ),
        true,
      );
    });

    test('should be able to parse empty lists in the outermost level', () {
      expect(
        parseValue(
          '[[10, 20, 30]]',
          [
            StartToken(),
            StartToken(),
            ValueToken('10'),
            SeparatorToken(),
            ValueToken('20'),
            SeparatorToken(),
            ValueToken('30'),
            EndToken(),
            EndToken(),
          ],
        ),
        true,
      );
    });

    test('should be able to parse mixed dart and postrest lists', () {
      expect(
        parseValue(
          '[{3, 5}, [10, 20, 30]]',
          [
            StartToken(),
            StartToken(),
            ValueToken('3'),
            SeparatorToken(),
            ValueToken('5'),
            EndToken(),
            SeparatorToken(),
            StartToken(),
            ValueToken('10'),
            SeparatorToken(),
            ValueToken('20'),
            SeparatorToken(),
            ValueToken('30'),
            EndToken(),
            EndToken(),
          ],
        ),
        true,
      );
    });

    test('should be able to parse a range', () {
      expect(
        parseValue(
          '[10, 20]',
          [
            ValueToken('[10, 20]'),
          ],
        ),
        true,
      );
    });

    test('should be able to parse a list of ranges', () {
      expect(
        parseValue(
          '[[10, 20], [30, 40], [50, 60]]',
          [
            StartToken(),
            ValueToken('[10, 20]'),
            SeparatorToken(),
            ValueToken('[30, 40]'),
            SeparatorToken(),
            ValueToken('[50, 60]'),
            EndToken(),
          ],
        ),
        true,
      );
    });

    test('should not consider as range when the second value is a list', () {
      expect(
        parseValue(
          '[10, [20]]',
          [
            StartToken(),
            ValueToken('10'),
            SeparatorToken(),
            StartToken(),
            ValueToken('20'),
            EndToken(),
            EndToken(),
          ],
        ),
        true,
      );
    });

    test('should be able to parse an unbounded range using \'null\'', () {
      expect(
        parseValue(
          '[null, null]',
          [
            ValueToken('[null, null]'),
          ],
        ),
        true,
      );
    });

    test('should be able to parse an unbounded range using \'null\' as string',
        () {
      expect(
        parseValue(
          '["null", "null"]',
          [
            ValueToken('[null, null]'),
          ],
        ),
        true,
      );
    });

    test('should be able to parse an infinite range using \'infinity\'', () {
      expect(
        parseValue(
          '[-infinity, infinity]',
          [
            ValueToken('[-infinity, infinity]'),
          ],
        ),
        true,
      );
    });

    test(
        'should be able to parse an infinite range using \'infinity\' as string',
        () {
      expect(
        parseValue(
          '["-infinity", "infinity"]',
          [
            ValueToken('[-infinity, infinity]'),
          ],
        ),
        true,
      );
    });
  });
}
