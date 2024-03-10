import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:supabase_flutter/src/testing/postgrest/supabase_test_postgrest.dart';
import 'package:supabase_flutter/src/testing/supabase_test_extensions.dart';

abstract class PostrestValueToken {
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

    if (value == 'null') {
      return null;
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

class StartToken extends PostrestValueToken {
  @override
  String toString() => '{';

  @override
  bool operator ==(Object other) => other is StartToken;

  @override
  int get hashCode => runtimeType.hashCode;
}

class EndToken extends PostrestValueToken {
  @override
  String toString() => '}';

  @override
  bool operator ==(Object other) => other is EndToken;

  @override
  int get hashCode => runtimeType.hashCode;
}

class AssignmentToken extends PostrestValueToken {
  @override
  String toString() => ':';

  @override
  bool operator ==(Object other) => other is AssignmentToken;

  @override
  int get hashCode => runtimeType.hashCode;
}

class SeparatorToken extends PostrestValueToken {
  @override
  String toString() => ',';

  @override
  bool operator ==(Object other) => other is SeparatorToken;

  @override
  int get hashCode => runtimeType.hashCode;
}

class ValueToken extends PostrestValueToken {
  late final dynamic value;
  late final Type _type;
  late final String _valueString;

  @override
  Type? get tokenType => _type;

  ValueToken(String valueString) {
    final parsed = _parseBaseTypes(valueString);
    _type = _getType(parsed);

    value = parsed;
    _valueString = value.toString();
  }

  @override
  dynamic evaluate() => value;

  @override
  String toString() {
    if (_type == String) {
      if (!["'"].contains(_valueString.first) &&
          !["'"].contains(_valueString.last)) {
        return "'$_valueString'";
      }
    }

    return _valueString;
  }

  Type _getType(dynamic value) {
    if (value is int || value is double) {
      return num;
    } else if (value is bool) {
      return bool;
    } else if (value is DateTime) {
      return DateTime;
    } else if (value is String) {
      return String;
    } else if (value == null) {
      return Null;
    } else {
      throw Exception('Invalid type.');
    }
  }

  @override
  bool operator ==(Object other) =>
      other is ValueToken && other._valueString == _valueString;

  @override
  int get hashCode => _valueString.hashCode;
}

class JsonToken extends PostrestValueToken {
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
      } else {
        newData[key] = value;
      }
    });

    return {...newData};
  }

  @override
  String toString() => _jsonString;

  @override
  bool operator ==(Object other) {
    if (other is JsonToken) {
      final thisJson = jsonDecode(_jsonString) as Map<String, dynamic>;
      final otherJson = jsonDecode(other._jsonString) as Map<String, dynamic>;

      return const MapEquality<String, dynamic>().equals(thisJson, otherJson);
    }
    return false;
  }

  @override
  int get hashCode => _jsonString.hashCode;
}

class ListToken extends PostrestValueToken {
  late final List<PostrestValueToken> values;
  late final Type? _type;

  @override
  Type? get tokenType => _type;

  ListToken(List<PostrestValueToken> tokens) {
    if (tokens.isEmpty) {
      _type = null;
      values = [];
      return;
    }

    final sortedTokens = [...tokens];
    _sortEmptyListsLast(sortedTokens);
    final first = sortedTokens.first;
    values = List.from(tokens);

    final typeMismatch = hasTypeMismatch(first);
    if (typeMismatch) {
      throw Exception('Type mismatch in array');
    }

    _type = first.tokenType;
  }

  @override
  dynamic evaluate() {
    final evaluations = [];

    for (PostrestValueToken element in values) {
      evaluations.add(element.evaluate());
    }

    return [...evaluations];
  }

  bool hasTypeMismatch(PostrestValueToken first) {
    if (first is JsonToken) {
      return !values.every((element) {
        if (element is ListToken) {
          return element.hasTypeMismatch(first);
        } else {
          return element is JsonToken;
        }
      });
    }

    return !values.every((element) {
      if (element is ListToken) {
        if (element.tokenType == null) {
          return true;
        }
      }
      return element.tokenType == first.tokenType;
    });
  }

  void _sortEmptyListsLast(List<PostrestValueToken> tokens) {
    tokens.sort((a, b) {
      if (a is ListToken && b is ListToken) {
        if (a.values.isEmpty && b.values.isNotEmpty) {
          return 1;
        } else if (b.values.isEmpty && a.values.isNotEmpty) {
          return -1;
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    });
  }

  @override
  String toString() => values.toString();

  @override
  bool operator ==(Object other) {
    return other is ListToken &&
        const IterableEquality<PostrestValueToken>()
            .equals(values, other.values);
  }

  @override
  int get hashCode => const IterableEquality<PostrestValueToken>().hash(values);
}

// PosrestExpToken is used as token when parsing expressions
abstract class PostrestExpToken {}

class LogicalStart extends PostrestExpToken {
  final PostrestFilterPrecedence precedence;

  LogicalStart({required this.precedence});

  String _precedenceToString() =>
      precedence == PostrestFilterPrecedence.and ? 'and' : 'or';

  @override
  String toString() => '${_precedenceToString()}(';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LogicalStart && other.precedence == precedence;
  }

  @override
  int get hashCode => precedence.hashCode;
}

class LogicalEnd extends PostrestExpToken {
  @override
  String toString() => ')';

