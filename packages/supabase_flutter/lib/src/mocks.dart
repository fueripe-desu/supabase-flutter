// ignore_for_file: constant_identifier_names

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
  static late Map<String, Map<String, dynamic>> _schemas;
  static late Map<String, List<Map<String, dynamic>>> _tables;
  static bool _initialized = false;

  static Future<void> initialize() async {
    _urlString = TEST_URL;
    _urlAnon = TEST_ANON;
    _schemas = {};
    _tables = {};
    _initialized = true;
  }

  static void createTable(
    String tableName,
    Map<String, dynamic> schema,
  ) {
    _createTable(tableName, schema);
  }

  static List<String> getTableNames() {
    return _schemas.keys.toList();
  }

  static bool tableExists(String tableName) {
    return _schemas.containsKey(tableName);
  }

  static List<Map<String, dynamic>> getTable(String tableName) {
    if (tableExists(tableName)) {
      return _tables[tableName]!;
    } else {
      throw Exception('Table does not exist.');
    }
  }

  static void clear() {
    _schemas.clear();
    _tables.clear();
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

  static void _createTable(
    String tableName,
    Map<String, dynamic> schema,
  ) {
    if (tableExists(tableName)) {
      throw Exception('Table already exists.');
    }

    _schemas[tableName] = {};
    _schemas[tableName] = schema;
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

_ValidatorFunction sType<T>() {
  if (T is DateTime) {
    return (dynamic value) {
      final dtString = value as String;
      final dt = DateTime.tryParse(dtString);

      return dt != null;
    };
  }

  if (T is DateTime?) {
    return (dynamic value) {
      final dtString = value as String?;

      if (dtString == null) {
        return true;
      }

      final dt = DateTime.tryParse(dtString);

      return dt != null;
    };
  }

  return (dynamic value) {
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

    return true;
  }

  bool _keyExists(
    String key,
    Map<String, _ValidatorFunction> schema,
  ) {
    return schema.containsKey(key);
  }
}
