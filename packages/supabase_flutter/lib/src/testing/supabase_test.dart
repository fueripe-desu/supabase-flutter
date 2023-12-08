// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:supabase_flutter/src/constants.dart';
import 'package:supabase_flutter/src/testing/json_schema_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http;

const TEST_URL = "";
const TEST_ANON = "test_anon";

typedef _ValidatorFunction = bool Function(dynamic value);

class SchemaMetadata {
  final List<String> primaryKeys;
  final List<String> identityFields;
  final List<String> uniqueKeys;
  final List<String> requiredFields;

  const SchemaMetadata({
    required this.primaryKeys,
    required this.identityFields,
    required this.uniqueKeys,
    required this.requiredFields,
  });
}

class SupabaseTest {
  factory SupabaseTest.instance() => _shared;
  SupabaseTest._sharedInstance();
  static final SupabaseTest _shared = SupabaseTest._sharedInstance();

  static late String _urlString;
  static late String _urlAnon;
  static late Map<String, Map<String, SchemaType>> _schemas;
  static late Map<String, SchemaMetadata> _schemaMetadata;
  static late Map<String, List<Map<String, dynamic>>> _tables;
  static late JsonValidator _validator;
  static bool _initialized = false;

  static Future<void> initialize() async {
    _urlString = TEST_URL;
    _urlAnon = TEST_ANON;
    _schemas = {};
    _tables = {};
    _validator = JsonValidator();
    _initialized = true;
  }

  static bool get tablesIsEmpty => _schemas.isEmpty;

