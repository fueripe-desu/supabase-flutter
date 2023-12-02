// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

const TEST_URL = "test_url";
const TEST_ANON = "test_anon";

typedef _ValidatorFunction = bool Function(dynamic value);

class SupabaseTest {
  factory SupabaseTest.instance() => _shared;
  SupabaseTest._sharedInstance();
  static final SupabaseTest _shared = SupabaseTest._sharedInstance();

  static late String _urlString;
  static late String _urlAnon;
  static late Map<String, Map<String, _ValidatorFunction>> _schemas;
  static late Map<String, List<Map<String, dynamic>>> _tables;
  static late _JsonValidator _validator;
  static bool _initialized = false;

  static Future<void> initialize() async {
    _urlString = TEST_URL;
    _urlAnon = TEST_ANON;
    _schemas = {};
    _tables = {};
    _validator = _JsonValidator();
    _initialized = true;
  }

  static bool get tablesIsEmpty => _schemas.isEmpty;

  static void createTable(
    String tableName,
    Map<String, _ValidatorFunction> schema,
  ) {
    if (tableExists(tableName)) {
      throw Exception('Table already exists.');
    }

    if (schema.isEmpty) {
      throw Exception('Schema must not be empty.');
    }

    _schemas[tableName] = {};
    _schemas[tableName] = schema;
    _tables[tableName] = [];
  }

  static List<String> getTableNames() {
    return _schemas.keys.toList();
  }

  static bool tableExists(String tableName) {
    return _schemas.containsKey(tableName);
  }

  static List<Map<String, dynamic>> getTable(String tableName) {
    if (tableExists(tableName)) {
      return [..._tables[tableName]!];
    } else {
      throw Exception('Table does not exist.');
    }
  }

  static void insertData(
    String tableName,
    List<Map<String, dynamic>> contents,
  ) {
    _insertData(tableName, contents);
  }

  static void insertDataFromJson(String tableName, String jsonString) {
    final parsedList = json.decode(jsonString) as List<dynamic>;
    final contents = parsedList
        .map((dynamic item) =>
            Map<String, dynamic>.from(item as Map<String, dynamic>))
        .toList();

    _insertData(tableName, contents);
  }

  static void clear() {
    _schemas.clear();
    _tables.clear();
  }

  static void clearTable(String tableName) {
    if (tableExists(tableName)) {
      _tables[tableName]!.clear();
    } else {
      throw Exception('Table does not exist.');
    }
  }

  static MockSupabaseClient getClient() {
    assert(
      _initialized == true,
      'You must initialize SupabaseTest before calling any of its functions.',
    );

    final supabaseClient = SupabaseClient(_urlString, _urlAnon);
    final httpClient = http.Client();

    return MockSupabaseClient(supabaseClient, httpClient);
  }

  static void _insertData(
    String tableName,
    List<Map<String, dynamic>> contents,
  ) {
    if (!tableExists(tableName)) {
      throw Exception('Table does not exist.');
    }

    final schema = _schemas[tableName]!;
    final isValid = _validator.validateAll(schema, contents);

    if (!isValid) {
      throw Exception('Data does not match table schema');
    }

    _tables[tableName]!.addAll(contents);
  }
}

class MockSupabaseClient {
  final SupabaseClient _supabaseClient;
  final http.Client _httpClient;

  MockSupabaseClient(
    SupabaseClient supabaseClient,
    http.Client httpClient,
  )   : _supabaseClient = supabaseClient,
        _httpClient = httpClient;

  SupabaseClient get supabaseClient => _supabaseClient;

  Future<void> dispose() async {
    _supabaseClient.dispose();
    _httpClient.close();
  }
}

_ValidatorFunction sType<T>({bool isNullable = false}) {
  if (T == DateTime) {
    return (dynamic value) {
      if (T == Null) {
        if (isNullable) {
          return true;
        }
      }

      final dtString = value as String;
      final dt = DateTime.tryParse(dtString);

      return dt != null;
    };
  }

  return (dynamic value) {
    if (T == Null) {
      if (isNullable) {
        return true;
      }
    }

    return value is T;
  };
}

class _JsonValidator {
  bool validate(
    Map<String, _ValidatorFunction> schema,
    Map<String, dynamic> jsonContent,
  ) {
    final isKeyValid = _validateKeys(schema, jsonContent);

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
    Map<String, _ValidatorFunction> schema,
    List<Map<String, dynamic>> jsonList,
  ) {
    for (final content in jsonList) {
      final result = validate(schema, content);

      if (result == false) {
        return false;
      }
    }

    return true;
  }

  bool _validateValues(
    Map<String, _ValidatorFunction> schema,
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

      final result = validateFunc(value);

      if (result == false) {
        return false;
      }
    }

    return true;
  }

  bool _validateKeys(
    Map<String, _ValidatorFunction> schema,
    Map<String, dynamic> jsonContent,
  ) {
    final keys = jsonContent.keys;

    for (final key in keys) {
      final result = _keyExists(key, schema);
      if (result == false) {
        return false;
      }
    }

    final deepEq = const DeepCollectionEquality.unordered().equals;

    final keysList = keys.toList();
    final schemaKeys = schema.keys.toList();

    final containAllKeys = deepEq(keysList, schemaKeys);
    if (!containAllKeys) {
      return false;
    }

    return true;
  }

  bool _keyExists(
    String key,
    Map<String, _ValidatorFunction> schema,
  ) {
    return schema.containsKey(key);
  }
}
