import 'dart:convert';

import 'package:supabase_flutter/src/testing/filter_builder.dart';
import 'package:supabase_flutter/src/testing/range_type.dart';
import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostrestSyntaxParser {
  PostrestSyntaxParser(List<Map<String, dynamic>> data)
      : _data = List.from(data);

  final List<Map<String, dynamic>> _data;
  final PostrestTokenizer _tokenizer = PostrestTokenizer();
  final PostrestTreeBuilder _builder = PostrestTreeBuilder();
  final PostrestTokenValidator _validator = PostrestTokenValidator();

  FilterBuilder executeFilter({
    required String column,
    required String filterName,
    required String value,
  }) {
    final filterFunc = parseFilter(filterName);
    final parsedValue = parseValue(
      // Convert PostgreSQL set into an array when using the in filter
      filterName == 'in' ? _convertSetIntoList(value) : value,
    );

    return filterFunc(column, parsedValue);
  }

  dynamic parseValue(String value) {
    final processedValue =
        value.replaceAll('\n', '').replaceAll('"', '\'').trim();

    if (processedValue.isEmpty) {
      return [];
    }

    final tokens = _tokenizer.tokenize(processedValue);
    final validationResult = _validator.validate(tokens);

    if (!validationResult.isValid) {
      throw Exception(validationResult.message!);
    }

    final tree = _builder.buildTree(tokens);
    final finalValue = tree.evaluate();

    return finalValue;
  }

  FilterBuilder Function(String column, dynamic value) parseFilter(
    String filterName,
  ) {
    final filterBuilder = FilterBuilder(_data);
    final (filter, modifier) = _parseFilterName(filterName);

    if (modifier == null) {
      switch (filter) {
        case 'eq':
          return (String column, dynamic value) =>
              filterBuilder.eq(column, value);
        case 'gt':
          return (String column, dynamic value) =>
              filterBuilder.gt(column, value);
        case 'gte':
          return (String column, dynamic value) =>
              filterBuilder.gte(column, value);
        case 'lt':
          return (String column, dynamic value) =>
              filterBuilder.lt(column, value);
        case 'lte':
          return (String column, dynamic value) =>
              filterBuilder.lte(column, value);
        case 'neq':
          return (String column, dynamic value) =>
              filterBuilder.neq(column, value);
        case 'like':
          return (String column, dynamic value) =>
              filterBuilder.like(column, value);
        case 'ilike':
          return (String column, dynamic value) =>
              filterBuilder.ilike(column, value);
        case 'match':
          return (String column, dynamic value) => filterBuilder.match(value);
        case 'in':
          return (String column, dynamic value) =>
              filterBuilder.inFilter(column, value);
        case 'is':
          return (String column, dynamic value) =>
              filterBuilder.isFilter(column, value);
        case 'fts':
          return (String column, dynamic value) =>
              filterBuilder.textSearch(column, value);
        case 'plfts':
          return (String column, dynamic value) => filterBuilder
              .textSearch(column, value, type: TextSearchType.plain);
        case 'phfts':
          return (String column, dynamic value) => filterBuilder
              .textSearch(column, value, type: TextSearchType.phrase);
        case 'wfts':
          return (String column, dynamic value) => filterBuilder
              .textSearch(column, value, type: TextSearchType.websearch);
        case 'cs':
          return (String column, dynamic value) =>
              filterBuilder.contains(column, value);
        case 'cd':
          return (String column, dynamic value) =>
              filterBuilder.containedBy(column, value);
        case 'ov':
          return (String column, dynamic value) =>
              filterBuilder.overlaps(column, value);
        case 'sl':
          return (String column, dynamic value) =>
              filterBuilder.strictlyLeftOf(column, value);
        case 'sr':
          return (String column, dynamic value) =>
              filterBuilder.strictlyRightOf(column, value);
        case 'nxr':
          return (String column, dynamic value) =>
              filterBuilder.doesNotExtendToTheRightOf(column, value);
        case 'nxl':
          return (String column, dynamic value) =>
              filterBuilder.doesNotExtendToTheLeftOf(column, value);
        case 'adj':
          return (String column, dynamic value) =>
              filterBuilder.rangeAdjacent(column, value);
        default:
          throw Exception('Uknown filter');
      }
    } else if (modifier == 'any') {
      switch (filter) {
        case 'eq':
          return (String column, dynamic value) =>
              filterBuilder.eq(column, value);
        case 'like':
          return (String column, dynamic value) =>
              filterBuilder.likeAnyOf(column, value);
        case 'ilike':
          return (String column, dynamic value) =>
              filterBuilder.ilikeAnyOf(column, value);
        case 'gt':
          return (String column, dynamic value) =>
              filterBuilder.gtAny(column, value);
        case 'gte':
          return (String column, dynamic value) =>
              filterBuilder.gteAny(column, value);
        case 'lt':
          return (String column, dynamic value) =>
              filterBuilder.ltAny(column, value);
        case 'lte':
          return (String column, dynamic value) =>
              filterBuilder.lteAny(column, value);
        default:
          throw Exception('Uknown filter');
      }
    } else if (modifier == 'all') {
      switch (filter) {
        case 'eq':
          return (String column, dynamic value) =>
              filterBuilder.eqAll(column, value);
        case 'like':
          return (String column, dynamic value) =>
              filterBuilder.likeAllOf(column, value);
        case 'ilike':
          return (String column, dynamic value) =>
              filterBuilder.ilikeAllOf(column, value);
        case 'gt':
          return (String column, dynamic value) =>
              filterBuilder.gtAll(column, value);
        case 'gte':
          return (String column, dynamic value) =>
              filterBuilder.gteAll(column, value);
        case 'lt':
          return (String column, dynamic value) =>
              filterBuilder.ltAll(column, value);
        case 'lte':
          return (String column, dynamic value) =>
              filterBuilder.lteAll(column, value);
        default:
          throw Exception('Uknown filter');
      }
    } else {
      throw Exception('Invalid modifier');
    }
  }

  (String, String?) _parseFilterName(String filterName) {
    final newFilterName = filterName.replaceAll(' ', '');

    if (newFilterName.contains('(')) {
      final regex = RegExp(r'^([a-z]+)\(([a-z]+)\)$');

      if (regex.hasMatch(newFilterName)) {
        final match = regex.firstMatch(newFilterName)!;
        final filter = match.group(1)!;
        final modifier = match.group(2)!;

        return (filter, modifier);
      }

      throw Exception('Invalid filter.');
    } else {
      return (newFilterName, null);
    }
  }

  String _convertSetIntoList(String value) {
    String newValue = value;
    final int lastIndex = newValue.length - 1;

    if (newValue[0] == '(') {
      newValue = '{${newValue.substring(1)}';
    }

    if (newValue[lastIndex] == ')') {
      newValue = '${newValue.substring(0, lastIndex)}}';
    }

    return newValue;
  }
}

