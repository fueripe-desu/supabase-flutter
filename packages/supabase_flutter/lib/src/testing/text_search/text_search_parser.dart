import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search.dart';

class TextSearchParser {
  int _index = 0;
  String _current = '';
  String _expression = '';

  final List<String> _tokens = [];

  List<String> parseExpression(String expression) {
    final lowerCaseExp = expression.toLowerCase();
    final handledHyphens = _handleHyphens(lowerCaseExp);
    final handledApostrophes = _handleApostrophes(handledHyphens);
    final spacedAngleBrackets = _spaceOutAngleBrackets(handledApostrophes);
    final removedExtraSpaces = spacedAngleBrackets.removeExtraSpaces();

    _expression = removedExtraSpaces;

    final processedExpression = _processExpression();
    _cleanParsingCache();
    return processedExpression;
  }

  List<String> _processExpression() {
    if (_expression.isEmpty) {
      return [];
    }

    _consume();

    while (_index < _expression.length) {
      if (_current == '\'') {
        final element = _consumeWhile(() => _current != '\'');
        final filteredElement = _removeOperators(element);
        final addedApos = filteredElement.replaceAll('AA', '\'');
        final addedPhrase = _addPhraseBetweenOperands(addedApos);

        if (_tokens.isNotEmpty && _tokens.last == '!') {
          addedPhrase.insert(0, '(');
          addedPhrase.add(')');
        }

        if (filteredElement.isNotEmpty) {
          _tokens.addAll([...addedPhrase]);
        }
      } else if (_isAlphanumeric(_current)) {
        final element = _consumeWhile(() => _isAlphanumeric(_current));
        _tokens.add(element);

        // We need this continue so it does not exclude the index where
        // _consumeWhile() stopped
        continue;
      } else if (_current == '<') {
        final element = _consumeWhile(() => _current != '>' && _current != ' ');
        final correctedElement = _current == '>' ? '$element>' : element;
        final removedSpace = correctedElement.removeSpaces();
        _tokens.add(removedSpace);
      } else {
        if (_current != ' ') {
          _tokens.add(_current);
        }
      }

      _consume();
    }

    return List.from(_tokens);
  }

  List<String> _addPhraseBetweenOperands(String expression) =>
      expression.trim().replaceAll(' ', ' <-> ').split(' ');

  String _removeOperators(String expression) => expression
      .replaceAll(RegExp(r'<(\d+)>'), '')
      .replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), ' ')
      .removeExtraSpaces()
      .trim();

  String _handleHyphens(String expression) {
    // Matches all "-" that the character before is different from "<"
    // and the character after is different from ">", the purpose of
    // doing this is so it won't match the dash inside the phrase
    // operator, but only hyphens that appear in words
    return expression.replaceAll(RegExp(r'(?<!<)-(?!\>)'), ' ');
  }

  String _handleApostrophes(String expression) =>
      expression.replaceAll('\'\'', 'AA');

  String _spaceOutAngleBrackets(String expression) {
    final regex = RegExp(r'<[^<>]*>');

    String result = expression.replaceAll('<', ' < ').replaceAll('>', ' > ');

    if (regex.hasMatch(result)) {
      final matches = regex.allMatches(result);
      int offset = 0;

      for (RegExpMatch match in matches) {
        final element = result.substring(
          match.start - offset,
          match.end - offset,
        );
        final spaceCount = element.count(' ');
        final removedSpaces = element.removeSpaces();
        result = result.replaceRange(
          match.start - offset,
          match.end - offset,
          removedSpaces,
        );
        offset += spaceCount;
      }
    }

    return result;
  }

  bool _isAlphanumeric(String char) => RegExp(r'[^\W\s]+').hasMatch(char);

  bool _consume() {
    // If _current is not empty, then it is not the first time you are
    // calling _consume(), in the first time we just assign the already
    // defined index to the _current variable.
    if (_current.isNotEmpty) {
      _index++;
    }

    // Index out of range
    if (_index >= _expression.length) {
      return false;
    }

    _current = _expression[_index];
    return true;
  }

  String _consumeWhile(bool Function() testFunc) {
    String buffer = '';

    do {
      if (_current.isNotEmpty) {
        buffer += _current;
      }

      if (!_consume()) {
        break;
      }
    } while (testFunc());

    return buffer;
  }

  void _cleanParsingCache() {
    _index = 0;
    _current = '';
    _expression = '';
    _tokens.clear();
  }
}

