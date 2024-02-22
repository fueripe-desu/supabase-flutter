import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/postgrest/supabase_test_postgrest.dart';
import 'package:supabase_flutter/src/testing/postgrest/postgrest_parser.dart';
import 'package:supabase_flutter/src/testing/postgrest/postgrest_token_validator.dart';
import 'package:supabase_flutter/src/testing/postgrest/postgrest_tokens.dart';

void main() {
  group('value token validation', () {
    late final bool Function(String value) parseValue;

    setUpAll(() {
      parseValue = (value) {
        final tokens = PostrestValueParser().tokenize(value);
        final result = PostrestValueTokenValidator().validate(tokens);

        return result.isValid;
      };
    });

    test(
        'should return false if the first character is a closing list operator',
        () {
      expect(parseValue('}1, 2, 3, 4}'), false);
    });

    test('should return false if the first character is a comma', () {
      expect(parseValue(',{1, 2, 3, 4}'), false);
    });

    test('should return false if the first character is an assignment opeartor',
        () {
      expect(parseValue(':{1, 2, 3, 4}'), false);
    });

    test(
        'should return false if the first character is a upper bound inclusivity operator',
        () {
      expect(parseValue(']1, 2, 3, 4}'), false);
      expect(parseValue(')1, 2, 3, 4}'), false);
    });

    test('should return false if the last character is a opening list operator',
        () {
      expect(parseValue('{1, 2, 3, 4{'), false);
    });

    test(
        'should return false if the last character is a lower bound inclusivity operator',
        () {
      expect(parseValue('{1, 2, 3, 4['), false);
      expect(parseValue('{1, 2, 3, 4('), false);
    });

    test('should return false if the last character is a comma', () {
      expect(parseValue('{1, 2, 3, 4},'), false);
    });

    test('should return false if the last character is an assignment opeartor',
        () {
      expect(parseValue('{1, 2, 3, 4}:'), false);
    });

    test('should return false if there are consecutive commas', () {
      expect(parseValue('{1, 2,, 3, 4},'), false);
    });

    test(
        'should return false if the first curly bracket of an array is missing',
        () {
      expect(parseValue('1, 2, 3, 4}'), false);
    });

    test('should return false if the last curly bracket of an array is missing',
        () {
      expect(parseValue('{1, 2, 3, 4'), false);
    });

    test(
        'should return false if there is a trailing comma in the beginning of an array',
        () {
      expect(parseValue('{,1, 2, 3, 4}'), false);
    });

    test(
        'should return false if there is a trailing comma in the end of an array',
        () {
      expect(parseValue('{1, 2, 3, 4,}'), false);
    });
  });

  group('expression token validation', () {
    late final bool Function(List<PostrestExpToken> tokens) validate;
    late final PostrestFilterParams Function(
      String? column,
      String? filter,
      String? value,
    ) filter;

    setUpAll(() {
      validate = (tokens) {
        final result = PostrestExpTokenValidator().validate(tokens);
        return result.isValid;
      };

      filter = (column, filter, value) =>
          PostrestFilterParams(column: column, filter: filter, value: value);
    });

    test('should return false if tokens start with logical end', () {
      expect(
        validate([LogicalEnd(), filter('column', 'eq', '"sample"')]),
        false,
      );
    });

    test('should return false if tokens end with logical start', () {
      expect(
        validate(
          [
            filter('column', 'eq', '"sample"'),
            LogicalStart(precedence: PostrestFilterPrecedence.and)
          ],
        ),
        false,
      );
    });

    test('should return false if logical scopes are unbalanced', () {
      expect(
        validate(
          [
            LogicalStart(precedence: PostrestFilterPrecedence.and),
            filter('animal', 'eq', '"cat"'),
            LogicalStart(precedence: PostrestFilterPrecedence.or),
            filter('name', 'eq', '"Luna"'),
            filter('animal', 'eq', '"Oliver"'),
            LogicalEnd()
          ],
        ),
        false,
      );
    });

    test('should return false if column is null', () {
      expect(
        validate([filter(null, 'eq', '"sample"')]),
        false,
      );
    });

    test('should return false if filter is null', () {
      expect(
        validate([filter('name', null, '"sample"')]),
        false,
      );
    });

    test('should return false if value is null', () {
      expect(
        validate([filter('name', 'eq', null)]),
        false,
      );
    });

    test('should return false if column is of String data type', () {
      expect(
        validate([filter('"string"', 'eq', '"sample"')]),
        false,
      );
    });

    test('should return false if column is of String data type (single quotes)',
        () {
      expect(
        validate([filter('\'string\'', 'eq', '"sample"')]),
        false,
      );
    });

    test('should return false if column is of int data type', () {
      expect(
        validate([filter('22', 'eq', '"sample"')]),
        false,
      );
    });

    test('should return false if column is of float data type', () {
      expect(
        validate([filter('1.5', 'eq', '"sample"')]),
        false,
      );
    });

    test('should return true if column starts with underscore', () {
      expect(
        validate([filter('_column', 'eq', '"sample"')]),
        true,
      );
    });

    test(
        'should return false if column starts with a char different from alphabetic letters and underscore',
        () {
      expect(
        validate([filter('9column', 'eq', '"sample"')]),
        false,
      );
    });

    test(
        'should return false if column contains any character that is not alphanumeric nor underscore',
        () {
      expect(
        validate([filter('colu-mn', 'eq', '"sample"')]),
        false,
      );
    });

    test(
        'should return true if column contains any number after the first char',
        () {
      expect(
        validate([filter('colu9mn', 'eq', '"sample"')]),
        true,
      );
    });

    test(
        'should return false if filter contains any character that is not alphabetic',
        () {
      expect(
        validate([filter('colu9mn', '_eq', '"sample"')]),
        false,
      );

      expect(
        validate([filter('colu9mn', 'e-q', '"sample"')]),
        false,
      );

      expect(
        validate([filter('colu9mn', 'e9q', '"sample"')]),
        false,
      );
    });
  });

  group('value token runtime validation', () {
    late final PostrestFilterTree Function(String value) parseValue;

    setUpAll(() {
      parseValue = (value) => PostrestSyntaxParser([]).parseValue(value);
    });

    test('should throw an Exception if there is a type mismatch in an array',
        () {
      expect(() => parseValue('{1, 2, three, 4}'), throwsException);
    });
  });
}
