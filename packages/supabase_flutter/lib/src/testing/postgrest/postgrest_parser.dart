import 'package:supabase_flutter/src/testing/postgrest/supabase_test_postgrest.dart';
import 'package:supabase_flutter/src/testing/postgrest/postgrest_tokens.dart';
import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';

class PostrestValueParser {
  int _index = 0;
  String _current = '';
  String _expression = '';
  bool _allowDartLists = false;

  final List<PostrestValueToken> _tokens = [];

  List<PostrestValueToken> tokenize(String expression,
      {bool allowDartLists = false}) {
    _expression = _processExpression(expression);
    _allowDartLists = allowDartLists;
    _tokenize();
    final tokens = [..._tokens];
    _cleanParsingCache();
    return tokens;
  }

  void _tokenize() {
    _consume();

    while (_index < _expression.length) {
      if (_current == '{') {
        _tokens.add(StartToken());
      } else if (_current == '\'') {
        final value = _consumeWhile(() => _current != '\'');
        final quotedValue = '$value\'';
        _tokens.add(ValueToken(quotedValue));
      } else if (_isNumber(_current)) {
        final value = _consumeWhile(() => _isValue(_current)).trim();
        _tokens.add(ValueToken(value));
        continue;
      } else if (_current == '[' || _current == '(') {
        final value = _consumeNested(['(', '['], [']', ')']);
        if (_allowDartLists) {
          final elements = value.substring(
            value.firstIndex! + 1,
            value.lastIndex,
          );
          final convertedList = '{$elements}';
          final localParser = PostrestValueParser();
          final parsedList = localParser.tokenize(
            convertedList,
            allowDartLists: true,
          );

          if (_isRange(parsedList)) {
            _tokens.add(ValueToken(value));
          } else {
            _tokens.addAll(parsedList);
          }
        } else {
          _tokens.add(ValueToken(value));
        }
      } else if (_current == ':') {
        _tokens.add(AssignmentToken());
      } else if (_current == ',') {
        _tokens.add(SeparatorToken());
      } else if (_current == '}') {
        _tokens.add(EndToken());
      } else if (_current != ' ') {
        final value =
            _consumeWhile(() => _isValue(_current) && _current != ':').trim();
        _tokens.add(ValueToken(value));
        continue;
      }

      _consume();
    }
  }

  bool _isRange(List<PostrestValueToken> tokens) {
    final List<PostrestValueToken> valueStack = [];

    for (final token in tokens) {
      if (token is StartToken) {
        valueStack.clear();
      } else if (token is ValueToken) {
        if (token.tokenType == String &&
            !['infinity', '-infinity', 'null'].contains(token.value)) {
          valueStack.clear();
        } else {
          valueStack.add(token);
        }
      }
    }
    return valueStack.length == 2;
  }

  bool _isNumber(String character) => RegExp(r'^\d$').hasMatch(character);

  bool _isValue(String char) =>
      char != '"' &&
      char != ',' &&
      char != '{' &&
      char != '}' &&
      char != '[' &&
      char != '(' &&
      char != ']' &&
      char != ')';

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

  String _consumeNested(
      List<String> openingTokens, List<String> closingTokens) {
    String buffer = '';
    bool isEndOfExpression = _index == (_expression.length - 1);
    final List<String> openingStack = [_current];

    while (openingStack.isNotEmpty && !isEndOfExpression) {
      final value = _consumeWhile(
        () =>
            (!openingTokens.contains(_current)) &&
            (!closingTokens.contains(_current)),
      );
      isEndOfExpression = _index == (_expression.length - 1);
      buffer += value;

      if (openingTokens.contains(_current)) {
        openingStack.add(_current);
      } else if (closingTokens.contains(_current)) {
        openingStack.removeLast();
      }
    }

    buffer += _current;

    return buffer;
  }

  String _processExpression(String expression) =>
      expression.replaceAll('\n', '').replaceAll('"', '\'').trim();

  void _cleanParsingCache() {
    _index = 0;
    _current = '';
    _expression = '';
    _tokens.clear();
  }
}

class PostrestExpParser {
  int _index = 0;
  String _current = '';
  String _expression = '';
  PostrestFilterParams _currentFilter = PostrestFilterParams.empty();

  final List<PostrestExpToken> _tokens = [];

  List<PostrestExpToken> tokenizeExpression(String expression) {
    _expression = expression.trim();
    _tokenizeExpression();
    final tokens = [..._tokens];
    _cleanParsingCache();
    return tokens;
  }

  void _tokenizeExpression() {
    if (_expression.isEmpty) {
      return;
    }

    _consume();

    while (_index < _expression.length) {
      if (_currentFilter.isComplete) {
        _tokens.add(_currentFilter);
        _currentFilter = PostrestFilterParams.empty();
      }

      if (_current == '(') {
        _invalidValueSyntax();
        _parseValue(')');
      } else if (_current == ')') {
        _tokens.add(LogicalEnd());
      } else if (_current == '{') {
        _invalidValueSyntax();
        _parseValue('}');
      } else if (_current == '"') {
        _invalidValueSyntax();
        _parseValue('"');
      } else if (_current == "'") {
        _invalidValueSyntax();
        _parseValue("'");
      } else {
        if (_current != ' ' && _current != ',' && _current != '.') {
          late final String element;

          if (_currentFilter.column == null) {
            element = _consumeWhile(
              () => _current != '.' && _current != ',' && _current != '(',
            );
          } else if (_currentFilter.filter == null) {
            element = _consumeWhile(
              () => _current != '.' && _current != ',',
            );
          } else {
            element = _consumeWhile(
              () => _current != ',' && _current != ')',
            );
          }

          if (_current == '(') {
            if (element == 'and') {
              _refreshFilter();
              _tokens.add(
                LogicalStart(precedence: PostrestFilterPrecedence.and),
              );
            }

            if (element == 'or') {
              _refreshFilter();
              _tokens.add(
                LogicalStart(precedence: PostrestFilterPrecedence.or),
              );
            }
          } else {
            _currentFilter = _currentFilter.addPartially(element);
            continue;
          }
        }
      }
      _consume();
    }

    _refreshFilter();

    if (_tokens.any(
      (token) => token is PostrestFilterParams ? !token.isComplete : false,
    )) {
      throw Exception('Incomplete filter syntax found.');
    }
  }

  void _refreshFilter() {
    if (!_currentFilter.isEmpty) {
      _tokens.add(_currentFilter);
    }
  }

  void _parseValue(String endFlag) {
    final element = _consumeWhile(() => _current != endFlag);
    final finalElement = '$element$endFlag';
    _currentFilter = _currentFilter.addPartially(finalElement);
  }

  void _invalidValueSyntax() {
    if (!_isCurrentFilterMissingOnlyValue()) {
      throw Exception('Invalid syntax.');
    }
  }

  bool _isCurrentFilterMissingOnlyValue() =>
      _currentFilter.column != null &&
      _currentFilter.filter != null &&
      _currentFilter.value == null;

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
    _currentFilter = PostrestFilterParams.empty();
  }
}
