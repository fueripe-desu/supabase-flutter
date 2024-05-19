import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should correctly create a Char data type', () {
    final char = Character(length: 6, 'sample');
    expect(char, Character(length: 6, 'sample'));
  });

  test('should be able to create a Char through the alias', () {
    final char = Char(length: 6, 'sample');
    expect(char, Character(length: 6, 'sample'));
  });

  test('should pad if value length is less than expected', () {
    final char = Character(length: 8, 'sample');
    expect(char.value, 'sample  ');
  });

  test('should truncate if value length is greater than expected', () {
    final char = Character(length: 6, 'samplestring');
    expect(char.value, 'sample');
  });

  test('should create an empty Char if length is zero', () {
    final char = Character(length: 0, 'samplestring');
    expect(char.value, '');
  });

  test('should throw an Exception if length is negative', () {
    expect(() => Character(length: -6, 'sample'), throwsException);
  });

  test('should throw an Exception if length exceeds maximum length', () {
    expect(() => Character(length: 1073741828, 'sample'), throwsException);
  });
}
