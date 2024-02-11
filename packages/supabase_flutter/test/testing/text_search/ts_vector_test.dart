import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search.dart';
import 'package:supabase_flutter/src/testing/text_search/ts_vector.dart';

void main() {
  late final Term Function(String value) term;

  setUpAll(() {
    term = (value) => Term.fromString(value);
  });

  group('doc tests', () {
    late final bool Function(Map<int, TsVector>, Map<int, TsVector>) mapEq;

    setUpAll(() {
      mapEq = const MapEquality<int, TsVector>().equals;
    });

    test('should create an empty doc', () {
      final doc = Doc.empty();
      expect(doc.data.isEmpty, true);
    });

    group('addTsVector() tests', () {
      test('should add a new ts vector to the doc', () {
        final doc = Doc.empty();
        doc.addTsVector(0, TsVector({0: term('zero')}));
        doc.addTsVector(1, TsVector({1: term('one')}));

        expect(
          mapEq(
            doc.data,
            {
              0: TsVector({0: term('zero')}),
              1: TsVector({1: term('one')}),
            },
          ),
          true,
        );
      });
    });

    group('filterDoc() tests', () {
      test('should return a filtered doc based on the condition', () {
        final doc = Doc(
          {
            0: TsVector({0: term('zero')}),
            1: TsVector({1: term('one')}),
            2: TsVector({2: term('two')}),
            3: TsVector({3: term('three')}),
          },
        );

        doc.filterDoc((term) => term.value != 'two' ? term : null);

        expect(
          mapEq(
            doc.data,
            {
              0: TsVector({0: term('zero')}),
              1: TsVector({1: term('one')}),
              3: TsVector({3: term('three')}),
            },
          ),
          true,
        );
      });
    });

    group('equality tests', () {
      test('should return true if docs are equal', () {
        final doc1 = Doc.empty();
        doc1.addTsVector(0, TsVector({0: term('zero')}));

        final doc2 = Doc.empty();
        doc2.addTsVector(0, TsVector({0: term('zero')}));

        expect(doc1 == doc2, true);
      });

      test('should return false if docs are different', () {
        final doc1 = Doc.empty();
        doc1.addTsVector(0, TsVector({0: term('zero')}));

        final doc2 = Doc.empty();
        doc2.addTsVector(1, TsVector({1: term('one')}));

        expect(doc1 == doc2, false);
      });
    });
  });

  group('ts vector tests', () {
    late final bool Function(Map<int, Term>, Map<int, Term>) mapEq;
    late final TsVector Function(List<String> terms) createVector;

    setUpAll(() {
      mapEq = (value1, value2) {
        return TsVector(value1) == TsVector(value2);
      };
      createVector = (terms) {
        final Map<int, Term> vectorMap = {};
        for (int i = 0; i < terms.length; i++) {
          vectorMap[i] = Term.fromString(terms[i]);
        }

        return TsVector(vectorMap);
      };
    });

    test('should create an empty ts vector', () {
      final tsVector = TsVector.empty();
      expect(tsVector.data.isEmpty, true);
    });

    test('should return true if ts vector is empty', () {
      final tsVector = TsVector.empty();
      expect(tsVector.isEmpty, true);
    });

    group('addIndex() tests', () {
      test('should add a new index in the ts vector', () {
        final tsVector = TsVector.empty();
        tsVector.addIndex(2, term('cat'));
        tsVector.addIndex(5, term('dog'));

        expect(mapEq(tsVector.data, {2: term('cat'), 5: term('dog')}), true);
      });
    });

    group('hasTerm() tests', () {
      late final bool Function(List<String> terms, String term) hasTerm;

      setUpAll(() {
        hasTerm = (terms, term) {
          final tsVector = createVector(terms);
          return tsVector.hasTerm(term);
        };
      });

      test('should return true if ts vector has the term', () {
        expect(hasTerm(['one', 'two', 'three'], 'two'), true);
      });

      test('should return false if ts vector does not have the term', () {
        expect(hasTerm(['one', 'two', 'three'], 'five'), false);
      });
    });

    group('getDistance() tests', () {
      late final int? Function(
        List<String> terms,
        String term1,
        String term2,
      ) getDistance;

      setUpAll(() {
        getDistance = (terms, term1, term2) {
          final tsVector = createVector(terms);
          return tsVector.getDistance(term1, term2);
        };
      });

      test('should return the distance between two terms (index1 > index2)',
          () {
        expect(
          getDistance(['zero', 'one', 'two', 'three'], 'two', 'zero'),
          2,
        );
      });

      test('should return the distance between two terms (index2 > index1)',
          () {
        expect(
          getDistance(['zero', 'one', 'two', 'three'], 'one', 'three'),
          2,
        );
      });

      test('should return null if the first term does not exist', () {
        expect(
          getDistance(['zero', 'one', 'two', 'three'], 'four', 'zero'),
          null,
        );
      });

      test('should return null if the second term does not exist', () {
        expect(
          getDistance(['zero', 'one', 'two', 'three'], 'two', 'seven'),
          null,
        );
      });
    });

    group('firstIndexOf() tests', () {
      late final int? Function(List<String> terms, String term) firstIndexOf;

      setUpAll(() {
        firstIndexOf = (terms, term) {
          final tsVector = createVector(terms);
          return tsVector.firstIndexOf(term);
        };
      });

      test('should return the index of the first element that matches', () {
        expect(firstIndexOf(['zero', 'one', 'two', 'three'], 'one'), 1);
      });

      test('should return null if the term does not exist', () {
        expect(firstIndexOf(['zero', 'one', 'two', 'three'], 'seven'), null);
      });
    });

    group('equality tests', () {
      late final bool Function(
        List<String> terms1,
        List<String> terms2,
      ) compare;

      setUpAll(() {
        compare = (terms1, terms2) {
          final tsVector1 = createVector(terms1);
          final tsVector2 = createVector(terms2);

          return tsVector1 == tsVector2;
        };
      });

      test('should return true if ts vectors are equal', () {
        expect(compare(['one'], ['one']), true);
      });

      test('should return false if ts vectors are different', () {
        expect(compare(['one'], ['two']), false);
      });
    });
  });

  group('ts vector builder tests', () {
    late final Map<int, String> Function(
      String column,
      List<Map<String, dynamic>> data,
    ) retrieveColumn;

    late final Doc Function(
      Map<int, String> column,
      TextSearchDictionary dict,
    ) toTsVector;

    late final TextSearchDictionary Function(
      String dictName,
    ) loadDict;

    late final bool Function(
      Map<int, TsVector>,
      Map<int, TsVector>,
    ) mapEq;

    setUpAll(() {
      retrieveColumn = (column, data) {
        final docs = data.map((element) => element[column] as String).toList();
        final Map<int, String> finalData = {};

        for (int i = 0; i < docs.length; i++) {
          finalData[i] = docs[i];
        }

        return finalData;
      };

      loadDict = (dictName) {
        final file = File(
          'lib/src/testing/text_search_data/$dictName.json',
        );
        if (!file.existsSync()) {
          throw Exception('Config file \'$dictName\' does not exist.');
        }

        final jsonString = file.readAsStringSync();
        return TextSearchDictionary.fromJson(jsonString);
      };

      toTsVector = (column, dict) {
        final builder = TsVectorBuilder();
        return builder.toTsVector(column, dict);
      };

      mapEq = const MapEquality<int, TsVector>().equals;
    });

    test('should convert ts vectors to lower case', () {
      final table = [
        {"column1": "ROW 1 SAMPLE"},
        {"column1": "ROW 2 SAMPLE"},
      ];

      final column = retrieveColumn('column1', table);
      final doc = toTsVector(column, loadDict('english'));

      expect(
        mapEq(
          doc.data,
          {
            0: TsVector({0: term('row'), 1: term('1'), 2: term('sampl')}),
            1: TsVector({0: term('row'), 1: term('2'), 2: term('sampl')}),
          },
        ),
        true,
      );
    });

    test('should filter stop words', () {
      final table = [
        {"column1": "The cat and the dog"},
        {"column1": "This is my book"},
      ];

      final column = retrieveColumn('column1', table);
      final doc = toTsVector(column, loadDict('english'));

      expect(
        mapEq(
          doc.data,
          {
            0: TsVector({1: term('cat'), 4: term('dog')}),
            1: TsVector({3: term('book')}),
          },
        ),
        true,
      );
    });

    test('should reduce words back to their root forms', () {
      final table = [
        {"column1": "Trouble is coming"},
        {"column1": "The cats are purring"},
      ];

      final column = retrieveColumn('column1', table);
      final doc = toTsVector(column, loadDict('english'));

      expect(
        mapEq(
          doc.data,
          {
            0: TsVector({0: term('troubl'), 2: term('come')}),
            1: TsVector({1: term('cat'), 3: term('pur')}),
          },
        ),
        true,
      );
    });
  });
}
