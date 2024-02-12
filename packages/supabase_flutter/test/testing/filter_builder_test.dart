import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/filter_builder.dart';

import '../json/json_reader.dart';

void main() {
  late final List<Map<String, dynamic>> tasks;
  late final List<Map<String, dynamic>> reservations;
  late final List<Map<String, dynamic>> users;
  late final List<Map<String, dynamic>> issues;
  late final bool Function(Object?, Object?) deepEq;

  List<Map<String, dynamic>> loadJson(String jsonName) {
    final jsonString = readJson(jsonName);
    final parsedList = json.decode(jsonString) as List<dynamic>;
    return parsedList
        .map((dynamic item) =>
            Map<String, dynamic>.from(item as Map<String, dynamic>))
        .toList();
  }

  setUpAll(() {
    tasks = loadJson('tasks.json');
    reservations = loadJson('reservations.json');
    deepEq = const DeepCollectionEquality.unordered().equals;

    users = [
      {
        'id': 1,
        'name': 'Michael',
        'address': {"postcode": 90210, "street": "Melrose Place"},
      },
      {
        'id': 2,
        'name': 'Jane',
        'address': {},
      },
    ];

    issues = [
      {
        'id': 1,
        'title': 'Cache invalidation is not working',
        'tags': ['is:open', 'severity:high', 'priority:low'],
      },
      {
        'id': 2,
        'title': 'Use better names',
        'tags': ['is:open', 'severity:low', 'priority:medium'],
      },
    ];
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

  group('contains tests', () {
    test('should match all rows that are within the range', () {
      final result = FilterBuilder(reservations)
          .contains('during', '[2000-01-01 13:00, 2000-01-01 13:30)')
          .execute();

      expect(deepEq(result, [reservations[0]]), true);
    });

    test(
        'should correctly carry out comparisons between inclusive and exclusive ends',
        () {
      final data = [
        {
          "id": 1,
          "room_name": "Emerald",
          "during": "[2000-01-01 13:00, 2000-01-01 15:00)"
        }
      ];

      // So, in the last bracket, it's a comparison between exclusive (filter) and
      // exclusive (data), so it must return true
      final result1 = FilterBuilder(data)
          .contains('during', '[2000-01-01 13:00, 2000-01-01 15:00)')
          .execute();

      // So, in the last bracket, it's a comparison between inclusive (filter) and
      // exclusive (data), so it must return false
      final result2 = FilterBuilder(data)
          .contains('during', '[2000-01-01 13:00, 2000-01-01 15:00]')
          .execute();

      // So, in the first bracket, it's a comparison between exclusive (filter) and
      // inclusive (data), so it must return true
      final result3 = FilterBuilder(data)
          .contains('during', '(2000-01-01 13:00, 2000-01-01 15:00)')
          .execute();

      // So, in the first bracket, it's a comparison between inclusive (filter) and
      // inclusive (data), so it must return true
      final result4 = FilterBuilder(reservations)
          .contains('during', '[2000-01-01 13:00, 2000-01-01 15:00)')
          .execute();

      expect(deepEq(result1, [reservations[0]]), true);
      expect(result2.isEmpty, true);
      expect(deepEq(result3, [reservations[0]]), true);
      expect(deepEq(result4, [reservations[0]]), true);
    });

    test('should return rows that contains every element specified', () {
      final expectedMap =
          tasks.where((element) => [0, 2, 5].contains(element['id'])).toList();

      final result =
          FilterBuilder(tasks).contains('status', ['pending']).execute();

      expect(deepEq(result, expectedMap), true);
    });

    test(
        'should return rows that contains every element when a list is specified',
        () {
      final result = FilterBuilder(issues)
          .contains('tags', ['is:open', 'priority:low']).execute();

      expect(deepEq(result, [issues[0]]), true);
    });

    test('should return rows that contains every element in the specified map',
        () {
      final result = FilterBuilder(users)
          .contains('address', {"postcode": 90210}).execute();

      expect(deepEq(result, [users[0]]), true);
    });

    test(
        'should throw an Exception when using contains with a map on a field that is not a map',
        () {
      expect(
        () => FilterBuilder(tasks).contains('id', {"unknown": null}).execute(),
        throwsException,
      );
    });
  });

  group('containedBy tests', () {
    test('should return all rows that are contained by the specified range',
        () {
      final expectedMap = reservations
          .where((element) => [1, 2, 3].contains(element['id']))
          .toList();

      final result = FilterBuilder(reservations)
          .containedBy('during', '[2000-01-01 00:00, 2000-01-03 23:59)')
          .execute();

      expect(
        deepEq(result, expectedMap),
        true,
      );
    });

    test('should return all rows that are contained by the specified list', () {
      final classes = [
        {
          'id': 1,
          'name': 'Chemistry',
          'days': ['monday', 'friday'],
        },
        {
          'id': 2,
          'name': 'History',
          'days': ['monday', 'wednesday', 'thursday'],
        },
      ];

      final result = FilterBuilder(classes).containedBy(
          'days', ['monday', 'tuesday', 'wednesday', 'friday']).execute();

      expect(deepEq(result, [classes[0]]), true);
    });

    test(
        'should return all rows that are contained by the specified list on a column that is not a list',
        () {
      final expectedMap = tasks.where((element) => element['id'] != 3).toList();

      final result = FilterBuilder(tasks)
          .containedBy('status', ['pending', 'in-progress']).execute();

      expect(deepEq(result, expectedMap), true);
    });

    test('should return all rows that are contained by the specified map', () {
      final result = FilterBuilder(users).containedBy(
          'address', {"postcode": 90210, "street": "Melrose Place"}).execute();

      expect(deepEq(result, users), true);
    });

    test('should works as expected with empty maps', () {
      final result = FilterBuilder(users).containedBy('address', {}).execute();

      expect(deepEq(result, [users[1]]), true);
    });
  });

  group('range comparison filters tests', () {
    test('should return all rows that are greater than the range specified',
        () {
      final expectedMap =
          reservations.where((element) => element['id'] != 1).toList();
      final result = FilterBuilder(reservations)
          .rangeGt('during', '[2000-01-02 08:00, 2000-01-02 09:00)')
          .execute();

      expect(deepEq(result, expectedMap), true);
    });

    test(
        'should return all rows that are greater than or equal to the range specified',
        () {
      final expectedMap =
          reservations.where((element) => element['id'] != 1).toList();
      final result = FilterBuilder(reservations)
          .rangeGte('during', '[2000-01-02 08:30, 2000-01-02 09:30)')
          .execute();

      expect(deepEq(result, expectedMap), true);
    });

    test('should return all rows that are less than the range specified', () {
      final result = FilterBuilder(reservations)
          .rangeLt('during', '[2000-01-02 08:30, 2000-01-02 09:30)')
          .execute();

      expect(deepEq(result, [reservations[0]]), true);
    });

    test(
        'should return all rows that are less than or equal to the range specified',
        () {
      final result = FilterBuilder(reservations)
          .rangeLte('during', '[2000-01-02 08:30, 2000-01-02 09:30)')
          .execute();

      expect(deepEq(result, [reservations[0]]), true);
    });
  });

  test('should return all rows that are adjacent to the specified range', () {
    final result = FilterBuilder(reservations)
        .rangeAdjacent('during', '[2000-01-01 12:00, 2000-01-01 13:00)')
        .execute();

    expect(result, [reservations[0]]);
  });

  test('should return all rows that overlaps the specified range', () {
    final result = FilterBuilder(reservations)
        .overlaps('during', '[2000-01-01 12:45, 2000-01-01 13:15)')
        .execute();

    expect(result, [reservations[0]]);
  });

  test(
      'should return all rows that have element in common with the specified list',
      () {
    final result = FilterBuilder(issues)
        .overlaps('tags', ['is:closed', 'severity:high']).execute();

    expect(result, [issues[0]]);
  });

  test('should return all rows that matches with the text search', () {
    final result = FilterBuilder(tasks)
        .textSearch('title', 'complete <-> presentation')
        .execute();

    expect(result, [tasks[1]]);
  });

  test('shoud match all the conditions specified', () {
    final countries = [
      {'id': 1, 'name': 'Afghanistan'},
      {'id': 2, 'name': 'Albania'},
      {'id': 3, 'name': 'Algeria'},
    ];

    final result =
        FilterBuilder(countries).match({'id': 2, 'name': 'Albania'}).execute();

    expect(result, [countries[1]]);
  });
}