class PostrestTreeBuilder {
  final List<TokenType> _tokens = [];

  TokenType buildTree(List<TokenType> tokens) {
    _tokens.addAll(tokens);
    final finalToken = _buildTree();
    cleanCache();
    return finalToken;
  }

  TokenType _buildTree() {
    final List<TokenType> finalTokens = [];
    final bool isComplexType = _tokens.length > 1;

    for (int i = 0; i < _tokens.length; i++) {
      final token = _tokens[i];

      if (token is EndToken || token is EndRangeToken) {
        finalTokens.add(token);
        final newToken = buildLastToken(finalTokens, isComplexType);
        finalTokens.add(newToken);
      } else {
        finalTokens.add(token);
      }
    }

    return finalTokens.first;
  }

  TokenType buildLastToken(List<TokenType> tokensList, bool isComplexType) {
    final List<TokenType> localTokens = [];

    while (tokensList.isNotEmpty && !_isStartToken(tokensList.last)) {
      final token = tokensList.removeLast();
      localTokens.insert(0, token);
    }

    if (isComplexType) {
      final startToken = tokensList.removeLast();
      localTokens.insert(0, startToken);
    }

    if (isComplexType && localTokens.any((token) => _isDelimiterToken(token))) {
      if (_listHasJson(localTokens)) {
        final jsonString = _rebuildTokenString(localTokens);
        return JsonToken(jsonString);
      } else if (_listHasRange(localTokens)) {
        final rangeString = _rebuildTokenString(localTokens);
        final type = _getRangeForceType(rangeString);
        return RangeToken(rangeString, type);
      } else {
        final values = _filterValueTokens(localTokens);
        return ListToken(values);
      }
    } else {
      return localTokens.first;
    }
  }

