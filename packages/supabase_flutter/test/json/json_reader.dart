import 'dart:io';

String readJson(String name) => File('test/json/$name').readAsStringSync();
