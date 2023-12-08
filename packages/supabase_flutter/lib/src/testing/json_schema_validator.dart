// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';

import 'package:supabase_flutter/src/testing/supabase_test.dart';

class JsonValidator {
  bool validate(
    Map<String, SchemaType> schema,
    SchemaMetadata metadata,
    Map<String, dynamic> jsonContent,
  ) {
    final isKeyValid = _validateKeys(schema, metadata, jsonContent);

    if (!isKeyValid) {
      return false;
    }

    final isValueValid = _validateValues(schema, jsonContent);

    if (!isValueValid) {
      return false;
    }

    return true;
  }

  bool validateAll(
    Map<String, SchemaType> schema,
    SchemaMetadata metadata,
    List<Map<String, dynamic>> jsonList,
  ) {
    for (final content in jsonList) {
      final result = validate(schema, metadata, content);

      if (result == false) {
        return false;
      }
    }

    return true;
  }

  bool _validateValues(
    Map<String, SchemaType> schema,
    Map<String, dynamic> jsonContent,
  ) {
    final keys = jsonContent.keys;

    for (final key in keys) {
      final value = jsonContent[key];
      final validateFunc = schema[key];

      if (validateFunc == null) {
        throw Exception(
          '''
A valid validator function must be passed. 
The error was caused by the schema field: $key''',
        );
      }

      if (validateFunc is ValueSchemaType) {
        final result = validateFunc(value);

        if (result == false) {
          return false;
        }
      }

      if (validateFunc is IdentitySchemaType) {
        return true;
      }

      if (validateFunc is UniqueKeySchemaType) {
        final result = validateFunc(value);

        if (result == false) {
          return false;
        }

        final isUnique = validateFunc.addValue(value);

        if (isUnique == false) {
          throw Exception('Values in the field $key must be unique.');
        }
      }
    }

    return true;
  }

  bool _validateKeys(
    Map<String, SchemaType> schema,
    SchemaMetadata metadata,
    Map<String, dynamic> jsonContent,
  ) {
    final keys = jsonContent.keys;

    // Verifies if every key passed exists in the schema
    for (final key in keys) {
      final result = _keyExists(key, schema);
      if (result == false) {
        return false;
      }
    }

    final deepEq = const DeepCollectionEquality.unordered().equals;

    // Verifies if any identity field has been set manually
    final identityFields = metadata.identityFields;

    for (final identity in identityFields) {
      if (keys.contains(identity)) {
        throw Exception('Identity fields cannot be set manually.');
      }
    }

    final keysList = keys.toList();
    final schemaKeys = [...metadata.requiredFields, ...metadata.uniqueKeys];

    final containAllKeys = deepEq(keysList, schemaKeys);
    if (!containAllKeys) {
      return false;
    }

    return true;
  }

  bool _keyExists(
    String key,
    Map<String, SchemaType> schema,
  ) {
    return schema.containsKey(key);
  }
}
