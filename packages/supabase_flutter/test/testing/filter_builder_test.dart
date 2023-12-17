import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/filter_builder.dart';

import '../json/json_reader.dart';

void main() {
  late final List<Map<String, dynamic>> tasks;
  late final bool Function(Object?, Object?) deepEq;

  setUpAll(() {
    final jsonString = readJson('tasks.json');
    final parsedList = json.decode(jsonString) as List<dynamic>;
    tasks = parsedList
        .map((dynamic item) =>
            Map<String, dynamic>.from(item as Map<String, dynamic>))
        .toList();
    deepEq = const DeepCollectionEquality.unordered().equals;
  });
  test('should return only the elements that are equal to the value specified',
      () {
    final result = FilterBuilder(tasks).eq('id', 2).execute();
    expect(deepEq(result, [tasks[2]]), true);
  });

  test(
      'should return only the elements that are equal to one of the values specified',
      () {
    final expectedMap =
        tasks.where((element) => [0, 1, 4].contains(element['id'])).toList();
    final result = FilterBuilder(tasks).eq('id', [0, 1, 4]).execute();
    expect(deepEq(result, expectedMap), true);
  });

  test(
      'should return all the elements that are not equal the condition specified',
      () {
    final expectedMap = tasks.where((element) => element['id'] != 2).toList();
    final expectedMap2 =
        expectedMap.where((element) => element['id'] != 1).toList();

    final result = FilterBuilder(tasks).neq('id', 2).execute();
    final result2 = FilterBuilder(tasks).neq('id', 2).neq('id', 1).execute();

    expect(deepEq(result, expectedMap), true);
    expect(deepEq(result2, expectedMap2), true);
  });

  test(
      'should return all the elements that are not equal to any of the elements of the specified list',
      () {
    final expectedMap =
        tasks.where((element) => ![1, 2].contains(element['id'])).toList();

    final result = FilterBuilder(tasks).neq('id', [1, 2]).execute();

    expect(deepEq(result, expectedMap), true);
  });

  test(
      'should return all the elements that are greater than the value specified',
      () {
    final expectedMap = tasks.where((element) => element['id'] > 1).toList();
    final result = FilterBuilder(tasks).gt('id', 1).execute();

    expect(deepEq(result, expectedMap), true);
  });

  test(
      'should return all the elements that are greater than or equal to the value specified',
      () {
    final expectedMap = tasks.where((element) => element['id'] >= 1).toList();
    final result = FilterBuilder(tasks).gte('id', 1).execute();

    expect(deepEq(result, expectedMap), true);
  });

  test('should return all the elements that are less than the value specified',
      () {
    final expectedMap = tasks.where((element) => element['id'] < 3).toList();
    final result = FilterBuilder(tasks).lt('id', 3).execute();

    expect(deepEq(result, expectedMap), true);
  });

  test(
      'should return all the elements that are less than or equal to the value specified',
      () {
    final expectedMap = tasks.where((element) => element['id'] <= 3).toList();
    final result = FilterBuilder(tasks).lte('id', 3).execute();

    expect(deepEq(result, expectedMap), true);
  });

  group('like and ilike filters tests', () {
    test('should match pattern with %', () {
      const pattern =
          'Meeting%'; // Pattern to match titles starting with 'Meeting'
      final result = FilterBuilder(tasks).ilike('title', pattern).execute();
      expect(
        result,
        [tasks[3]],
      );
    });

    test('should return an exact match pattern', () {
      const pattern = 'Send report to manager'; // Exact title match
      final result = FilterBuilder(tasks).like('title', pattern).execute();
      expect(
        result,
        [tasks[2]],
      );
    });

    test('should match pattern with _', () {
      const pattern =
          'Meeting with team at 1_ AM'; // Matching description pattern
      final result = FilterBuilder(tasks).like('title', pattern).execute();
      expect(
        result,
        [tasks[3]],
      );
    });

    test('should return nothing with non-matching pattern', () {
      const pattern = 'Non-existent Task'; // Non-matching pattern
      final result = FilterBuilder(tasks).like('title', pattern).execute();
      expect(
        result,
        [],
      );
    });
  });

  group('likeAllOf and ilikeAllOf tests', () {
    test('should return filtered data for matching patterns', () {
      final result = FilterBuilder(tasks)
          .likeAllOf('title', ['Send%', '%manager']).execute();
      expect(deepEq(result, [tasks[2]]), true);
    });

    test('should return empty list for non-matching patterns', () {
      final result = FilterBuilder(tasks)
          .likeAllOf('description', ['unknown', 'invalid']).execute();
      expect(result.isEmpty, true);
    });

    test('should return filtered data with case-insensitive matching', () {
      final expectedMap =
          tasks.where((element) => [0, 2, 5].contains(element['id'])).toList();
      final result =
          FilterBuilder(tasks).ilikeAllOf('status', ['%PENDING%']).execute();
      expect(deepEq(result, expectedMap), true);
    });

    test('should return filtered data with exact matches', () {
      final result = FilterBuilder(tasks)
          .likeAllOf('deadline', ['2024-01-12T08:00:00Z']).execute();

      expect(deepEq(result, [tasks[3]]), true);
    });

    test('should return no data when no patterns provided', () {
      final result = FilterBuilder(tasks).likeAllOf('title', []).execute();
      expect(result.isEmpty, true);
    });
  });

  group('likeAnyOf and ilikeAnyOf tests', () {
    test('should return filtered data for matching patterns', () {
      final result = FilterBuilder(tasks).ilikeAnyOf(
          'title', ['Send%', '%presentation%', '%project']).execute();
      expect(deepEq(result, [tasks[1], tasks[2], tasks[4]]), true);
    });

    test('should return empty list for non-matching patterns', () {
      final result = FilterBuilder(tasks)
          .likeAnyOf('description', ['unknown', 'invalid']).execute();
      expect(result.isEmpty, true);
    });

    test('should return data for partial matches', () {
      final result = FilterBuilder(tasks)
          .ilikeAnyOf('title', ['%TASK%', 'Unknown']).execute();

      expect(deepEq(result, [tasks[0]]), true);
    });

    test('should return filtered data with exact matches', () {
      final result = FilterBuilder(tasks).likeAnyOf('deadline',
          ['2024-01-12T08:00:00Z', '2024-01-14T08:00:00Z']).execute();

      expect(deepEq(result, [tasks[3], tasks[5]]), true);
    });

    test('should return no data when no patterns provided', () {
      final result = FilterBuilder(tasks).ilikeAnyOf('title', []).execute();
      expect(result.isEmpty, true);
    });
  });
}
