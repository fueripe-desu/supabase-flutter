import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
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
        "id": sType<int>(),
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
        "id": sType<int>(),
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
        "id": sType<int>(),
        "title": sType<String>(),
        "deadline": sType<DateTime>(),
      },
    );

    SupabaseTest.createTable(
      'tasks',
      {
        "id": sType<int>(),
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
        "id": sType<int>(),
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
        "id": sType<int>(),
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
        "id": sType<int>(),
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
        "id": sType<int>(),
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
        "id": sType<int>(),
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
        "id": sType<int>(),
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
        "id": sType<int>(),
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
        "id": sType<int>(),
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
        "example": sType<String>(),
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
        "example": sType<int>(),
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
        "example": sType<double>(),
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
        "example": sType<bool>(),
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
        "example": sType<List<String>>(),
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
        "example": sType<Map<String, dynamic>>(),
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
        "example": sType<int?>(),
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
        "example": sType<DateTime>(),
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
        "example": sType<String>(),
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

  test('should hit mock http client endpoint', () async {
    var response = await client.get(Uri.parse('https://www.example.com/'));
    expect(response.body, 'hello world!');
  });
}
