// The stop words used in the English dictionary were retrieved here:
// https://github.com/postgres/postgres/blob/master/src/backend/snowball/stopwords/english.stop
//
// I've found a PostgreSQL non-compliant fuller version here:
// https://gist.github.com/sebleier/554280
//
// But since this is mocking PostgreSQL behavior, I've used only the first one.
//

import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:stemmer/SnowballStemmer.dart';
import 'package:supabase_flutter/src/testing/supabase_test_exceptions.dart';
import 'package:supabase_flutter/src/testing/text_search/parse_tree_builder.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search_parser.dart';
import 'package:supabase_flutter/src/testing/text_search/token_validator.dart';
import 'package:supabase_flutter/src/testing/text_search/ts_vector.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum TextSearchOperation {
  subExpression(
    precedence: 0,
    regexString: r'^\($',
  ),
  or(
    precedence: 1,
    regexString: r'^\|$',
  ),
  and(
    precedence: 2,
    regexString: r'^&$',
  ),
  proximity(
    precedence: 3,
    regexString: r'^<(\d+)>$',
  ),
  phrase(
    precedence: 4,
    regexString: r'^<->$',
  ),
  not(
    precedence: 5,
    regexString: r'^!$',
  ),
  prefix(
    precedence: 6,
    regexString: r"^:(\*)?(a)?(b)?(c)?(d)?$",
  );

  const TextSearchOperation({
    required this.precedence,
    required String regexString,
  }) : _regexString = regexString;

  final String _regexString;
  final int precedence;

  RegExp toOperatorRegex() => RegExp(_regexString);

  static bool isStringBinaryOperator(String operatorString) {
    final operation = TextSearchOperation.fromStringToOperation(operatorString);

    if (operation == null) {
      return false;
    }

    return TextSearchOperation.isBinaryOperator(operation);
  }

  static bool isStringUnaryOperator(String operatorString) {
    final operation = TextSearchOperation.fromStringToOperation(operatorString);

    if (operation == null) {
      return false;
    }

    return TextSearchOperation.isUnaryOperator(operation);
  }

  static bool isStringPrefixOperator(String operatorString) {
    final operation = TextSearchOperation.fromStringToOperation(operatorString);

    if (operation == null) {
      return false;
    }

    return TextSearchOperation.isPrefixOperator(operation);
  }

  static bool isStringSubExpression(String operatorString) {
    final operation = TextSearchOperation.fromStringToOperation(operatorString);

    if (operation == null) {
      return false;
    }

    return TextSearchOperation.isSubExpression(operation);
  }

  static bool isBinaryOperator(TextSearchOperation operation) {
    return !TextSearchOperation.isUnaryOperator(operation) &&
        !TextSearchOperation.isSubExpression(operation) &&
        !TextSearchOperation.isPrefixOperator(operation);
  }

  static bool isUnaryOperator(TextSearchOperation operation) =>
      operation == TextSearchOperation.not;

  static bool isPrefixOperator(TextSearchOperation operation) =>
      operation == TextSearchOperation.prefix;

  static bool isSubExpression(TextSearchOperation operation) =>
      operation == TextSearchOperation.subExpression;

  static TextSearchOperation? fromStringToOperation(String operatorString) {
    for (final operation in TextSearchOperation.values) {
      final regex = operation.toOperatorRegex();

      if (regex.hasMatch(operatorString)) {
        return operation;
      }
    }

    return null;
  }
}

enum WeightLabels { a, b, c, d }

class TextSearch {
  final List<Map<String, dynamic>> _data;

  const TextSearch(List<Map<String, dynamic>> data) : _data = data;

  List<Map<String, dynamic>> textSearch(
    String column,
    String query, {
    String? config,
    TextSearchType? type,
  }) {
    // Loads the dictionary with the chosen config
    final dict = _loadDictionary(config ?? 'english');

    final doc = _toTsVector(column, dict);

    late final TextSearchNode parseTree;

    if (type == TextSearchType.plain) {
      parseTree = _plainToTsQuery(query, dict);
    } else if (type == TextSearchType.phrase) {
      parseTree = _phraseToTsQuery(query, dict);
    } else if (type == TextSearchType.websearch) {
      parseTree = _webSearchToTsQuery(query, dict);
    } else {
      parseTree = _toTsQuery(query, dict);
    }

    final eval = _evaluate(doc, parseTree);

    return _filterData(eval);
  }

