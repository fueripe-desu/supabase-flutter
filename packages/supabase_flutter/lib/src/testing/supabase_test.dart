// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:supabase_flutter/src/constants.dart';
import 'package:supabase_flutter/src/testing/json_schema_validator.dart';
import 'package:supabase_flutter/src/testing/schema_metadata.dart';
import 'package:supabase_flutter/src/testing/schema_types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http;

const TEST_URL = "";
const TEST_ANON = "test_anon";

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
    _schemaMetadata = {};
    _tables = {};
    _validator = JsonValidator();
    _initialized = true;
  }

  static bool get tablesIsEmpty => _schemas.isEmpty;

  static void createTable(String tableName, Map<String, SchemaType> schema) {
    if (tableExists(tableName)) {
      throw Exception('Table already exists.');
    }

    if (schema.isEmpty) {
      throw Exception('Schema must not be empty.');
    }

    final List<String> requiredFields = [];
    final List<String> identityFields = [];
    final List<String> uniqueKeys = [];
    final List<String> primaryKeys = [];
    final List<String> foreignKeys = [];

    schema.forEach((key, value) {
      if (value is ValueSchemaType) {
        if (value.foreignKeyInfo != null) {
          foreignKeys.add(key);
        }
        requiredFields.add(key);
      }

      if (value is IdentitySchemaType) {
        if (value.isPrimary) {
          primaryKeys.add(key);
        }
        if (value.foreignKeyInfo != null) {
          foreignKeys.add(key);
        }
        identityFields.add(key);
      }

      if (value is UniqueKeySchemaType) {
        if (value.isPrimary) {
          primaryKeys.add(key);
        }
        if (value.foreignKeyInfo != null) {
          foreignKeys.add(key);
        }
        requiredFields.add(key);
        uniqueKeys.add(key);
      }
    });

    if (primaryKeys.isEmpty) {
      throw Exception('schema must have at least one primary key.');
    }

    // Check for foreign key's error at creation time
    for (final fk in foreignKeys) {
      final value = schema[fk]!;
      final tableName = value.foreignKeyInfo!.tableName;
      final column = value.foreignKeyInfo!.field;

      // Checks if the table referenced by the foreign key exists
      if (!tableExists(tableName)) {
        throw Exception(
          'Table \'$tableName\' referenced by foreign key $fk does not exist.',
        );
      }

      // Checks if the column referenced by the foreign key exists
      if (!columnExists(tableName, column)) {
        throw Exception(
          'Column \'$column\' referenced by foreign key $fk does not exist.',
        );
      }
    }

    final metadata = SchemaMetadata.init(
      primaryKeys: primaryKeys,
      foreignKeys: foreignKeys,
      identityFields: identityFields,
      uniqueKeys: uniqueKeys,
      requiredFields: requiredFields,
    );

    _schemas[tableName] = {};
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

    final fieldsToExtract = _schemaMetadata[tableName]!.requiredFields;
    List<Map<String, dynamic>> filteredContents = contents.map((map) {
      return {for (var field in fieldsToExtract) field: map[field]};
    }).toList();

    _insertData(tableName, filteredContents);
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

  static List<T> getTableColumnData<T>(String tableName, String field) {
    final table = _tables[tableName];
    final values = table!.map((task) => task[field] as T).toList();
    return values;
  }

  static void _checkForeignKey({
    required SchemaType schemaType,
    required String foreignKeyName,
    required SchemaMetadata metadata,
    dynamic valueToMatchAgainst,
  }) {
    final foreignTableName = schemaType.foreignKeyInfo!.tableName;
    final foreignField = schemaType.foreignKeyInfo!.field;

    final exception = Exception(
      '''Foreign key '$foreignKeyName' must reference a value in the 
                table '$foreignTableName.$foreignField'. 
                But the value does not exist.''',
    );

    if (schemaType is IdentitySchemaType) {
      final columnData =
          getTableColumnData<int>(foreignTableName, foreignField);
      final identityNum = metadata.getIdentity(foreignKeyName);

      if (!columnData.contains(identityNum)) {
        throw exception;
      }
    }

    if (schemaType is UniqueKeySchemaType) {
      final validatorFunction = _schemas[foreignTableName]![foreignField]!;
      final result = validatorFunction(valueToMatchAgainst);

      if (!result) {
        throw Exception(
          '''Value '$valueToMatchAgainst' in foreign key '$foreignKeyName' does 
          not match the type of '$foreignTableName.$foreignField\'''',
        );
      }

      final columnData = getTableColumnData(foreignTableName, foreignField);

      if (!columnData.contains(valueToMatchAgainst)) {
        throw exception;
      }
    }

    if (schemaType is ValueSchemaType) {
      final validatorFunction = _schemas[foreignTableName]![foreignField]!;
      final result = validatorFunction(valueToMatchAgainst);

      if (!result) {
        throw Exception(
          '''Value '$valueToMatchAgainst' in foreign key '$foreignKeyName' does 
          not match the type of '$foreignTableName.$foreignField\'''',
        );
      }

      final columnData = getTableColumnData(foreignTableName, foreignField);

      if (!columnData.contains(valueToMatchAgainst)) {
        throw exception;
      }
    }
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
    final validatorResult = _validator.validateAll(schema, metadata, contents);

    if (validatorResult.isValid == false) {
      throw Exception(validatorResult.message);
    }

    // Extract identity fields from the schema
    final identityList = metadata.identityFields;
    final requiredList = metadata.requiredFields;
    final fieldsToExtract = [...identityList, ...requiredList];
    final updateFields = _extractFromSchema(fieldsToExtract, schema);

    // Update identity fields in all contents
    for (final data in contents) {
      updateFields.forEach((field, value) {
        if (value is IdentitySchemaType) {
          if (value.foreignKeyInfo != null) {
            _checkForeignKey(
              schemaType: value,
              foreignKeyName: field,
              metadata: metadata,
            );
          }
          data[field] = metadata.getIdentity(field);
          metadata.incrementIdentity(field);
        }

        if (value is UniqueKeySchemaType) {
          if (value.foreignKeyInfo != null) {
            _checkForeignKey(
              schemaType: value,
              foreignKeyName: field,
              metadata: metadata,
              valueToMatchAgainst: data[field],
            );
          }
          final uniqueField = data[field];
          metadata.addUniqueValue(field, uniqueField);
        }

        if (value is ValueSchemaType) {
          if (value.foreignKeyInfo != null) {
            _checkForeignKey(
              schemaType: value,
              foreignKeyName: field,
              metadata: metadata,
              valueToMatchAgainst: data[field],
            );
          }
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

SchemaType fKey(
  String relation, {
  bool isNullable = false,
  bool isIdentity = false,
  bool isUnique = false,
  bool isPrimaryKey = false,
}) {
  // Checks if string is formatted like: tablename(field)
  RegExp regex = RegExp(r'^([a-zA-Z_]+)\(([a-zA-Z_]+)\)$');

  if (!regex.hasMatch(relation)) {
    throw Exception(
      'relation must match the pattern \'tablename(field)\'. You\'ve inputted: \'$relation\'',
    );
  }

  final Iterable<RegExpMatch> allMatches = regex.allMatches(relation);
  final RegExpMatch match = allMatches.first;
  final String tableName = match.group(1)!;
  final String field = match.group(2)!;

  final foreignKeyInfo = ForeignKeyInfo(
    tableName: tableName,
    field: field,
  );

  SchemaType schemaType = sType(
    isNullable: isNullable,
    isPrimaryKey: isPrimaryKey,
    isUnique: isUnique,
    isIdentity: isIdentity,
  );

  final newSchema = schemaType.copyWith(foreignKeyInfo: foreignKeyInfo);

  return newSchema;
}

SchemaType sType<T>({
  bool isNullable = false,
  bool isIdentity = false,
  bool isPrimaryKey = false,
  bool isUnique = false,
}) {
  if (isIdentity) {
    if (T == int) {
      return IdentitySchemaType(isPrimary: isPrimaryKey);
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

    if (isUnique || isPrimaryKey) {
      return UniqueKeySchemaType(dtFn, isPrimary: isPrimaryKey);
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

  if (isUnique || isPrimaryKey) {
    return UniqueKeySchemaType(validateFn, isPrimary: isPrimaryKey);
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