  List<TokenType> _filterValueTokens(List<TokenType> tokens) =>
      tokens.where((element) => _isValueToken(element)).toList();

  bool _listHasJson(List<TokenType> tokens) =>
      tokens.any((element) => element is AssignmentToken);

  bool _listHasRange(List<TokenType> tokens) => tokens
      .any((element) => element is StartRangeToken || element is EndRangeToken);

  bool _isDelimiterToken(TokenType token) =>
      _isStartToken(token) || _isEndToken(token);

  bool _isStartToken(TokenType token) =>
      token is StartToken || token is StartRangeToken;

  bool _isEndToken(TokenType token) =>
      token is EndToken || token is EndRangeToken;

  bool _isValueToken(TokenType token) =>
      token is ValueToken ||
      token is JsonToken ||
      token is ListToken ||
      token is RangeToken;

  String _rebuildTokenString(List<TokenType> tokens) {
    String buffer = '';
    for (TokenType element in tokens) {
      buffer += element.toString();
    }
    return buffer;
  }

  RangeDataType? _getRangeForceType(String rangeString) {
    final options = ['[,]', '(,)', '[,)', '(,]'];

    if (rangeString.equalsEither(options)) {
      return RangeDataType.integer;
    } else if (rangeString.contains('-infinity,infinity')) {
      return RangeDataType.integer;
    }

    return null;
  }

  void cleanCache() {
    _tokens.clear();
  }
}

class PostrestTokenizer {
  int _index = 0;
  String _current = '';
  String _expression = '';

  final List<TokenType> _tokens = [];

  List<TokenType> tokenize(String expression) {
    _expression = expression;
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
        _tokens.add(StartRangeToken(_current));
      } else if (_current == ']' || _current == ')') {
        _tokens.add(EndRangeToken(_current));
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

  void _cleanParsingCache() {
    _index = 0;
    _current = '';
    _expression = '';
    _tokens.clear();
  }
}

class PostrestTokenValidator {
  final List<TokenType> _tokens = [];

  PostrestValidationResult validate(List<TokenType> tokens) {
    _tokens.addAll(tokens);

    if (_invalidFirstToken()) {
      return const PostrestValidationResult(
        isValid: false,
        message: 'First token is invalid.',
      );
    }

    if (_invalidLastToken()) {
      return const PostrestValidationResult(
        isValid: false,
        message: 'Last token is invalid.',
      );
    }

    if (_consecutiveCommas()) {
      return const PostrestValidationResult(
        isValid: false,
        message: 'Consecutive commas found.',
      );
    }

    if (_unclosedComplexType()) {
      return const PostrestValidationResult(
        isValid: false,
        message: 'Unclosed complex type found.',
      );
    }

    if (_trailingComma()) {
      return const PostrestValidationResult(
        isValid: false,
        message: 'Trailing comma found.',
      );
    }

    return const PostrestValidationResult(isValid: true);
  }

  bool _invalidFirstToken() =>
      _tokens.first is! ValueToken &&
      _tokens.first is! StartToken &&
      _tokens.first is! StartRangeToken;

  bool _invalidLastToken() =>
      _tokens.last is! ValueToken &&
      _tokens.last is! EndToken &&
      _tokens.last is! EndRangeToken;

  bool _consecutiveCommas() {
    final List<TokenType> operators = [];

    for (TokenType token in _tokens) {
      if (token is SeparatorToken) {
        if (operators.last is SeparatorToken) {
          return true;
        }
      }

      operators.add(token);
    }

    return false;
  }

