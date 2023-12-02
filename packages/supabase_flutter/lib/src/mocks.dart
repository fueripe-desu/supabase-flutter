// ignore_for_file: constant_identifier_names

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

const TEST_URL = "test_url";
const TEST_ANON = "test_anon";

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