  @override
  bool operator ==(Object other) => other is LogicalEnd;

  @override
  int get hashCode => runtimeType.hashCode;
}

class PostrestFilterParams extends PostrestExpToken {
  final String? column;
  final String? filter;
  final String? value;

  bool get isComplete => column != null && filter != null && value != null;
  bool get isEmpty => column == null && filter == null && value == null;

  factory PostrestFilterParams.empty() => PostrestFilterParams();

  PostrestFilterParams({
    this.column,
    this.filter,
    this.value,
  });

  PostrestFilterParams addPartially(String content) {
    if (column == null) {
      return copyWith(column: content);
    } else if (filter == null) {
      return copyWith(filter: content);
    } else {
      return copyWith(value: content);
    }
  }

  List<Map<String, dynamic>> evaluate(
    List<Map<String, dynamic>> data,
  ) {
    final filterBuilder = PostrestSyntaxParser(data).executeFilter(
      column: column!,
      filterName: filter!,
      value: value!,
    );

    return filterBuilder.execute().data;
  }

  PostrestFilterParams copyWith({
    String? column,
    String? filter,
    String? value,
  }) {
    return PostrestFilterParams(
      column: column ?? this.column,
      filter: filter ?? this.filter,
      value: value ?? this.value,
    );
  }

  @override
  String toString() => '$column.$filter.$value';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostrestFilterParams &&
        other.column == column &&
        other.filter == filter &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(column, filter, value);
}

class PostrestFilterTree extends PostrestExpToken {
  final PostrestFilterPrecedence operation;
  final List<PostrestExpToken> children;

  PostrestFilterTree({
    required this.operation,
    List<PostrestExpToken>? childrenNodes,
  }) : children = List.from(childrenNodes ?? []);

  void addChild(PostrestExpToken child) {
    _checkValidChildType(child);
    children.add(child);
    _orderChildrenByPrecedence();
  }

  void addChildren(List<PostrestExpToken> childrenList) {
    final copyChildren = List.from(childrenList);

    for (final child in copyChildren) {
      addChild(child);
    }
  }

  List<Map<String, dynamic>> evaluate(List<Map<String, dynamic>> data) {
    late final List<Map<String, dynamic>> newData = [];

    for (var token in children) {
      late final List<Map<String, dynamic>> result;

      if (token is PostrestFilterParams) {
        result = token.evaluate(data);
      } else if (token is PostrestFilterTree) {
        result = token.evaluate(data);
      } else {
        throw Exception('Invalid expression tree.');
      }

      if (newData.isEmpty) {
        newData.addAll(result);
      } else {
        final finalList = _handleOperation(
          oldData: newData,
          filteredData: result,
          operation: operation,
        );
        newData.clear();
        newData.addAll(finalList);
      }
    }

    return newData;
  }

  List<Map<String, dynamic>> _handleOperation({
    required List<Map<String, dynamic>> oldData,
    required List<Map<String, dynamic>> filteredData,
    required PostrestFilterPrecedence operation,
  }) {
    switch (operation) {
      case PostrestFilterPrecedence.or:
        return _addLists(oldData, filteredData);
      case PostrestFilterPrecedence.and:
        return _getCommonElements(oldData, filteredData);
    }
  }

  List<Map<String, dynamic>> _addLists(
    List<Map<String, dynamic>> list1,
    List<Map<String, dynamic>> list2,
  ) {
    final toAdd = list2
        .where(
          (map1) => !list1.any(
            (map2) => const MapEquality<String, dynamic>().equals(
              map1,
              map2,
            ),
          ),
        )
        .toList();

    list1.addAll(toAdd);
    return List<Map<String, dynamic>>.from(list1);
  }

  List<Map<String, dynamic>> _getCommonElements(
    List<Map<String, dynamic>> list1,
    List<Map<String, dynamic>> list2,
  ) =>
      list1
          .where(
            (map1) => list2.any(
              (map2) => const MapEquality<String, dynamic>().equals(
                map1,
                map2,
              ),
            ),
          )
          .toList();

  void _orderChildrenByPrecedence() {
    children.sort((a, b) {
      final precedence1 = _getOperationPrecedence(a);
      final precedence2 = _getOperationPrecedence(b);

      return precedence1.compareTo(precedence2);
    });
  }

  int _getOperationPrecedence(PostrestExpToken child) {
    if (child is PostrestFilterTree) {
      if (child.operation == PostrestFilterPrecedence.and) {
        return 1;
      } else {
        return 2;
      }
    } else {
      return 3;
    }
  }

  void _checkValidChildType(PostrestExpToken child) {
    if (child is! PostrestFilterParams && child is! PostrestFilterTree) {
      throw Exception(
        'Tokens of type ${child.runtimeType} cannot be added as children of a tree.',
      );
    }
  }

  String _getOperationString() =>
      operation == PostrestFilterPrecedence.and ? 'and' : 'or';

  @override
  String toString() => '${_getOperationString()}(${children.join(', ')})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PostrestFilterTree) return false;

    return operation == other.operation &&
        const DeepCollectionEquality.unordered()
            .equals(children, other.children);
  }

  @override
  int get hashCode => Object.hash(
        operation,
        const DeepCollectionEquality.unordered().hash(children),
      );
}
