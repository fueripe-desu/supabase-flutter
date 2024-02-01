import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search.dart';

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
  late final List<Map<String, dynamic>> books;
  late final List<Map<String, dynamic>> Function(
    String column,
    String query,
    List<Map<String, dynamic>> table,
  ) search;

  setUpAll(() {
    books = _loadJson('books.json');
    search = (column, query, table) {
      return TextSearch(table).textSearch(
        column,
        query,
      );
    };
  });

  test('should return the rows that contains the operand', () {
    final expectedRows = [
      {
        'title': 'Where the Wild Things Are',
        'author': 'Maurice Sendak',
        'description': 'A boy\'s adventure in a land of monsters.'
      },
      {
        'title': 'The Giving Tree',
        'author': 'Shel Silverstein',
        'description': 'A tree makes sacrifices for a boy\'s happiness.'
      }
    ];

    expect(search('description', "'boy'", books), expectedRows);
  });

  test('should perform an AND operation', () {
    final expectedRows = [
      {
        'title': 'Where the Wild Things Are',
        'author': 'Maurice Sendak',
        'description': 'A boy\'s adventure in a land of monsters.'
      },
    ];

    expect(search('description', "'boy' & 'monsters'", books), expectedRows);
  });

  test('should perform an OR operation', () {
    final expectedRows = [
      {
        'title': 'Where the Wild Things Are',
        'author': 'Maurice Sendak',
        'description': 'A boy\'s adventure in a land of monsters.'
      },
      {
        'title': 'The Giving Tree',
        'author': 'Shel Silverstein',
        'description': 'A tree makes sacrifices for a boy\'s happiness.'
      }
    ];

    expect(search('description', "'boy' | 'trees'", books), expectedRows);
  });

  test('should perform a PHRASE operation', () {
    final expectedRows = [
      {
        "title": "The Gruffalo",
        "author": "Julia Donaldson",
        "description":
            "A mouse outsmarts predators with tales of a monstrous creature."
      }
    ];

    expect(
      search('description', "'mouse' <-> 'outsmarts'", books),
      expectedRows,
    );
  });

  test('should perform a PROXIMITY operation', () {
    final expectedRows = [
      {
        "title": "Goodnight Moon",
        "author": "Margaret Wise Brown",
        "description": "A bunny says goodnight to everything around."
      }
    ];

    expect(
      search('description', "'bunny' <2> 'goodnight'", books),
      expectedRows,
    );
  });

  test('should perform a NOT operation', () {
    final expectedRows = [
      {
        'title': 'The Giving Tree',
        'author': 'Shel Silverstein',
        'description': 'A tree makes sacrifices for a boy\'s happiness.'
      },
    ];

    expect(search('description', "'boy' & !'monsters'", books), expectedRows);
  });

  test('should perform a subexpression', () {
    final expectedRows = [
      {
        "title": "The Lion, the Witch and the Wardrobe",
        "author": "C.S. Lewis",
        "description": "Children explore a magical world through a wardrobe."
      },
    ];

    expect(
      search('description', "'children' & ('world' & 'magical')", books),
      expectedRows,
    );
  });

  test('should negate a subexpression', () {
    final expectedRows = [
      {
        "title": "The Giving Tree",
        "author": "Shel Silverstein",
        "description": "A tree makes sacrifices for a boy's happiness."
      },
    ];

    expect(
      search('description', "'boy' & !('monster' & 'land')", books),
      expectedRows,
    );
  });
}
