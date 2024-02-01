import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search_parser.dart';
import 'package:supabase_flutter/src/testing/text_search/token_validator.dart';

void main() {
  late final bool Function(String expression) validate;
  late final TextSearchDictionary Function(String dictName) loadDict;

  setUpAll(() {
    loadDict = (dictName) {
      final file = File(
        'lib/src/testing/text_search_data/$dictName.json',
      );
      if (!file.existsSync()) {
        throw Exception('Config file \'$dictName\' does not exist.');
      }

      final jsonString = file.readAsStringSync();
      return TextSearchDictionary.fromJson(jsonString);
    };

    validate = (expression) {
      final parser = TextSearchParser();
      final validator = TokenValidator();

      final tokens = parser.parseExpression(expression, loadDict('english'));
      final validation = validator.validateTokens(tokens);

      print(validation.message);
      return validation.isValid;
    };
  });

  test('should return false if the query is empty', () {
    expect(validate(''), false);
  });

  test('should return true if the query is not empty', () {
    expect(validate("'cat'"), true);
  });

  test('should return false if the first token is a binary operator', () {
    expect(validate("& 'cat'"), false);
  });

  test('should return true if the first token is not a binary operator', () {
    expect(validate("!'dog' & 'cat'"), true);
  });

  test('should return false if the last token is a binary operator', () {
    expect(validate("'cat' &"), false);
  });

  test('should return true if the last token is not a binary operator', () {
    expect(validate("!'dog' & 'cat'"), true);
  });

  test('should return false if the first token is a closing parenthesis', () {
    expect(validate(")'cat'"), false);
  });

  test('should return false if the last token is an opening parenthesis', () {
    expect(validate("'cat'("), false);
  });

  test('should return false if the last token is a NOT operator', () {
    expect(validate("'cat'!"), false);
  });

  test('should return false if a NOT operator is preceding a binary operator',
      () {
    expect(validate("'cat' !& 'dog'"), false);
  });

  test('should return false if a NOT operator is used as a binary operator',
      () {
    expect(validate("'cat' !! 'dog'"), false);
  });

  test('should return true if a NOT operator precedes an operand', () {
    expect(validate("!'dog' & 'cat'"), true);
  });

  test('should return true if a NOT operator precedes a subexpression', () {
    expect(validate("'dog' & !('cat' | 'lion')"), true);
  });

  test('should return false if binary operator has an empty first operand', () {
    expect(validate("'dog' & (| 'lion')"), false);
  });

  test('should return false if binary operator has an empty second operand',
      () {
    expect(validate("'dog' & ('cat' |)"), false);
  });

  test('should return true if an operator contains both operands', () {
    expect(validate("'dog' & ('cat' | 'lion')"), true);
  });

  test(
      'should return false if there are consecutive AND operators of the same operation',
      () {
    expect(validate("'dog' && 'cat'"), false);
  });

  test(
      'should return false if there are consecutive OR operators of the same operation',
      () {
    expect(validate("'dog' || 'cat'"), false);
  });

  test(
      'should return false if there are consecutive PHRASE operators of the same operation',
      () {
    expect(validate("'dog' <-><-> 'cat'"), false);
  });

  test(
      'should return false if there are consecutive PROXIMITY operators of the same operation',
      () {
    expect(validate("'dog' <2><2> 'cat'"), false);
  });

  test(
      'should return fals if there are consecutive binary operators of different operations',
      () {
    expect(validate("'dog' &| 'cat'"), false);
    expect(validate("'dog' <2><3> 'cat'"), false);
    expect(validate("'dog' <3><-> 'cat'"), false);
    expect(validate("'dog' <-><2> 'cat'"), false);
  });

  test('should return false if the AND operator is used correctly', () {
    expect(validate("'dog' & 'cat'"), true);
  });

  test('should return false if the OR operator is used correctly', () {
    expect(validate("'dog' | 'cat'"), true);
  });

  test('should return false if the PHRASE operator is used correctly', () {
    expect(validate("'dog' <-> 'cat'"), true);
  });

  test('should return false if the PROXIMITY operator is used correctly', () {
    expect(validate("'dog' <2> 'cat'"), true);
  });

  test('should return false if there are consecutive operands', () {
    expect(validate("'dog' 'cat'"), false);
    expect(validate("dog cat"), false);
  });

  test('should return false if proximity does not have the last angle bracket',
      () {
    expect(validate("'dog' <2 'cat'"), false);
  });

  test('should return false if proximity does not have the first angle bracket',
      () {
    expect(validate("'dog' 2> 'cat'"), false);
  });

  test('should return false if proximity does not have a distance', () {
    expect(validate("'dog' <> 'cat'"), false);
  });

  test('should return false if proximity does not have an invalid distance',
      () {
    expect(validate("'dog' <inv> 'cat'"), false);
  });

  test('should return false if query has unbalanced closing parentheses', () {
    expect(validate("'dog' & ('cat' | 'lion'))"), false);
  });

  test('should return false if query has unbalanced opening parentheses', () {
    expect(validate("'dog' & (('cat' | 'lion')"), false);
  });
}
