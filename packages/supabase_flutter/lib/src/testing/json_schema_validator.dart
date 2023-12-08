// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';

import 'package:supabase_flutter/src/testing/supabase_test.dart';

class JsonValidator {
  ValidatorResult validate(
    Map<String, SchemaType> schema,
    SchemaMetadata metadata,
    Map<String, dynamic> jsonContent,
  ) {
    final keyResult = _validateKeys(schema, metadata, jsonContent);

    if (keyResult.isValid == false) {
      return keyResult;
    }

    final valueResult = _validateValues(schema, jsonContent);

    if (valueResult.isValid == false) {
      return valueResult;
    }

    return ValidatorResult(
      message: 'data is valid.',
      isValid: true,
    );
  }

  ValidatorResult validateAll(
    Map<String, SchemaType> schema,
    SchemaMetadata metadata,
    List<Map<String, dynamic>> jsonList,
  ) {
    for (final content in jsonList) {
      final result = validate(schema, metadata, content);

      if (result.isValid == false) {
        return result;
      }
    }

    return ValidatorResult(
      message: 'validation successful. All data is valid.',
      isValid: true,
    );
  }

  ValidatorResult _validateValues(
    Map<String, SchemaType> schema,
    Map<String, dynamic> jsonContent,
  ) {
    final keys = jsonContent.keys;

    for (final key in keys) {
      final value = jsonContent[key];
      final validateFunc = schema[key];

      if (validateFunc == null) {
        return ValidatorResult(
          message: '''
a valid validator function must be passed. 
The error was caused by the schema field: $key''',
          isValid: false,
        );
      }

      if (validateFunc is ValueSchemaType) {
        final result = validateFunc(value);

        if (result == false) {
          return ValidatorResult(
            message:
                'the value \'$value\' is not a valid input for the field \'$key\'.',
            isValid: false,
          );
        }
      }

      if (validateFunc is UniqueKeySchemaType) {
        final result = validateFunc(value);

        if (result == false) {
          ValidatorResult(
            message:
                'the value \'$value\' is not a valid input for the field \'$key\'.',
            isValid: false,
          );
        }

        final isUnique = validateFunc.addValue(value);

        if (isUnique == false) {
          return ValidatorResult(
            message:
                'values in the field \'$key\' must be unique, but \'$value\' is not.',
            isValid: false,
          );
        }
      }
    }

    return ValidatorResult(
      message: 'all values are valid.',
      isValid: true,
    );
  }

  ValidatorResult _validateKeys(
    Map<String, SchemaType> schema,
    SchemaMetadata metadata,
    Map<String, dynamic> jsonContent,
  ) {
    final keys = jsonContent.keys;

    // Verifies if every key passed exists in the schema
    for (final key in keys) {
      final result = _keyExists(key, schema);
      if (result == false) {
        return ValidatorResult(
          message: 'key \'$key\' does not exist in the schema',
          isValid: false,
        );
      }
    }

    final deepEq = const DeepCollectionEquality.unordered().equals;

    // Verifies if any identity field has been set manually
    final identityFields = metadata.identityFields;

    for (final identity in identityFields) {
      if (keys.contains(identity)) {
        return ValidatorResult(
          message: 'identity field \'$identity\' cannot be set manually.',
          isValid: false,
        );
      }
    }

    final keysList = keys.toList();
    final schemaKeys = [...metadata.requiredFields, ...metadata.uniqueKeys];

    final containAllKeys = deepEq(keysList, schemaKeys);
    if (!containAllKeys) {
      return ValidatorResult(
        message: 'schema does not contain all required fields.',
        isValid: false,
      );
    }

    return ValidatorResult(
      message: 'all keys are valid.',
      isValid: true,
    );
  }

  bool _keyExists(
    String key,
    Map<String, SchemaType> schema,
  ) {
    return schema.containsKey(key);
  }
}

class ValidatorResult {
  final String message;
  final bool isValid;

  const ValidatorResult({
    required this.message,
    required this.isValid,
  });
}
