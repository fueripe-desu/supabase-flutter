import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/postgrest/supabase_test_postgrest.dart';

import '../../json/json_reader.dart';

List<Map<String, dynamic>> _loadJson(String jsonName) {
  final jsonString = readJson(jsonName);
  final parsedList = json.decode(jsonString) as List<dynamic>;
  return parsedList
      .map((dynamic item) =>
          Map<String, dynamic>.from(item as Map<String, dynamic>))
      .toList();
}

void main() {
  late final List<Map<String, dynamic>> tasks;
  late final List<Map<String, dynamic>> reservations;
  late final List<Map<String, dynamic>> books;
  late final List<Map<String, dynamic>> exactEquality;
  late final List<Map<String, dynamic>> issues;
  late final List<Map<String, dynamic>> users;
  late final bool Function(Object?, Object?) deepEq;

  late final List<Map<String, dynamic>> Function(
    List<Map<String, dynamic>> table,
    List<int> ids,
  ) getRowByIds;

  setUpAll(() {
    tasks = _loadJson('tasks.json');
    reservations = _loadJson('reservations.json');
    books = _loadJson('books.json');
    exactEquality = _loadJson('exact_equality.json');
    issues = _loadJson('issues.json');
    users = _loadJson('users.json');
    deepEq = const DeepCollectionEquality.unordered().equals;

    getRowByIds = (table, ids) =>
        table.where((element) => ids.contains(element['id'])).toList();
  });

  group('filter execution', () {
    late final bool Function(
      List<Map<String, dynamic>> data,
      String column,
      String filter,
      dynamic value,
      List<Map<String, dynamic>> compareList,
    ) compare;

    setUpAll(() {
      compare = (data, column, filter, value, compareList) {
        final filteredData = PostrestSyntaxParser(data)
            .executeFilter(column: column, filterName: filter, value: value)
            .execute();

        return deepEq(filteredData, compareList);
      };
    });

    test('should throw an Exception when executing an unknown filter', () {
      expect(
        () => compare(tasks, 'status', 'unknown', '"completed"', []),
        throwsException,
      );
    });

    test('should throw an Exception when executing an unknown modifier', () {
      expect(
        () => compare(tasks, 'status', 'eq(unknown)', '"completed"', []),
        throwsException,
      );
    });

    test('should be able to execute an \'eq\' filter', () {
      final expectedMap = getRowByIds(tasks, [3]);
      expect(compare(tasks, 'status', 'eq', '"completed"', expectedMap), true);
    });

    test('should be able to execute an \'gt\' filter', () {
      final expectedMap = getRowByIds(tasks, [4, 5]);
      expect(compare(tasks, 'id', 'gt', '3', expectedMap), true);
    });

    test('should be able to execute an \'gte\' filter', () {
      final expectedMap = getRowByIds(tasks, [3, 4, 5]);
      expect(compare(tasks, 'id', 'gte', '3', expectedMap), true);
    });

    test('should be able to execute an \'lt\' filter', () {
      final expectedMap = getRowByIds(tasks, [0, 1, 2]);
      expect(compare(tasks, 'id', 'lt', '3', expectedMap), true);
    });

    test('should be able to execute an \'lte\' filter', () {
      final expectedMap = getRowByIds(tasks, [0, 1, 2, 3]);
      expect(compare(tasks, 'id', 'lte', '3', expectedMap), true);
    });

    test('should be able to execute an \'neq\' filter', () {
      final expectedMap = getRowByIds(tasks, [0, 2, 3, 5]);
      expect(compare(tasks, 'status', 'neq', 'in-progress', expectedMap), true);
    });

    test('should be able to execute an \'like\' filter', () {
      final expectedMap = getRowByIds(tasks, [3]);
      expect(compare(tasks, 'title', 'like', 'Meeting%', expectedMap), true);
    });

    test('should be able to execute an \'ilike\' filter', () {
      expect(
        compare(books, 'title', 'ilike', '%little%', [books[0], books[17]]),
        true,
      );
    });

    test('should be able to execute an \'isdistinct\' filter', () {
      final expectedMap = getRowByIds(exactEquality, [1, 2, 4, 5]);
      expect(
        compare(exactEquality, 'value', 'isdistinct', 'null', expectedMap),
        true,
      );
    });

    test('should be able to execute an \'in\' filter', () {
      final expectedMap = getRowByIds(tasks, [1, 3]);
      expect(
        compare(
          tasks,
          'deadline',
          'in',
          '("2024-01-15T08:00:00Z", "2024-01-12T08:00:00Z")',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'is\' filter', () {
      final expectedMap = getRowByIds(exactEquality, [3, 6]);
      expect(compare(exactEquality, 'value', 'is', 'null', expectedMap), true);
    });

    test('should be able to execute an \'fts\' filter', () {
      expect(
        compare(books, 'description', 'fts', "'boy' & 'monsters'", [books[4]]),
        true,
      );
    });

    test('should be able to execute an \'plfts\' filter', () {
      expect(
        compare(books, 'title', 'plfts', 'The Giving Tree.', [books[9]]),
        true,
      );
    });

    test('should be able to execute an \'phfts\' filter', () {
      expect(
        compare(books, 'title', 'phfts', 'The Giving Tree.', [books[9]]),
        true,
      );
    });

    test('should be able to execute an \'wfts\' filter', () {
      expect(
        compare(
          books,
          'description',
          'wfts',
          'boy and "land of monsters"',
          [books[4]],
        ),
        true,
      );
    });

    test('should be able to execute an \'cs\' filter (array)', () {
      final expectedMap = getRowByIds(issues, [1, 5, 7]);
      expect(
        compare(
          issues,
          'tags',
          'cs',
          '{"is:open", "severity:high"}',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'cs\' filter (range)', () {
      final expectedMap = getRowByIds(reservations, [1]);
      expect(
        compare(
          reservations,
          'during',
          'cs',
          '[2000-01-01 13:00, 2000-01-01 13:30)',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'cs\' filter (jsonb)', () {
      final expectedMap = getRowByIds(users, [1]);
      expect(
        compare(
          users,
          'address',
          'cs',
          '{"street": "Melrose Place"}',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'cd\' filter (array)', () {
      final expectedMap = getRowByIds(issues, [1, 7]);
      expect(
        compare(
          issues,
          'tags',
          'cd',
          '{"is:open", "severity:high", "priority:low", "priority:medium"}',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'cd\' filter (range)', () {
      final expectedMap = getRowByIds(reservations, [1, 2, 3]);
      expect(
        compare(
          reservations,
          'during',
          'cd',
          '[2000-01-01 00:00, 2000-01-03 23:59)',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'cd\' filter (jsonb)', () {
      final expectedMap = getRowByIds(users, [1, 2]);
      expect(
        compare(
          users,
          'address',
          'cd',
          '{"postcode": "90210", "street": "Melrose Place"}',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'gt\' filter (range)', () {
      final expectedMap = getRowByIds(reservations, [2, 3, 4, 5, 6, 7, 8]);
      expect(
        compare(
          reservations,
          'during',
          'gt',
          '[2000-01-02 08:00, 2000-01-02 09:00)',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'gte\' filter (range)', () {
      final expectedMap = getRowByIds(reservations, [2, 3, 4, 5, 6, 7, 8]);
      expect(
        compare(
          reservations,
          'during',
          'gte',
          '[2000-01-02 08:30, 2000-01-02 09:30)',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'lt\' filter (range)', () {
      final expectedMap = getRowByIds(reservations, [1]);
      expect(
        compare(
          reservations,
          'during',
          'lt',
          '[2000-01-01 15:00, 2000-01-01 16:00)',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'lte\' filter (range)', () {
      final expectedMap = getRowByIds(reservations, [1]);
      expect(
        compare(
          reservations,
          'during',
          'lte',
          '[2000-01-01 15:00, 2000-01-01 16:00)',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'adj\' filter', () {
      final expectedMap = getRowByIds(reservations, [1]);
      expect(
        compare(
          reservations,
          'during',
          'adj',
          '[2000-01-01 12:00, 2000-01-01 13:00)',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'ov\' filter', () {
      final expectedMap = getRowByIds(reservations, [1]);
      expect(
        compare(
          reservations,
          'during',
          'ov',
          '[2000-01-01 12:45, 2000-01-01 13:15)',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'sl\' filter', () {
      final expectedMap = getRowByIds(reservations, [1, 2]);
      expect(
        compare(
          reservations,
          'during',
          'sl',
          '[2000-01-03 18:00, 2000-01-03 20:00)',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'sr\' filter', () {
      final expectedMap = getRowByIds(reservations, [7, 8]);
      expect(
        compare(
          reservations,
          'during',
          'sr',
          '[2000-01-06 11:00, 2000-01-06 12:30)',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'nxr\' filter', () {
      final expectedMap = getRowByIds(reservations, [1, 2, 3]);
      expect(
        compare(
          reservations,
          'during',
          'nxr',
          '[2000-01-03 18:00, 2000-01-03 20:00)',
          expectedMap,
        ),
        true,
      );
    });

    test('should be able to execute an \'nxl\' filter', () {
      final expectedMap = getRowByIds(reservations, [6, 7, 8]);
      expect(
        compare(
          reservations,
          'during',
          'nxl',
          '[2000-01-06 11:00, 2000-01-06 12:30)',
          expectedMap,
        ),
        true,
      );
    });

    group('\'any\' modifier', () {
      test('should be able to execute an \'eq\' filter', () {
        final expectedMap = getRowByIds(tasks, [1, 3, 4]);
        expect(
          compare(
            tasks,
            'status',
            'eq(any)',
            '{"in-progress", "completed"}',
            expectedMap,
          ),
          true,
        );
      });

      test('should be able to execute an \'gt\' filter', () {
        final expectedMap = getRowByIds(tasks, [4, 5]);
        expect(
          compare(
            tasks,
            'id',
            'gt(any)',
            '{3, 5}',
            expectedMap,
          ),
          true,
        );
      });

      test('should be able to execute an \'gt\' filter (range)', () {
        final expectedMap = getRowByIds(reservations, [7, 8]);
        expect(
          compare(
            reservations,
            'during',
            'gt(any)',
            '{"[2000-01-06 11:00, 2000-01-06 12:30)", "[2000-01-08 10:30, 2000-01-08 12:00)"}',
            expectedMap,
          ),
          true,
        );
      });

      test('should be able to execute an \'gte\' filter', () {
        final expectedMap = getRowByIds(tasks, [3, 4, 5]);
        expect(
          compare(
            tasks,
            'id',
            'gte(any)',
            '{3, 5}',
            expectedMap,
          ),
          true,
        );
      });

      test('should be able to execute an \'gte\' filter (range)', () {
        final expectedMap = getRowByIds(reservations, [6, 7, 8]);
        expect(
          compare(
            reservations,
            'during',
            'gte(any)',
            '{"[2000-01-06 11:00, 2000-01-06 12:30)", "[2000-01-08 10:30, 2000-01-08 12:00)"}',
            expectedMap,
          ),
          true,
        );
      });

      test('should be able to execute an \'lt\' filter', () {
        final expectedMap = getRowByIds(tasks, [1, 0]);
        expect(
          compare(
            tasks,
            'id',
            'lt(any)',
            '{0, 2}',
            expectedMap,
          ),
          true,
        );
      });

      test('should be able to execute an \'lt\' filter (range)', () {
        final expectedMap = getRowByIds(reservations, [1, 2]);
        expect(
          compare(
            reservations,
            'during',
            'lt(any)',
            '{"[2000-01-01 13:00, 2000-01-01 15:00)", "[2000-01-03 18:00, 2000-01-03 20:00)"}',
            expectedMap,
          ),
          true,
        );
      });

      test('should be able to execute an \'lte\' filter', () {
        final expectedMap = getRowByIds(tasks, [0, 1, 2]);
        expect(
          compare(
            tasks,
            'id',
            'lte(any)',
            '{0, 2}',
            expectedMap,
          ),
          true,
        );
      });

      test('should be able to execute an \'lte\' filter (range)', () {
        final expectedMap = getRowByIds(reservations, [1, 2, 3]);
        expect(
          compare(
            reservations,
            'during',
            'lte(any)',
            '{"[2000-01-01 13:00, 2000-01-01 15:00)", "[2000-01-03 18:00, 2000-01-03 20:00)"}',
            expectedMap,
          ),
          true,
        );
      });

      test('should be able to execute an \'like\' filter', () {
        final expectedMap = getRowByIds(tasks, [1, 2]);
        expect(
          compare(
            tasks,
            'title',
            'like(any)',
            '{"Send%", "Complete%"}',
            expectedMap,
          ),
          true,
        );
      });

      test('should be able to execute an \'ilike\' filter', () {
        final expectedMap = getRowByIds(tasks, [1, 2]);
        expect(
          compare(
            tasks,
            'title',
            'ilike(any)',
            '{"SeNd%", "CoMpLeTe%"}',
            expectedMap,
          ),
          true,
        );
      });
    });

    group('\'all\' modifier', () {
      test('should be able to execute an \'eq\' filter', () {
        final expectedMap = getRowByIds(tasks, [3]);
        expect(
          compare(tasks, 'status', 'eq(all)', '{"completed"}', expectedMap),
          true,
        );
      });

      test('should be able to execute an \'gt\' filter', () {
        final expectedMap = getRowByIds(tasks, [5]);
        expect(
          compare(tasks, 'id', 'gt(all)', '{3, 4}', expectedMap),
          true,
        );
      });

      test('should be able to execute an \'gt\' filter (range)', () {
        final expectedMap = getRowByIds(reservations, [8]);
        expect(
          compare(
            reservations,
            'during',
            'gt(all)',
            '{"[2000-01-06 11:00, 2000-01-06 12:30)", "[2000-01-07 08:00, 2000-01-07 09:00]"}',
            expectedMap,
          ),
          true,
        );
      });

      test('should be able to execute an \'gte\' filter', () {
        final expectedMap = getRowByIds(tasks, [4, 5]);
        expect(
          compare(tasks, 'id', 'gte(all)', '{3, 4}', expectedMap),
          true,
        );
      });

      test('should be able to execute an \'gte\' filter (range)', () {
        final expectedMap = getRowByIds(reservations, [7, 8]);
        expect(
          compare(
            reservations,
            'during',
            'gte(all)',
            '{"[2000-01-06 11:00, 2000-01-06 12:30)", "[2000-01-07 08:00, 2000-01-07 09:00]"}',
            expectedMap,
          ),
          true,
        );
      });

      test('should be able to execute an \'lt\' filter', () {
        final expectedMap = getRowByIds(tasks, [0]);
        expect(
          compare(tasks, 'id', 'lt(all)', '{1, 2}', expectedMap),
          true,
        );
      });

      test('should be able to execute an \'lt\' filter (range)', () {
        final expectedMap = getRowByIds(reservations, [1]);
        expect(
          compare(
            reservations,
            'during',
            'lt(all)',
            '{"[2000-01-02 09:00, 2000-01-02 10:00)", "[2000-01-03 18:00, 2000-01-03 20:00)"}',
            expectedMap,
          ),
          true,
        );
      });

      test('should be able to execute an \'lte\' filter', () {
        final expectedMap = getRowByIds(tasks, [0, 1]);
        expect(
          compare(tasks, 'id', 'lte(all)', '{1, 2}', expectedMap),
          true,
        );
      });

      test('should be able to execute an \'lte\' filter (range)', () {
        final expectedMap = getRowByIds(reservations, [1, 2]);
        expect(
          compare(
            reservations,
            'during',
            'lte(all)',
            '{"[2000-01-02 09:00, 2000-01-02 10:00)", "[2000-01-03 18:00, 2000-01-03 20:00)"}',
            expectedMap,
          ),
          true,
        );
      });

      test('should be able to execute an \'like\' filter', () {
        final expectedMap = getRowByIds(tasks, [2]);
        expect(
          compare(
            tasks,
            'title',
            'like(all)',
            '{"Send%", "%manager%"}',
            expectedMap,
          ),
          true,
        );
      });

      test('should be able to execute an \'ilike\' filter', () {
        final expectedMap = getRowByIds(tasks, [2]);
        expect(
          compare(
            tasks,
            'title',
            'ilike(all)',
            '{"SeNd%", "%mAnAgEr%"}',
            expectedMap,
          ),
          true,
        );
      });
    });
  });

  group('expression execution', () {
    late final bool Function(
      List<Map<String, dynamic>> data,
      String filters,
      List<Map<String, dynamic>> compareList,
    ) compare;

    setUpAll(() {
      compare = (data, filters, compareList) {
        final filteredData =
            PostrestSyntaxParser(data).executeExpression(filters).execute();

        return deepEq(filteredData, compareList);
      };
    });

    test('should be able to execute a filter', () {
      final expectedRows = getRowByIds(users, [2]);
      expect(compare(users, 'name.eq."Jane"', expectedRows), true);
    });

    test(
        'should be able to execute more than one filter implying the AND operation',
        () {
      final expectedRows = getRowByIds(exactEquality, [3]);
      expect(
        compare(exactEquality, 'value.is.null, id.lt.4', expectedRows),
        true,
      );
    });

    test('should be able to perform an OR operation', () {
      final expectedRows = getRowByIds(tasks, [1, 2]);
      expect(
        compare(tasks, 'or(id.eq.1, id.eq.2)', expectedRows),
        true,
      );
    });

    test('should be able to nest OR and AND operations', () {
      final expectedRows = getRowByIds(tasks, [1, 2]);
      expect(
        compare(
          tasks,
          'or(id.eq.2, and(status.eq."in-progress", title.ilike."complete%"))',
          expectedRows,
        ),
        true,
      );
    });

    test('should be able to add the \'any\' modifier', () {
      final expectedRows = getRowByIds(tasks, [1, 3, 4]);
      expect(
        compare(
          tasks,
          'status.eq(any).{"in-progress", "completed"}',
          expectedRows,
        ),
        true,
      );
    });

    test('should be able to add the \'all\' modifier', () {
      final expectedRows = getRowByIds(tasks, [3]);
      expect(
        compare(
          tasks,
          'status.eq(all).{"completed"}',
          expectedRows,
        ),
        true,
      );
    });
  });
}
