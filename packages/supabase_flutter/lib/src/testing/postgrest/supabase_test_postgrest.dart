import 'package:supabase_flutter/src/testing/filters/filter_builder.dart';
import 'package:supabase_flutter/src/testing/postgrest/postgrest_token_validator.dart';
import 'package:supabase_flutter/src/testing/postgrest/postgrest_parser.dart';
import 'package:supabase_flutter/src/testing/postgrest/postgrest_tree_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum PostrestFilterPrecedence {
  and,
  or,
}

class PostrestSyntaxParser {
  PostrestSyntaxParser(List<Map<String, dynamic>> data)
      : _data = List.from(data);

  final List<Map<String, dynamic>> _data;
  final PostrestValueParser _tokenizer = PostrestValueParser();
  final PostrestValueTreeBuilder _builder = PostrestValueTreeBuilder();
  final PostrestValueTokenValidator _validator = PostrestValueTokenValidator();
  final PostrestExpParser _exprParser = PostrestExpParser();
  final PostrestExpTreeBuilder _exprBuilder = PostrestExpTreeBuilder();

  FilterBuilder executeFilter({
    required String column,
    required String filterName,
    required String value,
  }) {
    final filterFunc = parseFilter(filterName);
    late final dynamic parsedValue;

    if (['fts', 'plfts', 'phfts', 'wfts'].contains(filterName)) {
      parsedValue = value;
    } else {
      parsedValue = parseValue(
        // Convert PostgreSQL set into an array when using the in filter
        filterName == 'in' ? _convertSetIntoList(value) : value,
      );
    }

    return filterFunc(column, parsedValue);
  }

  FilterBuilder executeExpression(String expression) {
    final tokens = _exprParser.tokenizeExpression(expression);
    final tree = _exprBuilder.buildTree(tokens);
    final dataCopy = [..._data];
    final filteredData = tree.evaluate(dataCopy);
    return FilterBuilder(filteredData);
  }

  dynamic parseValue(String value, {bool allowDartLists = false}) {
    if (value.trim().isEmpty) {
      return [];
    }

    final tokens = _tokenizer.tokenize(value, allowDartLists: allowDartLists);
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
        case 'isdistinct':
          return (String column, dynamic value) =>
              filterBuilder.isDistinct(column, value);
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
              filterBuilder.rangeLt(column, value);
        case 'sr':
          return (String column, dynamic value) =>
              filterBuilder.rangeGt(column, value);
        case 'nxr':
          return (String column, dynamic value) =>
              filterBuilder.rangeLte(column, value);
        case 'nxl':
          return (String column, dynamic value) =>
              filterBuilder.rangeGte(column, value);
        case 'adj':
          return (String column, dynamic value) =>
              filterBuilder.rangeAdjacent(column, value);
        default:
          throw Exception('\'$filter\' is not a valid filter.');
      }
    } else if (modifier == 'any') {
      switch (filter) {
        case 'eq':
          return (String column, dynamic value) =>
              filterBuilder.eq(column, value);
        case 'like':
          return (String column, dynamic value) => filterBuilder.likeAnyOf(
                column,
                (value as List<dynamic>).map((e) => e.toString()).toList(),
              );
        case 'ilike':
          return (String column, dynamic value) => filterBuilder.ilikeAnyOf(
                column,
                (value as List<dynamic>).map((e) => e.toString()).toList(),
              );
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
          throw Exception('\'$filter\' is not a valid filter.');
      }
    } else if (modifier == 'all') {
      switch (filter) {
        case 'eq':
          return (String column, dynamic value) =>
              filterBuilder.eqAll(column, value);
        case 'like':
          return (String column, dynamic value) => filterBuilder.likeAllOf(
                column,
                (value as List<dynamic>).map((e) => e.toString()).toList(),
              );
        case 'ilike':
          return (String column, dynamic value) => filterBuilder.ilikeAllOf(
                column,
                (value as List<dynamic>).map((e) => e.toString()).toList(),
              );
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
          throw Exception('\'$filter\' is not a valid filter.');
      }
    } else {
      throw Exception('\'$modifier\' is an invalid modifier.');
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

      throw Exception('\'$filterName\' is not a valid filter.');
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
