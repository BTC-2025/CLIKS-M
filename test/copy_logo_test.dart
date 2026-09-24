// ignore_for_file: avoid_print
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('copy logo if assets exist', () {
    try {
      final src = File('assets/bit_tool_logo.png');
      final destWeb = File('web/user_logo.png');
      
      if (src.existsSync()) {
        // Copy to web folder for local development server
        destWeb.createSync(recursive: true);
        destWeb.writeAsBytesSync(src.readAsBytesSync());
        
        print('=====================================================');
        print(' SUCCESS: Logo copied from assets to:');
        print('  - ${destWeb.path}');
        print('=====================================================');
      } else {
        print('assets/bit_tool_logo.png not found during test execution');
      }
    } catch (e) {
      print('ERROR copying logo: $e');
    }
  });
}
