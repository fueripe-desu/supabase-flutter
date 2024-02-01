import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search_parser.dart';

void main() {
  late final TextSearchParser parser;
  late final bool Function(Object?, Object?) deepEq;
  late final bool Function(String expression, List<String> expected) compare;
  late final TextSearchDictionary Function(String dictName) loadDict;

  setUpAll(() {
    parser = TextSearchParser();
    deepEq = const DeepCollectionEquality.unordered().equals;
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
    compare = (expression, expected) {
      final result = parser.parseExpression(expression, loadDict('english'));

      return deepEq(result, expected);
    };
  });

  test('should treat words that are not enclosed in single quotes as separate',
      () {
    expect(compare('black cat', ['black', 'cat']), true);
  });

  test(
      'should treat words that are enclosed in single quotes as a single expression',
      () {
    expect(compare("'black cat'", ['black cat']), true);
  });

  test('should remove single quotes around expressions', () {
    expect(compare("'black cat'", ['black cat']), true);
  });

  test('should remove stop words', () {
    expect(compare("'the'", []), true);
  });

  test('should remove a stop word and its binary operator', () {
    expect(compare("'the' & 'cat'", ['cat']), true);
  });

  test('should remove a stop word and its not operator', () {
    expect(compare("!'the'", []), true);
  });

  test('should separate parenthesis when they are blended with the operand',
      () {
    expect(
      compare(
        "(('sample' & 'string') | 'text)'",
        ['(', '(', 'sample', '&', 'string', ')', '|', 'text', ')'],
      ),
      true,
    );
  });

  test(
      'should separate the not operator of the second operand from the binary operator',
      () {
    expect(compare("'cat' & !'dog'", ['cat', '&', '!', 'dog']), true);
    expect(compare("'cat' | !'dog'", ['cat', '|', '!', 'dog']), true);
    expect(compare("'cat' <-> !'dog'", ['cat', '<->', '!', 'dog']), true);
    expect(compare("'cat' <2> !'dog'", ['cat', '<2>', '!', 'dog']), true);
  });

  test('should remove unnecessary parenthesis', () {
    expect(
      compare(
        "('sample' <-> ('string'))",
        ['(', 'sample', '<->', 'string', ')'],
      ),
      true,
    );
  });
}
