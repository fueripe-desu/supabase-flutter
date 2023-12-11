class SchemaMetadata {
  final List<String> primaryKeys;
  final List<String> identityFields;
  final List<String> uniqueKeys;
  final List<String> requiredFields;
  final List<String> foreignKeys;

  final Map<String, int> _identityValues;
  final Map<String, List<dynamic>> _uniqueValuePools;

  const SchemaMetadata({
    required this.primaryKeys,
    required this.identityFields,
    required this.uniqueKeys,
    required this.requiredFields,
    required this.foreignKeys,
    Map<String, int> identityValues = const {},
    Map<String, List<dynamic>> uniqueValuePools = const {},
  })  : _identityValues = identityValues,
        _uniqueValuePools = uniqueValuePools;

  factory SchemaMetadata.init({
    required List<String> primaryKeys,
    required List<String> identityFields,
    required List<String> uniqueKeys,
    required List<String> requiredFields,
    required List<String> foreignKeys,
  }) {
    // Intialize identity values for all fields
    final Map<String, int> identityValues = {};
    for (final identity in identityFields) {
      identityValues[identity] = 0;
    }

    // Intialize unique value pools for all fields
    final Map<String, List<dynamic>> uniqueValuePools = {};
    for (final unique in uniqueKeys) {
      uniqueValuePools[unique] = <dynamic>[];
    }

    return SchemaMetadata(
      primaryKeys: primaryKeys,
      identityFields: identityFields,
      uniqueKeys: uniqueKeys,
      requiredFields: requiredFields,
      foreignKeys: foreignKeys,
      identityValues: identityValues,
      uniqueValuePools: uniqueValuePools,
    );
  }

  void incrementIdentity(String field) {
    if (!identityFields.contains(field)) {
      throw Exception(
        'Can\'t update identity because field \'$field\' doesn not exist.',
      );
    }
    final current = _identityValues[field]!;
    _identityValues[field] = current + 1;
  }

  bool addUniqueValue(String field, dynamic value) {
    if (!uniqueKeys.contains(field)) {
      throw Exception(
        'Unique field \'$field\' does not exist.',
      );
    }

    if (isUnique(field, value)) {
      _uniqueValuePools[field]!.add(value);
      return true;
    }

    return false;
  }

  bool isUnique(String field, dynamic value) {
    if (!uniqueKeys.contains(field)) {
      throw Exception(
        'Unique field \'$field\' does not exist.',
      );
    }
    return !_uniqueValuePools[field]!.contains(value);
  }

  int getIdentity(String field) {
    if (!identityFields.contains(field)) {
      throw Exception(
        'Can\'t update identity because field \'$field\' doesn not exist.',
      );
    }

    return _identityValues[field]!;
  }
}
