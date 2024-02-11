import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search_parser.dart';

void main() {
  late final TextSearchParser parser;
  late final QueryOptimizer optimizer;
  late final bool Function(Object?, Object?) deepEq;

  late final TextSearchDictionary Function(String dictName) loadDict;

  setUpAll(() {
    parser = TextSearchParser();
    optimizer = QueryOptimizer();
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
  });

  group('parsing tests', () {
    late final bool Function(String expression, List<String> expected) compare;

    setUpAll(() {
      compare = (expression, expected) {
        final result = parser.parseExpression(expression);

        print(result);
        return deepEq(result, expected);
      };
    });

    test('should trim spaces in the beginning of the query', () {
      expect(compare('     black cat', ['black', 'cat']), true);
    });

    test('should trim spaces in the end of the query', () {
      expect(compare('black cat      ', ['black', 'cat']), true);
    });

    test('should be able to handle spaces between words', () {
      expect(compare('black            cat', ['black', 'cat']), true);
    });

    test(
        'should be able to handle spaces between words enclosed in single quotes',
        () {
      expect(compare("'black           cat'", ['black', '<->', 'cat']), true);
    });

    test('should be able to handle single-word queries', () {
      expect(compare('black', ['black']), true);
    });

    test('should be able to handle a single word enclosed in quotes', () {
      expect(compare("'black'", ['black']), true);
    });

    test(
        'should treat words that are not enclosed in single quotes as separate',
        () {
      expect(compare('black cat', ['black', 'cat']), true);
    });

    test(
        'should treat words that are enclosed in single quotes as a phrase expression',
        () {
      expect(compare("'black cat'", ['black', '<->', 'cat']), true);
    });

    test('should be able to handle unknown operators', () {
      expect(
        compare(r"'cat' $%@ 'dog'", ['cat', '\$', '%', '@', 'dog']),
        true,
      );
    });

    test('should be able to handle random consecutive angle brackets', () {
      expect(compare("'cat' << 'dog'", ['cat', '<', '<', 'dog']), true);
      expect(compare("'cat' >> 'dog'", ['cat', '>', '>', 'dog']), true);
    });

    test('should be able to handle text between consecutive angle brackets',
        () {
      expect(
        compare(
          "'cat' <'lion'<<< 'dog'",
          ['cat', '<', 'lion', '<', '<', '<', 'dog'],
        ),
        true,
      );
    });

    test('should ignore operators when inside quotes', () {
      expect(compare("'&black |cat<->'", ['black', '<->', 'cat']), true);
    });

    test('should ignore the AND opeartor when inside quotes', () {
      expect(compare("'cat' '&' 'dog'", ['cat', 'dog']), true);
    });

    test('should ignore the OR opeartor when inside quotes', () {
      expect(compare("'cat' '|' 'dog'", ['cat', 'dog']), true);
    });

    test('should ignore the NOT opeartor when inside quotes', () {
      expect(compare("'cat' '!' 'dog'", ['cat', 'dog']), true);
    });

    test('should ignore the PRASE opeartor when inside quotes', () {
      expect(compare("'cat' '<->' 'dog'", ['cat', 'dog']), true);
    });

    test('should ignore the PROXIMITY opeartor when inside quotes', () {
      expect(compare("'cat' '<2>' 'dog'", ['cat', 'dog']), true);
    });

    test(
        'should treat quoted operands separated by an AND operator as separated',
        () {
      expect(compare("'black&cat'", ['black', '<->', 'cat']), true);
    });

    test('should treat hyphens enclosed in single quotes as spaces', () {
      expect(compare("'black-cat'", ['black', '<->', 'cat']), true);
    });

    test('should treat hyphens as spaces', () {
      expect(compare("black-cat", ['black', 'cat']), true);
    });

    test('should be able to handle the AND operator', () {
      expect(compare("cat & dog", ['cat', '&', 'dog']), true);
    });

    test(
        'should be able to handle an AND operator in the beginning of the query',
        () {
      expect(compare("&cat & dog", ['&', 'cat', '&', 'dog']), true);
    });

    test('should be able to handle an AND operator in the end of the query',
        () {
      expect(compare("cat & dog&", ['cat', '&', 'dog', '&']), true);
    });

    test('should be able to handle an AND operator without the first operand',
        () {
      expect(compare("& dog", ['&', 'dog']), true);
    });

    test('should be able to handle an AND operator without the second operand',
        () {
      expect(compare("cat &", ['cat', '&']), true);
    });

    test('should be able to handle the AND operator without spaces', () {
      expect(compare("cat&dog", ['cat', '&', 'dog']), true);
    });

    test('should be able to handle the AND operator with quoted operands', () {
      expect(
        compare(
          "'black cat'&'dog'",
          ['black', '<->', 'cat', '&', 'dog'],
        ),
        true,
      );
    });

    test('should be able to handle the OR operator', () {
      expect(compare("cat | dog", ['cat', '|', 'dog']), true);
    });

    test(
        'should be able to handle an OR operator in the beginning of the query',
        () {
      expect(compare("|cat | dog", ['|', 'cat', '|', 'dog']), true);
    });

    test('should be able to handle an OR operator in the end of the query', () {
      expect(compare("cat | dog|", ['cat', '|', 'dog', '|']), true);
    });

    test('should be able to handle an OR operator without the first operand',
        () {
      expect(compare("| dog", ['|', 'dog']), true);
    });

    test('should be able to handle an OR operator without the second operand',
        () {
      expect(compare("cat |", ['cat', '|']), true);
    });

    test('should be able to handle the OR operator without spaces', () {
      expect(compare("cat|dog", ['cat', '|', 'dog']), true);
    });

    test('should be able to handle the OR operator with quoted operands', () {
      expect(
        compare(
          "'black cat'|'dog'",
          ['black', '<->', 'cat', '|', 'dog'],
        ),
        true,
      );
    });

    test('should be able to handle the PHRASE operator', () {
      expect(compare("cat <-> dog", ['cat', '<->', 'dog']), true);
    });

    test('should be able to handle the apostrophes', () {
      expect(compare("'mister''s' & 'cat'", ['mister\'s', '&', 'cat']), true);
    });

    test(
        'should treat as quotes as apostrophe if two consecutive quoted operands are not spaced out',
        () {
      expect(compare("'dog''cat'", ['dog\'cat']), true);
    });

    test('should treat as separate terms if two quoted operands are spaced out',
        () {
      expect(compare("'dog' 'cat'", ['dog', 'cat']), true);
    });

    test(
        'should be able to handle an PHRASE operator in the beginning of the query',
        () {
      expect(compare("<->cat <-> dog", ['<->', 'cat', '<->', 'dog']), true);
    });

    test('should be able to handle an PHRASE operator in the end of the query',
        () {
      expect(compare("cat <-> dog<->", ['cat', '<->', 'dog', '<->']), true);
    });

    test(
        'should be able to handle an PHRASE operator without the first operand',
        () {
      expect(compare("<-> dog", ['<->', 'dog']), true);
    });

    test(
        'should be able to handle an PHRASE operator without the second operand',
        () {
      expect(compare("cat <->", ['cat', '<->']), true);
    });

    test('should be able to handle the PHRASE operator without spaces', () {
      expect(compare("cat<->dog", ['cat', '<->', 'dog']), true);
    });

    test('should be able to handle the PROXIMITY operator', () {
      expect(compare("cat <2> dog", ['cat', '<2>', 'dog']), true);
    });

    test(
        'should be able to handle an PROXIMITY operator in the beginning of the query',
        () {
      expect(compare("<2>cat <2> dog", ['<2>', 'cat', '<2>', 'dog']), true);
    });

    test(
        'should be able to handle an PROXIMITY operator in the end of the query',
        () {
      expect(compare("cat <2> dog<2>", ['cat', '<2>', 'dog', '<2>']), true);
    });

    test(
        'should be able to handle an PROXIMITY operator without the first operand',
        () {
      expect(compare("<2> dog", ['<2>', 'dog']), true);
    });

    test(
        'should be able to handle an PROXIMITY operator without the second operand',
        () {
      expect(compare("cat <2>", ['cat', '<2>']), true);
    });

    test('should be able to handle the PROXIMITY operator without spaces', () {
      expect(compare("cat<2>dog", ['cat', '<2>', 'dog']), true);
    });

    test('should be able to handle the PROXIMITY operator with large numbers',
        () {
      expect(compare("cat <20000000> dog", ['cat', '<20000000>', 'dog']), true);
    });

    test(
        'should be able to handle the PROXIMITY operator with invalid distance',
        () {
      expect(compare("cat <invalid> dog", ['cat', '<invalid>', 'dog']), true);
    });

    test(
        'should be able to handle the PROXIMITY operator with an AND operator as distance',
        () {
      expect(compare("cat <&> dog", ['cat', '<&>', 'dog']), true);
    });

    test(
        'should be able to handle the PROXIMITY operator with an OR operator as distance',
        () {
      expect(compare("cat <|> dog", ['cat', '<|>', 'dog']), true);
    });

    test(
        'should be able to handle the PROXIMITY operator with an NOT operator as distance',
        () {
      expect(compare("cat <!> dog", ['cat', '<!>', 'dog']), true);
    });

    test(
        'should be able to handle the PROXIMITY operator with an PHRASE operator as distance',
        () {
      expect(
        compare("cat <<<<->>>> dog",
            ['cat', '<', '<', '<', '<->', '>', '>', '>', 'dog']),
        true,
      );
    });

    test(
        'should be able to handle the PROXIMITY operator with another PROXIMITY operator as distance',
        () {
      expect(
        compare("cat <<<<2>>>> dog",
            ['cat', '<', '<', '<', '<2>', '>', '>', '>', 'dog']),
        true,
      );
    });

    test(
        'should be able to handle the PROXIMITY operator with a quoted invalid distance',
        () {
      expect(
        compare("cat <'invalid'> dog", ['cat', '<\'invalid\'>', 'dog']),
        true,
      );
    });

    test(
        'should be able to handle the PROXIMITY operator with a unclosed quote as invalid distance',
        () {
      final result = parser.parseExpression(
        "cat <'invalid> dog",
        performEarlyChecks: false,
      );

      expect(
        deepEq(result, ['cat', '<\'invalid>', 'dog']),
        true,
      );
    });

    test('should be able to handle the NOT operator', () {
      expect(compare("!cat & dog", ['!', 'cat', '&', 'dog']), true);
    });

    test('should be able to handle the prefix matching operator', () {
      expect(compare("search:*", ['search', ':*']), true);
    });

    test(
        'should recognize the prefix operator when used with a binary operator',
        () {
      expect(
        compare("search:* & 'study'", ['search', ':*', '&', 'study']),
        true,
      );
    });

    test('should remove prefix matching operator when inside quotes', () {
      expect(
        compare("'search:*' & 'study'", ['search', '&', 'study']),
        true,
      );
    });

    test('should sort prefix matching labels', () {
      expect(
        compare("search:ACDB* & 'study'", ['search', ':*abcd', '&', 'study']),
        true,
      );
    });

    test('should reduce duplicate labels in prefix match operator', () {
      expect(
        compare(
          "search:AACBABDBA**CB*DADCB* & 'study'",
          ['search', ':*abcd', '&', 'study'],
        ),
        true,
      );
    });

    test('should should treat each colon as a new prefix match operator', () {
      expect(
        compare(
          "search:ABDD:CABCADBC*DCACD*:DACACD: & 'study'",
          ['search', ':abd', ':*abcd', ':acd', ':', '&', 'study'],
        ),
        true,
      );
    });

    test(
        'should be able to recognize the prefix matching operator when outside quotes',
        () {
      expect(
        compare("'search':* & 'study'", ['search', ':*', '&', 'study']),
        true,
      );
    });

    test(
        'should not recognize the prefix matching operator when not spaced out and outside quotes',
        () {
      expect(
        compare("'search':*&'study'", ['search', ':*&', 'study']),
        true,
      );
    });

    test(
        'should blend the prefix operator with unquoted and unspaced adjacent words',
        () {
      // It is expected to reduce letters of the adjacent words that are a weight
      // label in the prefix match operator, that's why 'study' loses its 'd'
      expect(
        compare("'search':*&study", ['search', ':*d&stuy']),
        true,
      );
    });

    test('should be able to negate hyphened words', () {
      expect(
        compare(
          "!'black-cat'",
          ['!', '(', 'black', '<->', 'cat', ')'],
        ),
        true,
      );
    });

    test('should be able to handle subexpressions', () {
      expect(
        compare(
          "cat & (dog | lion)",
          ['cat', '&', '(', 'dog', '|', 'lion', ')'],
        ),
        true,
      );
    });

    test('should be able to handle subexpressions without spaces', () {
      expect(
        compare(
          "cat&(dog|lion)",
          ['cat', '&', '(', 'dog', '|', 'lion', ')'],
        ),
        true,
      );
    });

    test('should be able to negate subexpressions', () {
      expect(
        compare(
          "cat & !(dog | lion)",
          ['cat', '&', '!', '(', 'dog', '|', 'lion', ')'],
        ),
        true,
      );
    });

    test(
        'should separate parenthesis when they are not separated from the operand',
        () {
      expect(
        compare(
          "(('sample' & 'string') | 'text')",
          ['(', '(', 'sample', '&', 'string', ')', '|', 'text', ')'],
        ),
        true,
      );
    });

    test('should handle incorrect parenthesis in the beginning of the query',
        () {
      expect(compare(")'cat' & 'dog'", [')', 'cat', '&', 'dog']), true);
    });

    test('should handle incorrect parenthesis in the end of the query', () {
      expect(compare("'cat' & 'dog'(", ['cat', '&', 'dog', '(']), true);
    });

    test('should handle unbalanced parenthesis', () {
      expect(
        compare(
          "'cat' & ('dog' | 'lion'))",
          ['cat', '&', '(', 'dog', '|', 'lion', ')', ')'],
        ),
        true,
      );
    });

    test(
        'should separate the not operator of the second operand from the binary operator',
        () {
      expect(
        compare("'cat' & !'dog'", ['cat', '&', '!', '(', 'dog', ')']),
        true,
      );
      expect(
        compare("'cat' | !'dog'", ['cat', '|', '!', '(', 'dog', ')']),
        true,
      );
      expect(
        compare("'cat' <-> !'dog'", ['cat', '<->', '!', '(', 'dog', ')']),
        true,
      );
      expect(
        compare("'cat' <2> !'dog'", ['cat', '<2>', '!', '(', 'dog', ')']),
        true,
      );
    });
  });

  group('query optimization tests', () {
    late final bool Function(String expression, List<String> expected) compare;

    setUpAll(() {
      compare = (expression, expected) {
        final tokens = parser.parseExpression(expression);
        final optimizedTokens = optimizer.optimize(tokens, loadDict('english'));

        print(optimizedTokens);
        return deepEq(optimizedTokens, expected);
      };
    });

    group('stop word removal', () {
      test('should remove stop words', () {
        expect(compare("'the'", []), true);
      });

      test('should remove a stop word and its binary operator', () {
        expect(compare("'the' & 'cat'", ['cat']), true);
      });

      test('should remove a stop word and its not operator', () {
        expect(compare("!'the'", []), true);
      });

      test(
          'should correctly remove stop words when placed in the beginning of the query',
          () {
        expect(
          compare(
            "'the' & 'cat' | 'dog'",
            ['cat', '|', 'dog'],
          ),
          true,
        );
      });

      test(
          'should correctly remove stop words when placed in the end of the query',
          () {
        expect(
          compare(
            "'cat' | 'dog' & the | or <-> if | i & my",
            ['cat', '|', 'dog'],
          ),
          true,
        );
      });

      test(
          'should correctly remove stop words when placed in the beginning of a subexpression',
          () {
        expect(
          compare(
            "'cat' & ('the' & 'dog' | 'lion')",
            ['cat', '&', '(', 'dog', '|', 'lion', ')'],
          ),
          true,
        );
      });

      test(
          'should correctly remove stop words when placed in the end of a subexpression',
          () {
        expect(
          compare(
            "'cat' & ('dog' | 'lion' & 'the' | 'of')",
            ['cat', '&', '(', 'dog', '|', 'lion', ')'],
          ),
          true,
        );
      });

      test(
          'should correctly remove stop words when negated in the beginning of the query',
          () {
        expect(
          compare(
            "!'the' & 'cat' | 'dog'",
            ['cat', '|', 'dog'],
          ),
          true,
        );
      });

      test(
          'should correctly remove stop words when negated in the end of the query',
          () {
        expect(
          compare(
            "'cat' | 'dog' & the | or <-> if | !i & my",
            ['cat', '|', 'dog'],
          ),
          true,
        );
      });

      test(
          'should correctly remove stop words when negated in the beginning of a subexpression',
          () {
        expect(
          compare(
            "'cat' & (!'the' & 'dog' | 'lion')",
            ['cat', '&', '(', 'dog', '|', 'lion', ')'],
          ),
          true,
        );
      });

      test(
          'should correctly remove stop words when negated in the end of a subexpression',
          () {
        expect(
          compare(
            "'cat' & ('dog' | 'lion' & 'the' | !'of')",
            ['cat', '&', '(', 'dog', '|', 'lion', ')'],
          ),
          true,
        );
      });
    });

    group('query simplification', () {
      test('should remove unnecessary parenthesis', () {
        expect(
          compare(
            "('sample' <-> ('string'))",
            ['(', 'sample', '<->', 'string', ')'],
          ),
          true,
        );
      });
    });
  });

  group('early checks on', () {
    late final bool Function(String expression, List<String> expected) compare;

    setUpAll(() {
      compare = (expression, expected) {
        final tokens = parser.parseExpression(
          expression,
          performEarlyChecks: true,
        );

        return deepEq(tokens, expected);
      };
    });

    test('should throw an Exception if there is an unclosed single quotes', () {
      expect(
        () => compare("'cat & 'dog'", ['cat', '&', 'dog']),
        throwsException,
      );
    });

    test('should not throw an Exception if there is an apostrophe', () {
      expect(
        compare("'mister''s' & 'dog'", ['mister\'s', '&', 'dog']),
        true,
      );
    });
  });

  group('early checks off', () {
    late final bool Function(String expression, List<String> expected) compare;

    setUpAll(() {
      compare = (expression, expected) {
        final tokens = parser.parseExpression(
          expression,
          performEarlyChecks: false,
        );

        return deepEq(tokens, expected);
      };
    });

    test('should not throw an Exception if there is an unclosed single quotes',
        () {
      expect(
        compare("'cat & 'dog'", ['cat', 'dog']),
        true,
      );
    });
  });
}
