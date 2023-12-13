import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/schema_types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http;

import 'json/json_reader.dart';

void main() {
  late http.Client client;

  setUpAll(() async {
    SupabaseTest.initialize();

    client = http.MockClient((request) async {
      if (request.url == Uri.parse('https://www.example.com/')) {
        return http.Response('hello world!', 200);
      }
      return http.Response('', 404);
    });
  });
  test('should initialize and close without timeout', () async {
    final client = SupabaseTest.getClient();
    await client.dispose();
  });

  tearDown(() {
    SupabaseTest.clear();
  });

  test('should create a table', () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    // act
    final tableExists = SupabaseTest.tableExists('todos');

    // assert
    expect(tableExists, true);
  });

  test(
      'should throw an Exception when two tables with the same name are created',
      () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    // assert
    expect(
      () => SupabaseTest.createTable(
        'todos',
        {
          "id": sType<int>(),
          "title": sType<String>(),
          "deadline": sType<DateTime>(),
        },
      ),
      throwsException,
    );
  });

  test('should throw an Exception when table is created with an empty schema',
      () {
    expect(
      () => SupabaseTest.createTable(
        'todos',
        {},
      ),
      throwsException,
    );
  });

  test('should return all table names', () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    SupabaseTest.createTable(
      'tasks',
      {
        "id": sType<int>(isPrimaryKey: true),
        "description": sType<String>(),
        "created_at": sType<DateTime>(),
      },
    );

    final deepEq = const DeepCollectionEquality.unordered().equals;

    // act
    final tableNames = SupabaseTest.getTableNames();

    // assert
    expect(deepEq(tableNames, ['todos', 'tasks']), true);
  });

  test(
      'should return an empty list when trying to get all table names without any tables registered',
      () {
    // act
    final tableNames = SupabaseTest.getTableNames();

    // assert
    expect(tableNames.isEmpty, true);
  });

  test('should return true checking if table exists', () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    // act
    final tableExists = SupabaseTest.tableExists('todos');

    // assert
    expect(tableExists, true);
  });

  test('should return false checking if table exists', () {
    // act
    final tableExists = SupabaseTest.tableExists('uknown');

    // assert
    expect(tableExists, false);
  });

  test('should return the table\'s content', () {
    // arrange

    final jsonString = readJson('tasks.json');

    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "description": sType<String>(),
        "status": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    SupabaseTest.insertDataFromJson(
      'todos',
      jsonString,
    );

    final parsedList = json.decode(jsonString) as List<dynamic>;
    final expectedMap = parsedList
        .map((dynamic item) =>
            Map<String, dynamic>.from(item as Map<String, dynamic>))
        .toList();

    final deepEq = const DeepCollectionEquality.unordered().equals;

    // act
    final tableContents = SupabaseTest.getTable('todos');

    // assert
    expect(deepEq(tableContents, expectedMap), true);
  });

  test('should return an empty list when table has no contents', () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "description": sType<String>(),
        "status": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    // act
    final tableContents = SupabaseTest.getTable('todos');

    // assert
    expect(tableContents.isEmpty, true);
  });

  test('should insert data into a table', () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "description": sType<String>(),
        "status": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    final expectedMap = [
      {
        "id": 1,
        "title": "Complete presentation slides",
        "description": "This is the task description for task 1",
        "status": "in-progress",
        "deadline": "2024-01-15T08:00:00Z"
      },
      {
        "id": 2,
        "title": "Send report to manager",
        "description": "This is the task description for task 2",
        "status": "pending",
        "deadline": "2024-01-20T08:00:00Z"
      },
    ];

    SupabaseTest.insertData(
      'todos',
      expectedMap,
    );

    final deepEq = const DeepCollectionEquality.unordered().equals;

    // act
    final tableContents = SupabaseTest.getTable('todos');

    // assert
    expect(deepEq(tableContents, expectedMap), true);
  });

  test('should return an exception when accessing an unexistent table', () {
    // assert
    expect(() => SupabaseTest.getTable('todos'), throwsException);
  });

  test(
      'should throw an Exception when trying to insert data to an unexisting table',
      () {
    expect(
      () => SupabaseTest.insertData(
        'unknown',
        [
          {
            "id": 1,
            "title": "Complete presentation slides",
            "description": "This is the task description for task 1",
            "status": "in-progress",
            "deadline": "2024-01-15T08:00:00Z",
          },
        ],
      ),
      throwsException,
    );
  });

  test(
      'should throw an Exception when trying to insert data that does not match the table schema',
      () {
    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "description": sType<String>(),
        "status": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    expect(
      () => SupabaseTest.insertData(
        'todos',
        [
          {
            "id": 1,
          }
        ],
      ),
      throwsException,
    );
  });

  test('should insert data into a table from Json', () {
    // arrange

    final jsonString = readJson('tasks.json');

    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "description": sType<String>(),
        "status": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    SupabaseTest.insertDataFromJson(
      'todos',
      jsonString,
    );

    final parsedList = json.decode(jsonString) as List<dynamic>;
    final expectedMap = parsedList
        .map((dynamic item) =>
            Map<String, dynamic>.from(item as Map<String, dynamic>))
        .toList();

    final deepEq = const DeepCollectionEquality.unordered().equals;

    // act
    final tableContents = SupabaseTest.getTable('todos');

    // assert
    expect(deepEq(tableContents, expectedMap), true);
  });

  test('should clear tables from SupabaseTest', () {
    // arrange

    final jsonString = readJson('tasks.json');

    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "description": sType<String>(),
        "status": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    SupabaseTest.insertDataFromJson(
      'todos',
      jsonString,
    );

    // act
    final isEmpty = SupabaseTest.tablesIsEmpty;

    SupabaseTest.clear();

    final clearIsEmpty = SupabaseTest.tablesIsEmpty;

    // assert
    expect(isEmpty, false);
    expect(clearIsEmpty, true);
  });

  test('should clear a table', () {
    // arrange

    final jsonString = readJson('tasks.json');

    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "description": sType<String>(),
        "status": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    SupabaseTest.insertDataFromJson(
      'todos',
      jsonString,
    );

    // act
    final tableContents = SupabaseTest.getTable('todos');

    SupabaseTest.clearTable('todos');

    final clearTableContents = SupabaseTest.getTable('todos');

    // assert
    expect(tableContents.isNotEmpty, true);
    expect(clearTableContents.isEmpty, true);
  });

  test('should validate correctly the string schema type', () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "example": sType<String>(isPrimaryKey: true),
      },
    );

    final expectedMap = [
      {
        "example": "test string",
      },
    ];

    SupabaseTest.insertData(
      'todos',
      expectedMap,
    );

    final deepEq = const DeepCollectionEquality.unordered().equals;

    // act
    final tableContents = SupabaseTest.getTable('todos');

    // assert
    expect(deepEq(tableContents, expectedMap), true);
  });

  test('should validate correctly the int schema type', () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "example": sType<int>(isPrimaryKey: true),
      },
    );

    final expectedMap = [
      {
        "example": 1,
      },
    ];

    SupabaseTest.insertData(
      'todos',
      expectedMap,
    );

    final deepEq = const DeepCollectionEquality.unordered().equals;

    // act
    final tableContents = SupabaseTest.getTable('todos');

    // assert
    expect(deepEq(tableContents, expectedMap), true);
  });

  test('should validate correctly the double schema type', () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "example": sType<double>(isPrimaryKey: true),
      },
    );

    final expectedMap = [
      {
        "example": 1.0,
      },
    ];

    SupabaseTest.insertData(
      'todos',
      expectedMap,
    );

    final deepEq = const DeepCollectionEquality.unordered().equals;

    // act
    final tableContents = SupabaseTest.getTable('todos');

    // assert
    expect(deepEq(tableContents, expectedMap), true);
  });

  test('should validate correctly the bool schema type', () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "example": sType<bool>(isPrimaryKey: true),
      },
    );

    final expectedMap = [
      {
        "example": true,
      },
    ];

    SupabaseTest.insertData(
      'todos',
      expectedMap,
    );

    final deepEq = const DeepCollectionEquality.unordered().equals;

    // act
    final tableContents = SupabaseTest.getTable('todos');

    // assert
    expect(deepEq(tableContents, expectedMap), true);
  });

  test('should validate correctly the list schema type', () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "example": sType<List<String>>(isPrimaryKey: true),
      },
    );

    final expectedMap = [
      {
        "example": ['example1', 'example2', 'example3'],
      },
    ];

    SupabaseTest.insertData(
      'todos',
      expectedMap,
    );

    final deepEq = const DeepCollectionEquality.unordered().equals;

    // act
    final tableContents = SupabaseTest.getTable('todos');

    // assert
    expect(deepEq(tableContents, expectedMap), true);
  });

  test('should validate correctly the map schema type', () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "example": sType<Map<String, dynamic>>(isPrimaryKey: true),
      },
    );

    final expectedMap = [
      {
        "example": {
          "id": 5,
          "title": "Prepare for client demo",
          "description": "This is the task description for task 5",
          "status": "pending",
          "deadline": "2024-01-14T08:00:00Z"
        },
      },
    ];

    SupabaseTest.insertData(
      'todos',
      expectedMap,
    );

    final deepEq = const DeepCollectionEquality.unordered().equals;

    // act
    final tableContents = SupabaseTest.getTable('todos');

    // assert
    expect(deepEq(tableContents, expectedMap), true);
  });

  test('should validate correctly the null schema type', () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "example": sType<int?>(isPrimaryKey: true),
      },
    );

    final expectedMap = [
      {
        "example": null,
      },
    ];

    SupabaseTest.insertData(
      'todos',
      expectedMap,
    );

    final deepEq = const DeepCollectionEquality.unordered().equals;

    // act
    final tableContents = SupabaseTest.getTable('todos');

    // assert
    expect(deepEq(tableContents, expectedMap), true);
  });

  test('should validate correctly the DateTime schema type', () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "example": sType<DateTime>(isPrimaryKey: true),
      },
    );

    final expectedMap = [
      {
        "example": "2024-01-14T08:00:00Z",
      },
    ];

    SupabaseTest.insertData(
      'todos',
      expectedMap,
    );

    final deepEq = const DeepCollectionEquality.unordered().equals;

    // act
    final tableContents = SupabaseTest.getTable('todos');

    // assert
    expect(deepEq(tableContents, expectedMap), true);
  });

  test('should delete a table', () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "example": sType<String>(isPrimaryKey: true),
      },
    );

    // act
    final tableExistsBefore = SupabaseTest.tableExists('todos');

    SupabaseTest.deleteTable('todos');

    final tableExistsAfter = SupabaseTest.tableExists('todos');

    // assert
    expect(tableExistsBefore, true);
    expect(tableExistsAfter, false);
  });

  test('should throw an Exception when trying to delete an unexistent table',
      () {
    expect(
      () => SupabaseTest.deleteTable('unknown'),
      throwsException,
    );
  });

  test('should return true when checking if column exists', () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "column1": sType<String>(isPrimaryKey: true),
      },
    );

    // act
    final result = SupabaseTest.columnExists('todos', 'column1');

    // assert
    expect(result, true);
  });

  test('should return false when calling columnExists() on a unexistent column',
      () {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "column1": sType<String>(isPrimaryKey: true),
      },
    );

    // act
    final result = SupabaseTest.columnExists('todos', 'uknown');

    // assert
    expect(result, false);
  });

  test(
      'should throw an Exception when calling columnExists() with an unknown table',
      () {
    expect(
      () => SupabaseTest.columnExists('unknown', 'column1'),
      throwsException,
    );
  });

  test('should get only the desired columns from the table', () async {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "description": sType<String>(),
        "status": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    final dataMap = [
      {
        "id": 1,
        "title": "Complete presentation slides",
        "description": "This is the task description for task 1",
        "status": "in-progress",
        "deadline": "2024-01-15T08:00:00Z"
      },
      {
        "id": 2,
        "title": "Send report to manager",
        "description": "This is the task description for task 2",
        "status": "pending",
        "deadline": "2024-01-20T08:00:00Z"
      },
    ];

    final expectedMap = dataMap
        .map((e) => {
              "title": e['title'],
              "description": e['description'],
            })
        .toList();

    SupabaseTest.insertData(
      'todos',
      dataMap,
    );

    final deepEq = const DeepCollectionEquality.unordered().equals;

    final data = SupabaseTest.getColumn('todos', ['title', 'description']);

    expect(deepEq(data, expectedMap), true);
  });

  test(
      'should throw an Exception when trying to get columns from an unknown table',
      () async {
    expect(
      () => SupabaseTest.getColumn('unknown', ['name', 'age']),
      throwsException,
    );
  });

  test(
      'should throw an Exception when calling getColumn() with an unknown column',
      () async {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
      },
    );

    final dataMap = [
      {
        "id": 1,
        "title": "Complete presentation slides",
      },
    ];

    SupabaseTest.insertData(
      'todos',
      dataMap,
    );

    expect(
      () => SupabaseTest.getColumn('todos', ['title', 'unkown']),
      throwsException,
    );
  });

  test('should update the identity field ID automatically', () async {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true, isIdentity: true),
        "title": sType<String>(),
      },
    );

    final expectedMap = [
      {
        "id": 0,
        "title": "Complete presentation slides",
      },
      {
        "id": 1,
        "title": "Send report to manager",
      },
      {
        "id": 2,
        "title": "Prepare for client demo",
      },
    ];

    SupabaseTest.insertData('todos', [
      {"title": "Complete presentation slides"},
      {"title": "Send report to manager"},
      {"title": "Prepare for client demo"}
    ]);

    final deepEq = const DeepCollectionEquality.unordered().equals;

    final client = SupabaseTest.getClient();

    final data = await client.supabaseClient.from('todos').select('*');

    expect(deepEq(data, expectedMap), true);

    await client.dispose();
  });

  test('should throw an Exception when trying to set identity field manually',
      () async {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true, isIdentity: true),
        "title": sType<String>(),
      },
    );

    expect(
      () => SupabaseTest.insertData('todos', [
        {
          "id": 2,
          "title": "Complete presentation slides",
        },
      ]),
      throwsException,
    );
  });

  test(
      'should throw an Exception when creating an identity field with other type than int',
      () async {
    // arrange
    expect(
        () => SupabaseTest.createTable(
              'todos',
              {
                "id": sType<String>(isIdentity: true),
                "title": sType<String>(),
              },
            ),
        throwsException);
  });

  test('should return only the desired columns with from().select()', () async {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "description": sType<String>(),
        "status": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    final dataMap = [
      {
        "id": 1,
        "title": "Complete presentation slides",
        "description": "This is the task description for task 1",
        "status": "in-progress",
        "deadline": "2024-01-15T08:00:00Z"
      },
      {
        "id": 2,
        "title": "Send report to manager",
        "description": "This is the task description for task 2",
        "status": "pending",
        "deadline": "2024-01-20T08:00:00Z"
      },
    ];

    final expectedMap = dataMap
        .map((e) => {
              "title": e['title'],
              "description": e['description'],
            })
        .toList();

    SupabaseTest.insertData(
      'todos',
      dataMap,
    );

    final deepEq = const DeepCollectionEquality.unordered().equals;

    // act
    final client = SupabaseTest.getClient();

    final data =
        await client.supabaseClient.from('todos').select('title, description');

    // assert
    expect(deepEq(data, expectedMap), true);

    await client.dispose();
  });

  test(
      'should throw an Exception when calling from().select(\'*\') on a unknown table',
      () async {
    // act
    final client = SupabaseTest.getClient();

    expect(
      () async => await client.supabaseClient.from('uknown').select('*'),
      throwsException,
    );

    await client.dispose();
  });

  test('should enforce uniqueness in a schema field marked with isUnique',
      () async {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true, isIdentity: true),
        "title": sType<String>(isUnique: true),
      },
    );

    expect(
      () => SupabaseTest.insertData('todos', [
        {"title": "Complete presentation slides"},
        {"title": "Complete presentation slides"},
      ]),
      throwsException,
    );
  });

  test('should ensure that unique fields are required', () async {
    // arrange
    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true, isIdentity: true),
        "online": sType<bool>(),
        "title": sType<String>(isUnique: true),
      },
    );

    expect(
      () => SupabaseTest.insertData('todos', [
        {"online": true},
      ]),
      throwsException,
    );
  });

  test(
      'should return an exception when calling fKey() with an invalid relation string',
      () {
    expect(() => fKey('todosid)'), throwsException);
  });

  test(
      'should return a ForeignKeySchemaType when called with a valid relation string',
      () {
    final foreignKey = fKey('todos(id)');
    expect(foreignKey, isA<SchemaType>());
  });

  test('should throw an Exception when foreign key references an unknown table',
      () {
    expect(
      () => SupabaseTest.createTable(
        'users',
        {
          "id": sType<int>(isPrimaryKey: true, isIdentity: true),
          "username": sType<String>(isUnique: true),
          "current_task": fKey("unknown(id)"),
        },
      ),
      throwsException,
    );
  });

  test(
      'should throw an Exception when foreign key references an unknown column',
      () {
    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "description": sType<String>(),
        "status": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    expect(
      () => SupabaseTest.createTable(
        'users',
        {
          "id": sType<int>(isPrimaryKey: true, isIdentity: true),
          "username": sType<String>(isUnique: true),
          "current_task": fKey("todos(unknown)"),
        },
      ),
      throwsException,
    );
  });

  test(
      'should throw an Exception when the foreign key\'s value type does not match the table referenced',
      () {
    final jsonString = readJson('tasks.json');

    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "description": sType<String>(),
        "status": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    SupabaseTest.createTable(
      'users',
      {
        "id": sType<int>(isPrimaryKey: true, isIdentity: true),
        "username": sType<String>(isUnique: true),
        "current_task": fKey("todos(id)"),
      },
    );

    SupabaseTest.insertDataFromJson(
      'todos',
      jsonString,
    );

    expect(
      () => SupabaseTest.insertData('users', [
        {
          "username": "user1",
          "current_task": "wrong_type",
        },
      ]),
      throwsException,
    );
  });

  test('should successfuly create a foreign key relation', () {
    // arrange

    final jsonString = readJson('tasks.json');

    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "description": sType<String>(),
        "status": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    SupabaseTest.createTable(
      'users',
      {
        "id": sType<int>(isPrimaryKey: true, isIdentity: true),
        "username": sType<String>(isUnique: true),
        "current_task": fKey("todos(id)"),
      },
    );

    SupabaseTest.insertDataFromJson(
      'todos',
      jsonString,
    );

    SupabaseTest.insertData('users', [
      {
        "username": "user1",
        "current_task": 1,
      },
    ]);
  });

  test("should successfuly fetch with identity foreign key", () async {
    final jsonString = readJson('tasks.json');

    final expectedMap = [
      {
        'username': 'user1',
        'current_task': {
          'title': 'New Task Title',
          'description': 'New Task Description'
        }
      },
      {
        'username': 'user2',
        'current_task': {
          'title': 'Complete presentation slides',
          'description': 'This is the task description for task 1'
        }
      },
      {
        'username': 'user3',
        'current_task': {
          'title': 'Send report to manager',
          'description': 'This is the task description for task 2'
        }
      }
    ];

    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "description": sType<String>(),
        "status": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    SupabaseTest.createTable(
      'users',
      {
        "id": sType<int>(isPrimaryKey: true, isIdentity: true),
        "username": sType<String>(isUnique: true),
        "current_task": fKey("todos(id)", isIdentity: true),
      },
    );

    SupabaseTest.insertDataFromJson(
      'todos',
      jsonString,
    );

    SupabaseTest.insertData('users', [
      {"username": "user1"},
      {"username": "user2"},
      {"username": "user3"},
    ]);

    final deepEq = const DeepCollectionEquality.unordered().equals;

    final client = SupabaseTest.getClient();

    final data = await client.supabaseClient.from('users').select('''
    username,
    current_task (
      title,
      description
    )
  ''');

    expect(deepEq(data, expectedMap), true);

    await client.dispose();
  });

  test("should fetch specific fields from foreign key", () async {
    final jsonString = readJson('tasks.json');

    final expectedMap = [
      {
        'username': 'user1',
        'current_task': {
          'title': 'Complete presentation slides',
          'description': 'This is the task description for task 1'
        }
      },
      {
        'username': 'user2',
        'current_task': {
          'title': 'Send report to manager',
          'description': 'This is the task description for task 2'
        }
      },
      {
        'username': 'user3',
        'current_task': {
          'title': 'Meeting with team at 10 AM',
          'description': 'This is the task description for task 3'
        }
      }
    ];

    SupabaseTest.createTable(
      'todos',
      {
        "id": sType<int>(isPrimaryKey: true),
        "title": sType<String>(),
        "description": sType<String>(),
        "status": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    SupabaseTest.createTable(
      'users',
      {
        "id": sType<int>(isPrimaryKey: true, isIdentity: true),
        "username": sType<String>(isUnique: true),
        "current_task": fKey("todos(id)"),
      },
    );

    SupabaseTest.insertDataFromJson(
      'todos',
      jsonString,
    );

    SupabaseTest.insertData('users', [
      {
        "username": "user1",
        "current_task": 1,
      },
      {
        "username": "user2",
        "current_task": 2,
      },
      {
        "username": "user3",
        "current_task": 3,
      },
    ]);

    final deepEq = const DeepCollectionEquality.unordered().equals;

    final client = SupabaseTest.getClient();

    final data = await client.supabaseClient.from('users').select('''
    username,
    current_task (
      title,
      description
    )
  ''');

    expect(deepEq(data, expectedMap), true);

    await client.dispose();
  });

  test('should hit mock http client endpoint', () async {
    var response = await client.get(Uri.parse('https://www.example.com/'));
    expect(response.body, 'hello world!');
  });
}
