import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/postgrest/supabase_test_postgrest.dart';
import 'package:supabase_flutter/src/testing/postgrest/postgrest_parser.dart';
import 'package:supabase_flutter/src/testing/postgrest/postgrest_tokens.dart';
import 'package:supabase_flutter/src/testing/postgrest/postgrest_tree_builder.dart';

void main() {
  group('value tree builder', () {
    late final PostrestValueToken Function(String value) tree;

    setUpAll(() {
      tree = (value) {
        final tokens = PostrestValueParser().tokenize(value);
        return PostrestValueTreeBuilder().buildTree(tokens);
      };
    });

    test('should return the correct tree for int', () {
      expect(tree('22'), ValueToken('22'));
    });

    test('should return the correct tree for float', () {
      expect(tree('22.5'), ValueToken('22.5'));
    });

    test('should return the correct tree for bool', () {
      expect(tree('true'), ValueToken('true'));
    });

    test('should return the correct tree for String', () {
      expect(tree('"sample"'), ValueToken("'sample'"));
    });

    test('should return the correct tree for null', () {
      expect(tree('null'), ValueToken('null'));
    });

    test('should return the correct tree for DateTime', () {
      expect(tree('2022-01-01'), ValueToken('2022-01-01'));
    });

    test('should return the correct tree for list of int', () {
      expect(
        tree('{1, 2, 3}'),
        ListToken([
          ValueToken('1'),
          ValueToken('2'),
          ValueToken('3'),
        ]),
      );
    });

    test('should return the correct tree for list of float', () {
      expect(
        tree('{1.5, 2.5, 3.5}'),
        ListToken([
          ValueToken('1.5'),
          ValueToken('2.5'),
          ValueToken('3.5'),
        ]),
      );
    });

    test('should return the correct tree for list of bool', () {
      expect(
        tree('{true, false, true}'),
        ListToken([
          ValueToken('true'),
          ValueToken('false'),
          ValueToken('true'),
        ]),
      );
    });

    test('should return the correct tree for list of String', () {
      expect(
        tree('{"a", "sample", "string"}'),
        ListToken([
          ValueToken("'a'"),
          ValueToken("'sample'"),
          ValueToken("'string'"),
        ]),
      );
    });

    test('should return the correct tree for list of null', () {
      expect(
        tree('{null, null, null}'),
        ListToken([
          ValueToken('null'),
          ValueToken('null'),
          ValueToken('null'),
        ]),
      );
    });

    test('should return the correct tree for list of String', () {
      expect(
        tree('{2022-01-01, 2022-12-31, 2023-01-01}'),
        ListToken([
          ValueToken('2022-01-01'),
          ValueToken('2022-12-31'),
          ValueToken('2023-01-01'),
        ]),
      );
    });

    test('should return the correct tree for list of lists', () {
      expect(
        tree('{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}'),
        ListToken([
          ListToken([ValueToken('1'), ValueToken('2'), ValueToken('3')]),
          ListToken([ValueToken('4'), ValueToken('5'), ValueToken('6')]),
          ListToken([ValueToken('7'), ValueToken('8'), ValueToken('9')]),
        ]),
      );
    });

    test('should return the correct tree for list of JSON', () {
      expect(
        tree('{{"number": 1}, {"number": 2}, {"number": 3}}'),
        ListToken([
          JsonToken('{"number": 1}'),
          JsonToken('{"number": 2}'),
          JsonToken('{"number": 3}'),
        ]),
      );
    });

    test('should return the correct tree for a JSON', () {
      expect(
        tree('{"name": "John", "age": 21, "country": "USA"}'),
        JsonToken('{"name": "John", "age": 21, "country": "USA"}'),
      );
    });
  });

  group('expression tree builder', () {
    late final PostrestFilterTree Function(String filters) tree;

    setUpAll(() {
      tree = (filters) {
        final tokens = PostrestExpParser().tokenizeExpression(filters);
        return PostrestExpTreeBuilder().buildTree(tokens);
      };
    });

    test('should build a tree from a simple expression', () {
      expect(
        tree('id.eq.2'),
        PostrestFilterTree(
          operation: PostrestFilterPrecedence.and,
          childrenNodes: [
            PostrestFilterParams(column: 'id', filter: 'eq', value: '2')
          ],
        ),
      );
    });

    test('should build a tree from an expression with more than one filter',
        () {
      expect(
        tree('gpa.gt.3.5, name.in.("John", "Anne", "Carl"), age.gt.21'),
        PostrestFilterTree(
          operation: PostrestFilterPrecedence.and,
          childrenNodes: [
            PostrestFilterParams(column: 'gpa', filter: 'gt', value: '3.5'),
            PostrestFilterParams(
              column: 'name',
              filter: 'in',
              value: '("John", "Anne", "Carl")',
            ),
            PostrestFilterParams(column: 'age', filter: 'gt', value: '21'),
          ],
        ),
      );
    });

    test('should build a tree from an expression with a value of type int', () {
      expect(
        tree('id.eq.2'),
        PostrestFilterTree(
          operation: PostrestFilterPrecedence.and,
          childrenNodes: [
            PostrestFilterParams(column: 'id', filter: 'eq', value: '2'),
          ],
        ),
      );
    });

    test('should build a tree from an expression with a value of type float',
        () {
      expect(
        tree('gpa.lt.3.5'),
        PostrestFilterTree(
          operation: PostrestFilterPrecedence.and,
          childrenNodes: [
            PostrestFilterParams(column: 'gpa', filter: 'lt', value: '3.5'),
          ],
        ),
      );
    });

    test('should build a tree from an expression with a value of type string',
        () {
      expect(
        tree('name.eq."Carl"'),
        PostrestFilterTree(
          operation: PostrestFilterPrecedence.and,
          childrenNodes: [
            PostrestFilterParams(column: 'name', filter: 'eq', value: '"Carl"'),
          ],
        ),
      );
    });

    test('should be able to parse an expression with a single quoted string',
        () {
      expect(
        tree("name.eq.'Carl'"),
        PostrestFilterTree(
          operation: PostrestFilterPrecedence.and,
          childrenNodes: [
            PostrestFilterParams(column: 'name', filter: 'eq', value: "'Carl'"),
          ],
        ),
      );
    });

    test('should be able to parse an expression with a value of type bool', () {
      expect(
        tree("email_confirmed.eq.true"),
        PostrestFilterTree(
          operation: PostrestFilterPrecedence.and,
          childrenNodes: [
            PostrestFilterParams(
              column: 'email_confirmed',
              filter: 'eq',
              value: "true",
            ),
          ],
        ),
      );
    });

    test('should be able to parse an expression with a value of type DateTime',
        () {
      expect(
        tree("created_at.eq.2022-01-01"),
        PostrestFilterTree(
          operation: PostrestFilterPrecedence.and,
          childrenNodes: [
            PostrestFilterParams(
              column: 'created_at',
              filter: 'eq',
              value: "2022-01-01",
            ),
          ],
        ),
      );
    });

    test('should be able to parse an expression with a value of type array',
        () {
      expect(
        tree("number.cs.{1, 2, 3, 4}"),
        PostrestFilterTree(
          operation: PostrestFilterPrecedence.and,
          childrenNodes: [
            PostrestFilterParams(
              column: 'number',
              filter: 'cs',
              value: "{1, 2, 3, 4}",
            ),
          ],
        ),
      );
    });

    test('should be able to parse an expression with a value of type list', () {
      expect(
        tree("number.in.(1, 2, 3, 4)"),
        PostrestFilterTree(
          operation: PostrestFilterPrecedence.and,
          childrenNodes: [
            PostrestFilterParams(
              column: 'number',
              filter: 'in',
              value: "(1, 2, 3, 4)",
            ),
          ],
        ),
      );
    });

    test('should be able to parse an expression with a value of type JSON', () {
      expect(
        tree("address.cd.{'postcode': 90210}"),
        PostrestFilterTree(
          operation: PostrestFilterPrecedence.and,
          childrenNodes: [
            PostrestFilterParams(
              column: 'address',
              filter: 'cd',
              value: "{'postcode': 90210}",
            ),
          ],
        ),
      );
    });

    test('should be able to parse a logical operator OR', () {
      expect(
        tree('or(name.eq."Anne", age.gt.18)'),
        PostrestFilterTree(
          operation: PostrestFilterPrecedence.or,
          childrenNodes: [
            PostrestFilterParams(column: 'name', filter: 'eq', value: '"Anne"'),
            PostrestFilterParams(column: 'age', filter: 'gt', value: "18"),
          ],
        ),
      );
    });

    test('should be able to parse a logical operator AND', () {
      expect(
        tree('and(name.eq."Anne", age.gt.18)'),
        PostrestFilterTree(
          operation: PostrestFilterPrecedence.and,
          childrenNodes: [
            PostrestFilterParams(column: 'name', filter: 'eq', value: '"Anne"'),
            PostrestFilterParams(column: 'age', filter: 'gt', value: "18"),
          ],
        ),
      );
    });

    test('should be able to parse nested operators', () {
      expect(
        tree(
          'and(or(name.eq."Anne", name.eq."Carl"), and(age.gt.18, age.lt.27), gpa.in.(3.0, 3.5, 4.0))',
        ),
        PostrestFilterTree(
          operation: PostrestFilterPrecedence.and,
          childrenNodes: [
            PostrestFilterTree(
              operation: PostrestFilterPrecedence.and,
              childrenNodes: [
                PostrestFilterParams(
                  column: 'age',
                  filter: 'gt',
                  value: '18',
                ),
                PostrestFilterParams(
                  column: 'age',
                  filter: 'lt',
                  value: '27',
                ),
              ],
            ),
            PostrestFilterTree(
              operation: PostrestFilterPrecedence.or,
              childrenNodes: [
                PostrestFilterParams(
                  column: 'name',
                  filter: 'eq',
                  value: '"Anne"',
                ),
                PostrestFilterParams(
                  column: 'name',
                  filter: 'eq',
                  value: '"Carl"',
                ),
              ],
            ),
            PostrestFilterParams(
              column: 'gpa',
              filter: 'in',
              value: '(3.0, 3.5, 4.0)',
            ),
          ],
        ),
      );
    });
  });
}
