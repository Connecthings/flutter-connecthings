import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:herow/herow.dart';

void main() {
  const MethodChannel channel = MethodChannel('herow');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });


}