  bool _unclosedComplexType() {
    final List<TokenType> operators = [];

    for (TokenType token in _tokens) {
      if (token is StartToken || token is StartRangeToken) {
        operators.add(token);
      }

      if (token is EndToken || token is EndRangeToken) {
        if (operators.isEmpty) {
          return true;
        } else {
          if (token is EndToken && operators.last is StartRangeToken) {
            return true;
          }

          if (token is EndRangeToken && operators.last is StartToken) {
            return true;
          }

          operators.removeLast();
        }
      }
    }

    if (operators.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool _trailingComma() {
    final List<TokenType> operators = [];

    for (TokenType token in _tokens) {
      if (token is SeparatorToken) {
        if (operators.last is StartToken) {
          return true;
        }
      }

      if (token is EndToken) {
        if (operators.last is SeparatorToken) {
          return true;
        }
      }

      operators.add(token);
    }
    return false;
  }
}

class PostrestValidationResult {
  final bool isValid;
  final String? message;

  const PostrestValidationResult({required this.isValid, this.message});
}

abstract class TokenType {
  Type? get tokenType => null;
  dynamic evaluate() => null;

  dynamic _parseBaseTypes(String value) {
    final newValue = value.trim();
    final numParse = num.tryParse(newValue);
    if (numParse != null) {
      return numParse;
    }

    if (['true', 'false'].contains(newValue)) {
      return newValue == 'true' ? true : false;
    }

    final dateTimeParse = DateTime.tryParse(newValue);
    if (dateTimeParse != null) {
      return dateTimeParse;
    }

    return newValue.replaceAll('\'', '"').replaceAll('"', '');
  }

  @override
  String toString();
}

class StartToken extends TokenType {
  @override
  String toString() => '{';
}

class EndToken extends TokenType {
  @override
  String toString() => '}';
}

class StartRangeToken extends TokenType {
  late final String _value;

  StartRangeToken(String value) : _value = value;

  @override
  String toString() => _value;
}

class EndRangeToken extends TokenType {
  late final String _value;

  EndRangeToken(String value) : _value = value;

  @override
  String toString() => _value;
}

class AssignmentToken extends TokenType {
  @override
  String toString() => ':';
}

class SeparatorToken extends TokenType {
  @override
  String toString() => ',';
}

class ValueToken extends TokenType {
  late final dynamic value;
  late final Type _type;
  late final String _valueString;

  @override
  Type? get tokenType => _type;

  ValueToken(String valueString) {
    _valueString = valueString;
    final parsed = _parseBaseTypes(valueString);

    if (parsed is int || parsed is double) {
      _type = num;
    } else if (parsed is bool) {
      _type = bool;
    } else if (parsed is DateTime) {
      _type = DateTime;
    } else if (parsed is String) {
      _type = String;
    } else {
      throw Exception('Invalid type');
    }

    value = parsed;
  }

  @override
  dynamic evaluate() => value;

  @override
  String toString() => _valueString;
}

class RangeToken extends TokenType {
  final String _rangeString;
  final RangeDataType? _rangeType;

  RangeToken(String rangeString, RangeDataType? rangeType)
      : _rangeString = rangeString,
        _rangeType = rangeType;

  @override
  dynamic evaluate() => RangeType.createRange(
        range: _rangeString,
        forceType: _rangeType,
      );

  @override
  String toString() => _rangeString;
}

class JsonToken extends TokenType {
  final String _jsonString;

  JsonToken(String jsonString) : _jsonString = jsonString.replaceAll('\'', '"');

  @override
  dynamic evaluate() {
    final data = jsonDecode(_jsonString) as Map<String, dynamic>;
    return _processJson(data);
  }

  Map<String, dynamic> _processJson(Map<String, dynamic> data) {
    final Map<String, dynamic> newData = {};
    data.forEach((key, value) {
      final parsed =
          value.runtimeType == String ? _parseBaseTypes(value) : value;
      final type = parsed.runtimeType;

      if (type == DateTime) {
        newData[key] = parsed as DateTime;
      } else if (type == String) {
        if ((parsed as String).containsEither(['[', ']', '(', ')'])) {
          try {
            final range = RangeType.createRange(range: parsed);
            newData[key] = range;
          } catch (err) {
            newData[key] = value;
          }
        } else {
          newData[key] = value;
        }
      } else {
        newData[key] = value;
      }
    });

    return {...newData};
  }

  @override
  String toString() => _jsonString;
}

class ListToken extends TokenType {
  late final List<TokenType> values;

  ListToken(List<TokenType> tokens) {
    final first = tokens.first;

    if (first is JsonToken) {
      if (!tokens.every((element) => element is JsonToken)) {
        throw Exception('Type mismatch in array');
      }
    } else {
      if (!tokens.every(
        (element) => element.tokenType == first.tokenType,
      )) {
        throw Exception('Type mismatch in array');
      }
    }

    values = List.from(tokens);
  }

  @override
  dynamic evaluate() {
    final evaluations = [];

    for (TokenType element in values) {
      evaluations.add(element.evaluate());
    }

    return [...evaluations];
  }

  @override
  String toString() => values.toString();
}
