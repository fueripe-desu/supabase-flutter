import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should create a VarChar data type', () {
    final char = CharacterVarying(length: 6, 'sample');
    expect(char, CharacterVarying(length: 6, 'sample'));
  });

  test('should be able to create a VarChar through the alias', () {
    final char = VarChar(length: 6, 'sample');
    expect(char, CharacterVarying(length: 6, 'sample'));
  });

  test('should not pad if value length is less than expected', () {
    final char = CharacterVarying(length: 8, 'sample');
    expect(char.value, 'sample');
  });

  test(
      'should store characters up to implementation limits if length is not specified',
      () {
    final char = CharacterVarying('a very large text');
    expect(char.value, 'a very large text');
  });

  test('should store an empty VarChar if length is zero', () {
    final char = CharacterVarying(length: 0, '');
    expect(char.value, '');
  });

  test('should throw an Exception if value length is greater than expected',
      () {
    expect(() => CharacterVarying(length: 6, 'samplestring'), throwsException);
  });

  test('should throw an Exception if length is negative', () {
    expect(() => CharacterVarying(length: -6, 'sample'), throwsException);
  });
}
