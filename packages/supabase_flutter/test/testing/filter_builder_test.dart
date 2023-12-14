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
}
