import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    List<Map<String, dynamic>> table, {
    TextSearchType? type,
  }) search;

  setUpAll(() {
    books = _loadJson('books.json');
    search = (column, query, table, {type}) {
      return TextSearch(table).textSearch(
        column,
        query,
        type: type,
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

  test('should use the PLAIN text search type', () {
    final expectedRows = [
      {
        "title": "The Giving Tree",
        "author": "Shel Silverstein",
        "description": "A tree makes sacrifices for a boy's happiness."
      },
    ];

    expect(
      search(
        'title',
        "The Giving Tree.",
        books,
        type: TextSearchType.plain,
      ),
      expectedRows,
    );
  });

  test('should use the PHRASE text search type', () {
    final expectedRows = [
      {
        "title": "The Giving Tree",
        "author": "Shel Silverstein",
        "description": "A tree makes sacrifices for a boy's happiness."
      },
    ];

    expect(
      search(
        'title',
        "The Giving Tree.",
        books,
        type: TextSearchType.phrase,
      ),
      expectedRows,
    );
  });

  group('websearch type', () {
    test('should treat consecutive terms as AND operations', () {
      final expectedRows = [
        {
          "title": "The Giving Tree",
          "author": "Shel Silverstein",
          "description": "A tree makes sacrifices for a boy's happiness."
        },
      ];

      expect(
        search(
          'title',
          "The Giving Tree",
          books,
          type: TextSearchType.websearch,
        ),
        expectedRows,
      );
    });

    test('should treat double quoted terms as PHRASE operations', () {
      final expectedRows = [
        {
          'title': 'Where the Wild Things Are',
          'author': 'Maurice Sendak',
          'description': 'A boy\'s adventure in a land of monsters.'
        },
      ];

      expect(
        search(
          'description',
          'boy and "land of monsters"',
          books,
          type: TextSearchType.websearch,
        ),
        expectedRows,
      );
    });

    test('should perform an AND operation', () {
      final expectedRows = [
        {
          "title": "The Giving Tree",
          "author": "Shel Silverstein",
          "description": "A tree makes sacrifices for a boy's happiness."
        },
      ];

      expect(
        search(
          'description',
          "a boy and a tree",
          books,
          type: TextSearchType.websearch,
        ),
        expectedRows,
      );
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
        },
      ];

      expect(
        search(
          'description',
          "a boy or a tree",
          books,
          type: TextSearchType.websearch,
        ),
        expectedRows,
      );
    });

    test('should perform a NOT operation', () {
      final expectedRows = [
        {
          'title': 'Where the Wild Things Are',
          'author': 'Maurice Sendak',
          'description': 'A boy\'s adventure in a land of monsters.'
        },
      ];

      expect(
        search(
          'description',
          "boy -tree",
          books,
          type: TextSearchType.websearch,
        ),
        expectedRows,
      );
    });

    test('should treat the hyphen when in the middle of words as a space', () {
      final expectedRows = [
        {
          'title': 'Alice\'s Adventures in Wonderland',
          'author': 'Lewis Carroll',
          'description': 'A girl\'s surreal-adventures in a fantastical land.'
        },
      ];

      expect(
        search(
          'description',
          "surreal-adventures",
          books,
          type: TextSearchType.websearch,
        ),
        expectedRows,
      );
    });

    test('should treat the hyphen when between double quotes as a space', () {
      final expectedRows = [
        {
          'title': 'Alice\'s Adventures in Wonderland',
          'author': 'Lewis Carroll',
          'description': 'A girl\'s surreal-adventures in a fantastical land.'
        },
      ];

      expect(
        search(
          'description',
          '"surreal-adventures"',
          books,
          type: TextSearchType.websearch,
        ),
        expectedRows,
      );
    });

    test('should be able to negate an expression', () {
      final expectedRows = [
        {
          'title': 'The Giving Tree',
          'author': 'Shel Silverstein',
          'description': 'A tree makes sacrifices for a boy\'s happiness.'
        },
      ];

      expect(
        search(
          'description',
          'boy -"land of monsters"',
          books,
          type: TextSearchType.websearch,
        ),
        expectedRows,
      );
    });

    test('should perform a AND NOT operation', () {
      final expectedRows = [
        {
          'title': 'Where the Wild Things Are',
          'author': 'Maurice Sendak',
          'description': 'A boy\'s adventure in a land of monsters.'
        },
      ];

      expect(
        search(
          'description',
          "boy and -tree",
          books,
          type: TextSearchType.websearch,
        ),
        expectedRows,
      );
    });

    test('should perform a OR NOT operation', () {
      final expectedRows = [
        {
          'title': 'The Poky Little Puppy',
          'author': 'Janette Sebring Lowrey',
          'description': 'Puppy is slower than other, bigger animals.'
        },
        {
          'title': 'The Tale of Peter Rabbit',
          'author': 'Beatrix Potter',
          'description': 'Rabbit eats some vegetables.'
        },
        {
          'title': 'Green Eggs and Ham',
          'author': 'Dr. Seuss',
          'description':
              'Sam has changing food preferences and eats unusually colored food.'
        },
        {
          'title': 'Harry Potter and the Goblet of Fire',
          'author': 'J.K. Rowling',
          'description': 'Fourth year of school starts, big drama ensues.'
        },
        {
          'title': 'Where the Wild Things Are',
          'author': 'Maurice Sendak',
          'description': 'A boy\'s adventure in a land of monsters.'
        },
        {
          'title': 'Charlotte\'s Web',
          'author': 'E.B. White',
          'description': 'A spider saves a pig from becoming dinner.'
        },
        {
          'title': 'The Very Hungry Caterpillar',
          'author': 'Eric Carle',
          'description': 'Caterpillar eats a lot, becomes a butterfly.'
        },
        {
          'title': 'Matilda',
          'author': 'Roald Dahl',
          'description': 'A girl with telekinetic powers and a love for books.'
        },
        {
          'title': 'The Cat in the Hat',
          'author': 'Dr. Seuss',
          'description': 'A mischievous cat visits two children.'
        },
        {
          'title': 'The Giving Tree',
          'author': 'Shel Silverstein',
          'description': 'A tree makes sacrifices for a boy\'s happiness.'
        },
        {
          'title': 'Anne of Green Gables',
          'author': 'L.M. Montgomery',
          'description': 'An imaginative orphan finds a home.'
        },
        {
          'title': 'The Lion, the Witch and the Wardrobe',
          'author': 'C.S. Lewis',
          'description': 'Children explore a magical world through a wardrobe.'
        },
        {
          'title': 'The Gruffalo',
          'author': 'Julia Donaldson',
          'description':
              'A mouse outsmarts predators with tales of a monstrous creature.'
        },
        {
          'title': 'Goodnight Moon',
          'author': 'Margaret Wise Brown',
          'description': 'A bunny says goodnight to everything around.'
        },
        {
          'title': 'The Hobbit',
          'author': 'J.R.R. Tolkien',
          'description':
              'A hobbit\'s journey to recover treasure from a dragon.'
        },
        {
          'title': 'Alice\'s Adventures in Wonderland',
          'author': 'Lewis Carroll',
          'description': 'A girl\'s surreal-adventures in a fantastical land.'
        },
        {
          'title': 'To Kill a Mockingbird',
          'author': 'Harper Lee',
          'description':
              'A lawyer defends an innocent man in a racially divided town.'
        },
        {
          'title': 'The Little Prince',
          'author': 'Antoine de Saint-Exupéry',
          'description': 'A pilot meets a young prince from another planet.'
        },
        {
          'title': '1984',
          'author': 'George Orwell',
          'description':
              'A dystopian future with oppressive government surveillance.'
        },
        {
          'title': 'Pride and Prejudice',
          'author': 'Jane Austen',
          'description':
              'Complex relationships and social commentary in 19th-century England.'
        },
        {
          'title': 'Moby-Dick',
          'author': 'Herman Melville',
          'description': 'A sea captain\'s obsessive hunt for a giant whale.'
        },
        {
          'title': 'The Catcher in the Rye',
          'author': 'J.D. Salinger',
          'description': 'A teenager\'s cynical journey through New York City.'
        },
        {
          'title': 'The Great Gatsby',
          'author': 'F. Scott Fitzgerald',
          'description':
              'The story of a mysterious millionaire\'s pursuit of love and success.'
        },
        {
          'title': 'Brave New World',
          'author': 'Aldous Huxley',
          'description':
              'A futuristic society driven by technological and genetic advancements.'
        }
      ];

      expect(
        search(
          'description',
          "boy or -tree",
          books,
          type: TextSearchType.websearch,
        ),
        expectedRows,
      );
    });
  });
}
