import 'package:collection/collection.dart';
import 'package:stemmer/SnowballStemmer.dart';
import 'package:supabase_flutter/src/testing/text_search/text_search.dart';

typedef _Tokens = Map<int, String>;

class Doc {
  final Map<int, TsVector> _data;

  Doc(Map<int, TsVector> data) : _data = Map.from(data);

  factory Doc.empty() => Doc({});

  Map<int, TsVector> get data => _data;

  void filterDoc(String? Function(String innerValue) updateFunc) {
    final newDoc = Doc.empty();
    _data.forEach((docIndex, docTsVector) {
      final TsVector newTsVector = TsVector.empty();
      docTsVector.data.forEach((tsVectorIndex, tsVectorValue) {
        final result = updateFunc(tsVectorValue);

        if (result != null) {
          newTsVector.addIndex(tsVectorIndex, result);
        }
      });
      if (!newTsVector.isEmpty) {
        newDoc.addTsVector(docIndex, newTsVector);
      }
    });

    _data.clear();
    _data.addAll(newDoc._data);
  }

  void addTsVector(int index, TsVector tsVector) {
    _data[index] = tsVector;
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Doc {');
    _data.forEach((docIndex, docTsVector) {
      buffer.writeln('  $docIndex: ${docTsVector.toString()}');
    });
    buffer.writeln('}');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Doc) return false;

    return const MapEquality<int, TsVector>().equals(_data, other._data);
  }

  @override
  int get hashCode => const MapEquality<int, TsVector>().hash(_data);
}

class TsVector {
  final Map<int, String> _data;

  TsVector(Map<int, String> data) : _data = Map.from(data);

  Map<int, String> get data => _data;

  factory TsVector.empty() => TsVector({});

  bool get isEmpty => _data.isEmpty;

  void addIndex(int index, String term) {
    _data[index] = term;
  }

  bool hasTerm(String term) => _data.containsValue(term);

  int? getDistance(String term1, String term2) {
    final index1 = firstIndexOf(term1);
    final index2 = firstIndexOf(term2);

    if (index1 == null || index2 == null) {
      return null;
    }

    if (index1 > index2) {
      return index1 - index2;
    } else {
      return index2 - index1;
    }
  }

  int? firstIndexOf(String term) {
    if (!hasTerm(term)) {
      return null;
    }

    int? firstKey;

    _data.forEach((key, value) {
      if (firstKey == null && value == term) {
        firstKey = key;
      }
    });

    return firstKey;
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('{');
    bool isFirst = true;
    _data.forEach((index, term) {
      if (!isFirst) {
        buffer.write(', ');
      }
      buffer.write('$index: "$term"');
      isFirst = false;
    });
    buffer.write('}');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TsVector) return false;

    return const MapEquality<int, String>().equals(_data, other._data);
  }

  @override
  int get hashCode => const MapEquality<int, String>().hash(_data);
}

class TsVectorBuilder {
  Doc toTsVector(
    Map<int, String> column,
    TextSearchDictionary dict,
  ) {
    // Creates a copy of the data
    final _Tokens columnData = Map.from(column);

    // Converts the docs to lower case
    final rawLowerCaseTokens = _rawTokensToLowerCase(columnData);

    // Converts to ts vectors from the raw docs
    final tsVectors = rawLowerCaseTokens.map(
      (key, value) => MapEntry(key, _rawTokenToTsVector(value)),
    );
    final doc = Doc(tsVectors);

    // Filter stop words from the ts vectors
    final filteredDoc = _filterStopWords(doc, dict);

    // Stem the final words from the ts vectors
    final stemmedDoc = _stemDoc(filteredDoc);
    return stemmedDoc;
  }

  Doc _stemDoc(Doc doc) {
    SnowballStemmer stemmer = SnowballStemmer();

    return doc..filterDoc((innerValue) => stemmer.stem(innerValue));
  }

  Doc _filterStopWords(
    Doc doc,
    TextSearchDictionary dict,
  ) =>
      doc
        ..filterDoc((innerValue) {
          if (!dict.containsStopWord(innerValue)) {
            return innerValue;
          }

          return null;
        });

  TsVector _rawTokenToTsVector(String token) {
    final regex = RegExp(r'[^\w\s\d]');

    final Map<int, String> tsVector = {};

    final withoutDashes = token.replaceAll('-', ' ');
    final rawToken = withoutDashes.replaceAll(regex, '');
    final splitDoc = rawToken.trim().split(' ');

    for (int i = 0; i < splitDoc.length; i++) {
      tsVector[i] = splitDoc[i];
    }

    return TsVector(tsVector);
  }

  _Tokens _rawTokensToLowerCase(Map<int, String> rawTokens) =>
      rawTokens.map((key, value) => MapEntry(key, value.toLowerCase()));
}
