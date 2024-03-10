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

  FilterCastResult cast(
    dynamic baseValue,
    dynamic castValue, {
    bool baseAsArrayCaster = false,
  }) {
    _castValue = castValue;
    _baseValue = baseValue;

    return _cast(baseAsArrayCaster);
  }

  FilterCastResult _cast(bool baseAsArrayCaster) {
    _parseValues();

    if (_baseValue is String && !baseAsArrayCaster) {
      if (_baseValue.runtimeType != _castValue.runtimeType) {
        return _castToString();
      }
    } else if (_baseValue is double && !baseAsArrayCaster) {
      if (_canCastToFloat()) {
        return _castToFloat();
      }
    } else if (_baseValue is Map && !baseAsArrayCaster) {
      if (_baseValue.runtimeType != _castValue.runtimeType) {
        return _castToString();
      }
    } else if (_baseValue is RangeType && !baseAsArrayCaster) {
      if (_canCastToRange()) {
        return _castToRange();
      }
    }

    if (_baseValue is List && _castValue is List) {
      if (!_isHomogeneousList(_baseValue)) {
        return FilterCastResult(
          wasSucessful: false,
          baseValue: _baseValue,
          castValue: _castValue,
        );
      }

      if (!_isHomogeneousList(_castValue)) {
        return FilterCastResult(
          wasSucessful: false,
          baseValue: _baseValue,
          castValue: _castValue,
        );
      }

      if (_baseValue.isNotEmpty && _castValue.isNotEmpty) {
        final rawBaseValue = _baseValue.first.runtimeType;
        final rawCastValue = _castValue.first.runtimeType;

        if (rawBaseValue != rawCastValue) {
          _recursivelyCastListElements();
        }

        final baseValue = _baseValue.first.runtimeType;
        final castValue = _castValue.first.runtimeType;

        return FilterCastResult(
          wasSucessful: baseValue == castValue,
          baseValue: _baseValue,
          castValue: _castValue,
        );
      }
    }

    if (baseAsArrayCaster && _baseValue is! List && _castValue is List) {
      _recursivelyCastListElements();
    }

    return FilterCastResult(
      wasSucessful: _calculateSuccess(baseAsArrayCaster),
      baseValue: _baseValue,
      castValue: _castValue,
    );
  }

  bool _calculateSuccess(bool baseAsArrayCaster) {
    if (baseAsArrayCaster) {
      if (_castValue is! List || _baseValue is List) {
        return false;
      }

      if (_castValue.isEmpty) {
        return true;
      } else {
        return _isHomogeneousList(_castValue) &&
            _castValue.first.runtimeType == _baseValue.runtimeType;
      }
    } else {
      return _baseValue.runtimeType == _castValue.runtimeType;
    }
  }

  void _recursivelyCastListElements() {
    final List newCastList = [];
    final dynamic firstBase =
        _baseValue is List ? _baseValue.first : _baseValue;
    final FilterTypeCaster localCaster = FilterTypeCaster();

    for (final element in _castValue) {
      final castValue = localCaster.cast(firstBase, element);
      newCastList.add(castValue.castValue);
    }

    _castValue.clear();
    _castValue = [...newCastList];

    if (firstBase is Map && _castValue.first is String) {
      if (_baseValue is List) {
        _baseValue = (_baseValue as List).map((e) => e.toString()).toList();
      } else {
        _baseValue = _baseValue.toString();
      }
    }
  }

  void _parseValues() {
    final bool isBaseListOfRange = _baseValue is List &&
        _baseValue.isNotEmpty &&
        _baseValue.first is RangeType;

    final bool isCastListOfRange = _castValue is List &&
        _castValue.isNotEmpty &&
        _castValue.first is RangeType;

    if (_castValue is! RangeType && !isCastListOfRange) {
      if (_castValue is List) {
        _castValue = (_castValue as List).convertToPostgresArray();
      }
      _castValue = _parser.parseValue(
        _castValue.toString(),
        allowDartLists: true,
      );
    }

    if (_baseValue is! RangeType && !isBaseListOfRange) {
      if (_baseValue is List) {
        _baseValue = (_baseValue as List).convertToPostgresArray();
      }
      _baseValue = _parser.parseValue(
        _baseValue.toString(),
        allowDartLists: true,
      );
    }
  }

  bool _isHomogeneousList(List list) {
    if (list.isEmpty) {
      return true;
    }

    final type = list.first.runtimeType;

    return list.every((element) => element.runtimeType == type);
  }

  bool _canCastToRange() {
    try {
      RangeType.createRange(range: _castValue.toString());
      return true;
    } catch (err) {
      return false;
    }
  }

  bool _canCastToFloat() => double.tryParse(_castValue.toString()) != null;

  FilterCastResult _castToFloat() => FilterCastResult(
        baseValue: _baseValue,
        castValue: _castValue is double
            ? _castValue
            : double.tryParse(_castValue.toString()),
      );

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
