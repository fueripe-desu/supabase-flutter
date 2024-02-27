import 'package:supabase_flutter/src/testing/postgrest/supabase_test_postgrest.dart';
import 'package:supabase_flutter/src/testing/range_type/range_type.dart';

extension on List {
  String convertToPostgresArray() {
    final List<String> elementStringStack = [];

    for (final element in this) {
      if (element is List) {
        elementStringStack.add(element.convertToPostgresArray());
      } else {
        elementStringStack.add(element.toString());
      }
    }

    return '{${elementStringStack.join(',')}}';
  }
}

class FilterTypeCaster {
  final PostrestSyntaxParser _parser = PostrestSyntaxParser([]);
  dynamic _baseValue;
  dynamic _castValue;

  FilterCastResult cast(dynamic baseValue, dynamic castValue) {
    _castValue = castValue;
    _baseValue = baseValue;

    return _cast();
  }

  FilterCastResult _cast() {
    _parseValues();

    if (_baseValue is String) {
      if (_baseValue.runtimeType != _castValue.runtimeType) {
        return _castToString();
      }
    } else if (_baseValue is Map) {
      if (_baseValue.runtimeType != _castValue.runtimeType) {
        return _castToString();
      }
    } else if (_baseValue is RangeType) {
      if (_canCastToRange()) {
        return _castToRange();
      }
    }

    return FilterCastResult(
      wasSucessful: _baseValue.runtimeType == _castValue.runtimeType,
      baseValue: _baseValue,
      castValue: _castValue,
    );
  }

  void _parseValues() {
    if (_castValue is! RangeType) {
      if (_castValue is List) {
        _castValue = (_castValue as List).convertToPostgresArray();
      }
      _castValue = _parser.parseValue(
        _castValue.toString(),
        allowDartLists: true,
      );
    }

    if (_baseValue is! RangeType) {
      if (_baseValue is List) {
        _baseValue = (_baseValue as List).convertToPostgresArray();
      }
      _baseValue = _parser.parseValue(
        _baseValue.toString(),
        allowDartLists: true,
      );
    }
  }

  bool _canCastToRange() {
    try {
      RangeType.createRange(range: _castValue.toString());
      return true;
    } catch (err) {
      return false;
    }
  }

  FilterCastResult _castToRange() => FilterCastResult(
        baseValue: _baseValue,
        castValue: _castValue is RangeType
            ? _castValue
            : RangeType.createRange(range: _castValue.toString()),
      );

  FilterCastResult _castToString() => FilterCastResult(
        baseValue: _baseValue.toString(),
        castValue: _castValue.toString(),
      );
}

class FilterCastResult {
  final bool wasSucessful;
  final dynamic baseValue;
  final dynamic castValue;

  const FilterCastResult({
    this.wasSucessful = true,
    required this.baseValue,
    required this.castValue,
  });
}
