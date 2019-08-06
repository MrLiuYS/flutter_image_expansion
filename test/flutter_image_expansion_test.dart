import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_image_expansion/flutter_image_expansion.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_image_expansion');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterImageExpansion.platformVersion, '42');
  });
}
