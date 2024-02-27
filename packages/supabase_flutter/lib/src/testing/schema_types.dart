import 'package:supabase_flutter/src/testing/range_type/range_type.dart';

typedef ValidatorFunction = bool Function(dynamic value);

abstract class SchemaType {
  final ForeignKeyInfo? foreignKeyInfo;

  const SchemaType({this.foreignKeyInfo});

  SchemaType copyWith({ForeignKeyInfo? foreignKeyInfo});
  bool call(dynamic value);
}

class IdentitySchemaType extends SchemaType {
  const IdentitySchemaType({this.isPrimary = false, super.foreignKeyInfo});
  final bool isPrimary;

  @override
  IdentitySchemaType copyWith({ForeignKeyInfo? foreignKeyInfo}) {
    return IdentitySchemaType(
      isPrimary: isPrimary,
      foreignKeyInfo: foreignKeyInfo ?? this.foreignKeyInfo,
    );
  }

  @override
  bool call(dynamic value) {
    return true;
  }
}

class UniqueKeySchemaType extends SchemaType {
  const UniqueKeySchemaType(this.validatorFunction,
      {this.isPrimary = false, super.foreignKeyInfo});

  final bool isPrimary;

  final ValidatorFunction validatorFunction;

  @override
  bool call(dynamic value) {
    return validatorFunction(value);
  }

  @override
  UniqueKeySchemaType copyWith({ForeignKeyInfo? foreignKeyInfo}) {
    return UniqueKeySchemaType(
      validatorFunction,
      isPrimary: isPrimary,
      foreignKeyInfo: foreignKeyInfo ?? this.foreignKeyInfo,
    );
  }
}

class ValueSchemaType extends SchemaType {
  const ValueSchemaType(this.validatorFunction, {super.foreignKeyInfo});

  final bool Function(dynamic value) validatorFunction;

  @override
  bool call(dynamic value) {
    return validatorFunction(value);
  }

  @override
  ValueSchemaType copyWith({ForeignKeyInfo? foreignKeyInfo}) {
    return ValueSchemaType(
      validatorFunction,
      foreignKeyInfo: foreignKeyInfo ?? this.foreignKeyInfo,
    );
  }
}

class RangeSchemaType extends SchemaType {
  RangeDataType rangeDataType;

  RangeSchemaType(this.rangeDataType, {super.foreignKeyInfo});

  @override
  bool call(value) {
    try {
      final range = RangeType.createRange(range: value);
      if (range.rangeDataType != rangeDataType) {
        return false;
      }
      return true;
    } catch (err) {
      return false;
    }
  }

  @override
  SchemaType copyWith({ForeignKeyInfo? foreignKeyInfo}) {
    throw Exception(
      'Range values do not support foreign keys, therefore they can\'t be changed.',
    );
  }
}

class ForeignKeyInfo {
  final String tableName;
  final String field;

  const ForeignKeyInfo({
    required this.tableName,
    required this.field,
  });
}