  static void createTable(
    String tableName,
    Map<String, SchemaType> schema,
  ) {
    if (tableExists(tableName)) {
      throw Exception('Table already exists.');
    }

    if (schema.isEmpty) {
      throw Exception('Schema must not be empty.');
    }

    final List<String> requiredFields = [];
    final List<String> identityFields = [];

    schema.forEach((key, value) {
      if (value is ValueSchemaType) {
        requiredFields.add(key);
      }

      if (value is IdentitySchemaType) {
        identityFields.add(key);
      }
    });

    final metadata = SchemaMetadata(
      primaryKeys: [],
      identityFields: identityFields,
      uniqueKeys: [],
      requiredFields: requiredFields,
    );

    _schemas[tableName] = {};
    _schemaMetadata = {};
    _schemas[tableName] = schema;
    _schemaMetadata[tableName] = metadata;
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

  static List<Map<String, dynamic>> getColumn(
      String tableName, List<String> columns) {
    if (!tableExists(tableName)) {
      throw Exception('Table does not exist.');
    }

    final contents = getTable(tableName);
    final filteredColumns = <Map<String, dynamic>>[];

    for (final row in contents) {
      final filteredRow = <String, dynamic>{};

      for (final column in columns) {
        if (!columnExists(tableName, column)) {
          throw Exception('Column $tableName.$column does not exist.');
        }

        filteredRow[column] = row[column];
      }

      filteredColumns.add(filteredRow);
    }

    return filteredColumns;
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

  static bool columnExists(String tableName, String columnName) {
    if (tableExists(tableName)) {
      return _schemas[tableName]!.containsKey(columnName);
    } else {
      throw Exception('Table does not exist.');
    }
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

  static void deleteTable(String tableName) {
    if (tableExists(tableName)) {
      _tables.remove(tableName);
      _schemas.remove(tableName);
    } else {
      throw Exception('Table does not exist');
    }
  }

  static bool isTableEmpty(String tableName) {
    if (tableExists(tableName)) {
      return _tables[tableName]!.isEmpty;
    } else {
      throw Exception('Table does not exist');
    }
  }

  static int getTableRowCount(String tableName) {
    if (tableExists(tableName)) {
      return _tables[tableName]!.length;
    } else {
      throw Exception('Table does not exist');
    }
  }

  static MockSupabaseClient getClient({
    Map<String, String>? customHeaders,
  }) {
    assert(
      _initialized == true,
      'You must initialize SupabaseTest before calling any of its functions.',
    );

    final httpClient = http.MockClient(
      (request) async {
        final parser = _QueryParser(request.url);
        http.Response res(Object data, int statusCode, String reasonPhrase) {
          final jsonString = jsonEncode(data);
          final res = http.Response(
            jsonString,
            statusCode,
            reasonPhrase: reasonPhrase,
            headers: {
              'Content-Type': 'application/json',
            },
            request: request,
          );

          return res;
        }

        if (parser.mode == 'rest') {
          final select = parser.queryParams['select']!;
          final tableName = parser.table;

          if (!tableExists(tableName)) {
            final error = {
              "code": "42P01",
              "details": null,
              "hint": null,
              "message": "relation \"public.$tableName\" does not exist",
            };

            return res(error, HttpStatus.notFound, "Not Found");
          }

          if (select == '*') {
            final tableContents = _tables[tableName]!;
            return res(tableContents, HttpStatus.ok, "Ok");
          }

          final columns = select.trim().split(",");
          for (final column in columns) {
            final result = columnExists(tableName, column);

            if (result == false) {
              final error = {
                "code": "42703",
                "details": null,
                "hint": null,
                "message": "column $tableName.$column does not exist",
              };
              return res(error, HttpStatus.badRequest, "Bad Request");
            }

            final columnData = getColumn(tableName, columns);
            return res(columnData, HttpStatus.ok, "Ok");
          }
        }

        return http.Response('', HttpStatus.notFound);
      },
    );

    // Set up headers
    final headers = {
      ...Constants.defaultHeaders,
      if (customHeaders != null) ...customHeaders
    };

    final supabaseClient = SupabaseClient(
      _urlString,
      _urlAnon,
      httpClient: httpClient,
      headers: headers,
      storageRetryAttempts: 0,
      realtimeClientOptions: const RealtimeClientOptions(),
      authFlowType: AuthFlowType.implicit,
    );

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
    final metadata = _schemaMetadata[tableName]!;
    final isValid = _validator.validateAll(schema, metadata, contents);

    if (!isValid) {
      throw Exception('Data does not match table schema');
    }

    // Extract identity fields from the schema
    final identityList = metadata.identityFields;
    final identityFields = _extractFromSchema(identityList, schema);

    // Update identity fields in all contents
    for (final data in contents) {
      identityFields.forEach((key, value) {
        if (value is IdentitySchemaType) {
          data[key] = value.initialNumber;
          value.call();
        }
      });
    }

    _tables[tableName]!.addAll(contents);
  }

  static Map<String, SchemaType> _extractFromSchema(
    List<String> fields,
    Map<String, SchemaType> schema,
  ) {
    final Map<String, SchemaType> extractMap = {};

    for (final field in fields) {
      extractMap[field] = schema[field]!;
    }

    return extractMap;
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

abstract class SchemaType {}

class IdentitySchemaType implements SchemaType {
  IdentitySchemaType({this.initialNumber = 0});

  int initialNumber;

  void call() {
    initialNumber = initialNumber + 1;
  }
}

class PrimaryKeySchemaType implements SchemaType {}

class UniqueKeySchemaType<T> implements SchemaType {
  UniqueKeySchemaType(this.validatorFunction);

  final List<T> valuePool = [];
  bool Function(T value) validatorFunction;

  bool addValue(T value) {
    if (valuePool.contains(value)) {
      return false;
    }

    valuePool.add(value);
    return true;
  }

  bool call(T value) {
    return validatorFunction(value);
  }
}

class ValueSchemaType implements SchemaType {
  ValueSchemaType(this.validatorFunction);

  bool Function(dynamic value) validatorFunction;

  bool call(dynamic value) {
    return validatorFunction(value);
  }
}

SchemaType sType<T>({
  bool isNullable = false,
  bool isIdentity = false,
  bool isPrimaryKey = false,
  bool isUnique = false,
}) {
  if (isIdentity) {
    if (T == int) {
      return IdentitySchemaType();
    } else {
      throw Exception('Identity schema fields can only be integers.');
    }
  }

  if (T == DateTime) {
    dtFn(dynamic value) {
      if (T == Null) {
        if (isNullable) {
          return true;
        }
      }

      final dtString = value as String;
      final dt = DateTime.tryParse(dtString);

      return dt != null;
    }

    if (isUnique) {
      return UniqueKeySchemaType<T>(dtFn);
    }

    return ValueSchemaType(dtFn);
  }

  validateFn(dynamic value) {
    if (T == Null) {
      if (isNullable) {
        return true;
      }
    }

    return value is T;
  }

  if (isUnique) {
    return UniqueKeySchemaType<T>(validateFn);
  }

  return ValueSchemaType(validateFn);
}

class _QueryParser {
  final Uri query;
  late final String url;
  late final String mode;
  late final String version;
  late final String table;
  late final Map<String, String> queryParams;

  _QueryParser(this.query) {
    final splitPath = query.path.split('/');
    url = splitPath[0];
    mode = splitPath[1];
    version = splitPath[2];
    table = splitPath[3];

    queryParams = query.queryParameters;
  }
}