class QueryOptimizer {
  final List<String> _tokens = [];

  List<String> optimize(List<String> tokens, TextSearchDictionary dict) {
    _tokens.addAll(tokens);

    // First, we need to remove useless sub expressions, because when using
    // so instead of returning the incorrect output:
    //
    // ['(', 'sample', '<->', '(', 'string', ')', ')']
    //
    // We need to return the cleaned up version:
    //
    // ['(', 'sample', '<->', 'string', ')']
    //
    _removeUnnecessaryParentheses();

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
    final optimizedTokens = [..._removeStopWords(dict)];
    clearCache();

    return optimizedTokens;
  }

  List<String> _removeUnnecessaryParentheses() {
    // Stack to keep track of opening parentheses positions
    final List<int> stack = [];
    // Set to keep track of parentheses positions to remove
    final Set<int> toRemove = {};

    for (int i = 0; i < _tokens.length; i++) {
      if (_tokens[i] == '(') {
        stack.add(i);
      } else if (_tokens[i] == ')') {
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
    for (int i = 0; i < _tokens.length; i++) {
      if (!toRemove.contains(i)) {
        newTokens.add(_tokens[i]);
      }
    }

    return newTokens;
  }

  List<String> _removeStopWords(TextSearchDictionary dict) {
    final List<String> newTokens = [];
    final List<String> stopWordStack = [];
    final List<String> operatorStack = [];

    for (final token in _tokens) {
      if (dict.containsStopWord(token)) {
        stopWordStack.add(token);
      } else if (token == '(') {
        if (operatorStack.isNotEmpty) {
          if (newTokens.isNotEmpty) {
            operatorStack.add(newTokens.removeLast());
          }
          final highestOperator = _findLowestPrecedenceOperator(operatorStack);
          final operation =
              TextSearchOperation.fromStringToOperation(highestOperator);

          late final String operatorToAdd;

          if (operation == TextSearchOperation.phrase) {
            operatorToAdd = '<${stopWordStack.length + 1}>';
          } else {
            operatorToAdd = highestOperator;
          }

          if (newTokens.isNotEmpty) {
            newTokens.add(operatorToAdd);
          }
          newTokens.add(token);
          operatorStack.clear();
          stopWordStack.clear();
        } else {
          newTokens.add(token);
        }
      } else if (_isOperator(token)) {
        if (stopWordStack.isNotEmpty) {
          operatorStack.add(token);
        } else {
          newTokens.add(token);
        }
      } else {
        if (operatorStack.isNotEmpty) {
          if (newTokens.isNotEmpty && newTokens.last != '(') {
            operatorStack.add(newTokens.removeLast());
          }
          final highestOperator = _findLowestPrecedenceOperator(operatorStack);
          final operation =
              TextSearchOperation.fromStringToOperation(highestOperator);

          late final String operatorToAdd;

          if (operation == TextSearchOperation.phrase) {
            operatorToAdd = '<${stopWordStack.length + 1}>';
          } else {
            operatorToAdd = highestOperator;
          }

          if (newTokens.isNotEmpty && newTokens.last != '(' && token != ')') {
            newTokens.add(operatorToAdd);
          }
          newTokens.add(token);
          operatorStack.clear();
          stopWordStack.clear();
        } else {
          newTokens.add(token);
        }
      }
    }

    if (newTokens.isNotEmpty && stopWordStack.isNotEmpty) {
      newTokens.removeLast();
    }

    return newTokens;
  }

  String _findLowestPrecedenceOperator(List<String> operators) {
    int lowest = 4;
    String finalOperator = "<->";

    for (final oprt in operators) {
      final operation = TextSearchOperation.fromStringToOperation(oprt);

      if (operation != null &&
          TextSearchOperation.isBinaryOperator(operation) &&
          operation.precedence < lowest) {
        lowest = operation.precedence;
        finalOperator = oprt;
      }
    }

    return finalOperator;
  }

  bool _isOperator(String token) =>
      TextSearchOperation.isStringBinaryOperator(token) ||
      TextSearchOperation.isStringUnaryOperator(token) ||
      TextSearchOperation.isStringSubExpression(token);

  void clearCache() {
    _tokens.clear();
  }
}

class PlainTextSearchConverter {
  String convertToTsQuery(String query) {
    final filteredQuery = _removeOperators(query);
    return _addAndOperatorBetweenTerms(filteredQuery);
  }

  String _addAndOperatorBetweenTerms(String query) =>
      query.split(' ').join(' & ');

  String _removeOperators(String query) {
    // This is used to match all characters that are neither an alphanumeric
    // character nor a space
    RegExp pattern = RegExp(r'[^\w\s]');

    return query.replaceAll(pattern, ' ').removeExtraSpaces().trim();
  }
}

class PhraseTextSearchConverter {
  String convertToTsQuery(String query) {
    final filteredQuery = _removeOperators(query);
    return _addAndOperatorBetweenTerms(filteredQuery);
  }

  String _addAndOperatorBetweenTerms(String query) =>
      query.split(' ').join(' <-> ');

  String _removeOperators(String query) {
    // This is used to match all characters that are neither an alphanumeric
    // character nor a space
    final pattern = RegExp(r'[^\w\s]');

    return query.replaceAll(pattern, ' ').removeExtraSpaces().trim();
  }
}

class WebSearchTextSearchConverter {
  String convertToTsQuery(String query) {
    final lowerCaseQuery = query.toLowerCase();
    final filteredQuery = _removeOperators(lowerCaseQuery);
    final processedQuery = _addOperatorsBetweenTerms(filteredQuery);
    return _convertStringToOperator(processedQuery);
  }

  String _convertStringToOperator(String query) {
    final regex = RegExp(r'(?<!<)-(?!\>)');

    String newQuery = "";
    final List<String> operationStack = [];

    final splitQuery = query.removeExtraSpaces().trim().split(' ').trimAll();
    for (final token in splitQuery) {
      if (token == 'and') {
        operationStack.removeLast();
        operationStack.add(token);
      } else if (token == 'or') {
        operationStack.removeLast();
        operationStack.add(token);
      } else if (token == '&') {
        if (!['and', 'or'].contains(operationStack.last)) {
          operationStack.add(token);
        }
      } else if (token.startsWith('-')) {
        final tokenWithoutDash = token.length > 1 ? token.substring(1) : '';
        if (['and', 'or', '&'].contains(operationStack.last)) {
          operationStack.add('!$tokenWithoutDash');
        } else {
          operationStack.add('&');
          operationStack.add('!$tokenWithoutDash');
        }
      } else if (regex.hasMatch(token)) {
        final processedToken = token.replaceAll('-', ' <-> ');
        operationStack.add(processedToken);
      } else {
        operationStack.add(token);
      }
    }

    newQuery = operationStack.join(' ');

    return newQuery
        .replaceAll(RegExp(r'\band\b'), '&')
        .replaceAll(RegExp(r'\bor\b'), '|');
  }

  String _addOperatorsBetweenTerms(String query) {
    final List<String> quotesStack = [];
    final List<String> parenthesisStack = [];
    String newQuery = "";

    final splitQuery = query.removeExtraSpaces().trim().split('');

    for (int i = 0; i < splitQuery.length; i++) {
      final current = splitQuery[i];

      if (current == '"') {
        // We need this to negate the subexpression
        if (newQuery.last() == '-') {
          newQuery += '(';
          parenthesisStack.add('(');
        }

        if (quotesStack.isNotEmpty) {
          quotesStack.removeLast();

          if (parenthesisStack.isNotEmpty) {
            newQuery += ')';
            parenthesisStack.removeLast();
          }
        } else {
          quotesStack.add('"');
        }
      } else if (current == ' ') {
        if (quotesStack.isNotEmpty) {
          newQuery += ' <-> ';
        } else {
          newQuery += ' & ';
        }
      } else {
        newQuery += current;
      }
    }

    if (quotesStack.isNotEmpty) {
      throw Exception(
        'Invalid query. Unclosed double quotes from compound term.',
      );
    }

    return newQuery;
  }

  String _removeOperators(String query) {
    // This is used to match all characters that are neither an alphanumeric
    // character nor a space
    final pattern = RegExp(r'[^\w\s"-]');

    return query.replaceAll(pattern, ' ').removeExtraSpaces().trim();
  }
}
