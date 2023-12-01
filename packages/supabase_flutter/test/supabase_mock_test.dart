import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUpAll(() async {
    SupabaseTest.initialize();
  });
  test('should initialize and close without timeout', () async {
    final client = SupabaseTest.getClient();
    await client.dispose();
  });
}