  List<Map<String, dynamic>> _filterData(Doc eval) {
    final evalKeys = eval.data.keys.toList();
    final List<Map<String, dynamic>> finalData = [];

    _data.forEachIndexed((index, element) {
      if (evalKeys.contains(index)) {
        finalData.add(element);
      }
    });

    return finalData;
  }

  Doc _evaluate(
    Doc doc,
    TextSearchNode parseTree,
  ) {
    final root = TextSearchNode.traverseToRoot(parseTree);

    final newDoc = Doc.empty();
    final data = doc.data;

    data.forEach((key, tsVector) {
      if (root.evaluate(tsVector)) {
        newDoc.addTsVector(key, tsVector);
      }
    });

    return newDoc;
  }

  Doc _toTsVector(String column, TextSearchDictionary dict) {
    final columnData = _retrieveColumn(column);
    final tsVectorBuilder = TsVectorBuilder();
    return tsVectorBuilder.toTsVector(columnData, dict);
  }

  TextSearchNode _toTsQuery(String query, TextSearchDictionary dict) {
    final parser = TextSearchParser();
    final optimizer = QueryOptimizer();
    final tokenValidator = TokenValidator();
    final stemmer = SnowballStemmer();

    final tokens = parser.parseExpression(query);
    final optimizedTokens = optimizer.optimize(tokens, dict);
    final validationResult = tokenValidator.validateTokens(optimizedTokens);

    if (!validationResult.isValid) {
      throw TextSearchException(validationResult.message!);
    }

    final stemmedTokens = optimizedTokens.map((e) => stemmer.stem(e)).toList();

    final builder = ParseTreeBuilder();
    final parseTree = builder.buildTree(stemmedTokens);

    return parseTree;
  }

  TextSearchNode _plainToTsQuery(String query, TextSearchDictionary dict) {
    final plainConverter = PlainTextSearchConverter();
    final tsQuery = plainConverter.convertToTsQuery(query);

    return _toTsQuery(tsQuery, dict);
  }

  TextSearchNode _phraseToTsQuery(String query, TextSearchDictionary dict) {
    final phraseConverter = PhraseTextSearchConverter();
    final tsQuery = phraseConverter.convertToTsQuery(query);

    return _toTsQuery(tsQuery, dict);
  }

  TextSearchNode _webSearchToTsQuery(String query, TextSearchDictionary dict) {
    final webSearchConverter = WebSearchTextSearchConverter();
    final tsQuery = webSearchConverter.convertToTsQuery(query);

    return _toTsQuery(tsQuery, dict);
  }

  TextSearchDictionary _loadDictionary(String dictName) {
    final file = File(
      'lib/src/testing/text_search_data/$dictName.json',
    );
    if (!file.existsSync()) {
      throw Exception('Config file \'$dictName\' does not exist.');
    }

    final jsonString = file.readAsStringSync();
    return TextSearchDictionary.fromJson(jsonString);
  }

  Map<int, String> _retrieveColumn(String column) {
    if (!_columnExists(column)) {
      throw Exception('Column \'$column\' does not exist.');
    }

    if (!_isColumnOfStringType(column)) {
      throw Exception('Column \'$column\' is not of String type.');
    }

    final docs = _data.map((element) => element[column] as String).toList();
    final Map<int, String> finalData = {};

    for (int i = 0; i < docs.length; i++) {
      finalData[i] = docs[i];
    }

    return finalData;
  }

  bool _isColumnOfStringType(String column) =>
      _data.every((element) => element[column] is String);
  bool _columnExists(String column) =>
      _data.every((element) => element.containsKey(column));
}

class TextSearchDictionary {
  final String configName;
  final List<String> stopWords;

  const TextSearchDictionary({
    required this.configName,
    required this.stopWords,
  });

  factory TextSearchDictionary.fromJson(String json) {
    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      final configName = data['config_name'] as String;
      final stopWords =
          (data['stop_words'] as List).map((word) => word as String).toList();

      return TextSearchDictionary(
        configName: configName,
        stopWords: stopWords,
      );
    } catch (err) {
      throw Exception(
        "Invalid JSON format for TextSearchDictionary: $err",
      );
    }
  }

  bool containsStopWord(String word) =>
      stopWords.any((element) => element == word);
}
