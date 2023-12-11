typedef _ValidatorFunction = bool Function(dynamic value);

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

  final _ValidatorFunction validatorFunction;

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

class ForeignKeyInfo {
  final String tableName;
  final String field;

  const ForeignKeyInfo({
    required this.tableName,
    required this.field,
  });
}
