import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('should initialize and close without timeout', () async {
    final client = SupabaseClient('', '');
    await client.dispose();
  });
}
