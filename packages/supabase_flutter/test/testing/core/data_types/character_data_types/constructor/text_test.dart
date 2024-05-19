import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should be able to hold text of any size', () {
    final text = Text('a very large document.');
    expect(text, Text('a very large document.'));
  });
}
