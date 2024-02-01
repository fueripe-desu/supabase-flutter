import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search.dart';

class TextSearchParser {
  List<String> parseExpression(String expression, TextSearchDictionary dict) {
    final List<String> result = [];

    // Matches everything wrapped in single quotes as a single expression,
    // and matches individual words that are not wrapped in quotes, this is
    // used to parse the terms in the text search query. e.g.
    // "'red flower'" -> ["red flower"]
    // "black hair" -> ["black", "hair"]
    final regex = RegExp(r"[^\s']+|'[^']+'");

    // We need to remove the extra spaces in order to parse the expression
    // correctly.
    final formattedExp = expression.removeExtraSpaces();

    final matches = regex.allMatches(formattedExp);

    for (final match in matches) {
      result.add(match.group(0)!);
    }

    // After parsing, we need to remove the single quotes that surrounds
    // expressions, or we will end up getting results like:
    //
    // ['\'big foot\'', '&', '\'little\'']
    //
    // Because the single quotes will be considered and not removed
    // automatically, so we need to remove them by using the
    // _removeSingleQuotes() method.
    final removedSingleQuotes = _removeSingleQuotes(result);

    // We need to separate parentheses from tokens due to the main
    // flaw of this regex, it is going to separate words by its characters,
    // and it is going to count the parentheses as part of the characters of
    // the word instead of treating them as individual characters, so instead
    // of generating outputs like: ['((sample))))'], we get the expected
    // output: ['(', '(', 'sample', ')', ')', ')', ')']
    final separatedTokens = _separateParenthesesFromTokens(removedSingleQuotes);

    // After separating tokens from parethenses, we need to treat the negation
    // operator (!), because in certain cases, when it appears before the word
    // it can be blended in with the binary operator, so instead of getting:
    //
    // ['big foot', '&', '!', 'little']
    //
    // The following incorrect output is returned:
    //
    // ['big foot', '&!', 'little']
    //
    final separatedNot = _separateNotOperator(separatedTokens);

    // After separating not operators from binary operators, we need to remove
    // useless sub expressions, because when using the shunting-yard algorithm
    // later to create the parse tree, it does required for all operations
    // inside the parenthesis to be cleaned up, so instead of returning the
    // incorrect output:
    //
    // ['(', 'sample', '<->', '(', 'string', ')', ')']
    //
    // We need to return the cleaned up version:
    //
    // ['(', 'sample', '<->', 'string', ')']
    //
    final removedUnnecessary = _removeUnnecessaryParentheses(separatedNot);

    // After removing unncessary subexpressions, we need to remove stop words
    // from the query, and also remove the operators of the stop words that
    // are going to be removed, so instead of getting the incorrect output:
    //
    // ['the'] -> ['the']
    // ['the' & 'cat'] -> ['the' & 'cat']
    // [!'the' & 'cat'] -> [!'the' & 'cat']
    //
    // We get:
    //
    // ['the'] -> []
    // ['the' & 'cat'] -> ['cat']
    // [!'the' & 'cat'] -> ['cat']
    //
    return _removeStopWords(removedUnnecessary, dict);
  }

  List<String> _removeUnnecessaryParentheses(List<String> tokens) {
    // Stack to keep track of opening parentheses positions
    final List<int> stack = [];
    // Set to keep track of parentheses positions to remove
    final Set<int> toRemove = {};

    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i] == '(') {
        stack.add(i);
      } else if (tokens[i] == ')') {
        if (stack.isNotEmpty) {
          final startIndex = stack.removeLast();
          // Check if there is only one element between the parentheses
          if (i - startIndex == 2) {
            toRemove.add(startIndex);
            toRemove.add(i);
          }
        }
      }
    }

    // Create a new list excluding the unnecessary parentheses
    final List<String> newTokens = [];
    for (int i = 0; i < tokens.length; i++) {
      if (!toRemove.contains(i)) {
        newTokens.add(tokens[i]);
      }
    }

    return newTokens;
  }

  List<String> _separateNotOperator(List<String> tokens) {
    final List<String> newTokens = [];

    for (final token in tokens) {
      // Separates the negation operator when it is blended in with the
      // binary operator
      if (token.length > 1 && token.endsWithEither(['&!', '|!', '>!'])) {
        newTokens.add(token.substring(0, token.length - 1));
        newTokens.add('!');
        continue;
      }

      // Separates the negation operator when a word without single quotes
      // is preceded by it. e.g. "!black cat & 'dog'", and it also
      // separates the negation operator even when it is inside the single
      // quotes. e.g. "'!black cat' & 'dog'", so this way, no word can start
      // with a negation operator
      if (token.length > 1 && token.startsWith('!')) {
        newTokens.add('!');
        newTokens.add(token.substring(1));
        continue;
      }

      newTokens.add(token);
    }

    return newTokens;
  }

  List<String> _removeStopWords(
      List<String> tokens, TextSearchDictionary dict) {
    final List<String> newTokens = [];

    for (int i = 0; i < tokens.length; i++) {
      final current = tokens[i];
      final last = i > 0 ? tokens[i - 1] : null;
      final next = i < (tokens.length - 1) ? tokens[i + 1] : null;

      if (dict.containsStopWord(current)) {
        if (last != null) {
          if (TextSearchOperation.isStringUnaryOperator(last)) {
            newTokens.removeLast();
          }
        }
        if (next != null) {
          if (TextSearchOperation.isStringBinaryOperator(next)) {
            i++;
            continue;
          }
        }
        continue;
      }

      newTokens.add(current);
    }

    return newTokens;
  }

  List<String> _removeSingleQuotes(List<String> tokens) {
    final List<String> newTokens = [];

    for (final token in tokens) {
      if (token.startsWith('\'') && token.endsWith('\'')) {
        newTokens.add(token.substring(1, token.length - 1));
        continue;
      }
      newTokens.add(token);
    }

    return newTokens;
  }

  List<String> _separateParenthesesFromTokens(List<String> tokens) {
    // Matches every parenthesis individually, but treats all other characters
    // as a whole, as opposed to individual characters, this is used combined
    // with the split() method to separate the parenthesis from the token
    // strings generated by _parseExpression(). e.g.
    // "((sample)))))" -> ['(', '(', 'sample', ')', ')', ')', ')', ')']
    final regex = RegExp(r'(?<=\()|(?=\))|(?<=\))|(?=\()|\b');

    final List<String> newTokens = [];

    for (final token in tokens) {
      // If token contains '(' or ')'
      if (token.contains(RegExp(r'[()]'))) {
        final splitElement = token.split(regex);
        for (final element in splitElement) {
          newTokens.add(element);
        }
        continue;
      }

      newTokens.add(token);
    }

    return newTokens;
  }
}
