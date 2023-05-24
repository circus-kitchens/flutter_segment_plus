import 'package:flutter_segment_plus/segment_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_segment_plus/flutter_segment_plus.dart';
import 'package:flutter_segment_plus/flutter_segment_plus_platform_interface.dart';
import 'package:flutter_segment_plus/flutter_segment_plus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterSegmentPlusPlatform
    with MockPlatformInterfaceMixin
    implements FlutterSegmentPlusPlatform {
  @override
  Future<void> alias({required String alias}) async {}

  @override
  Future<void> config({required SegmentConfig options}) async {}

  @override
  Future<void> flush() async {}

  @override
  Future<String?> get getAnonymousId async => 'test-anonymous-id';

  @override
  Future<void> group(
      {required String groupId, required Map<String, dynamic> traits}) async {}

  @override
  Future<void> identify({String? userId, Map<String, dynamic>? traits}) async {}

  @override
  Future<void> reset() async {}

  @override
  Future<void> screen(
      {required String screenName,
      required Map<String, dynamic> properties}) async {}

  @override
  Future<void> setContext(Map<String, dynamic> context) async {}

  @override
  Future<void> track(
      {required String eventName,
      required Map<String, dynamic> properties}) async {}

  @override
  // TODO: implement adid
  Future<String?> get adid => throw UnimplementedError();
}

void main() {
  final FlutterSegmentPlusPlatform initialPlatform =
      FlutterSegmentPlusPlatform.instance;

  test('$MethodChannelFlutterSegmentPlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterSegmentPlus>());
  });

  group('API', () {
    FlutterSegmentPlus flutterSegmentPlusPlugin = FlutterSegmentPlus();
    MockFlutterSegmentPlusPlatform fakePlatform =
        MockFlutterSegmentPlusPlatform();
    FlutterSegmentPlusPlatform.instance = fakePlatform;

    test(
      '.alias do not throw',
      // If it'll throw, the test will fail
      () => flutterSegmentPlusPlugin.alias(alias: ''),
    );
    test(
      '.flush do not throw',
      // If it'll throw, the test will fail
      () => flutterSegmentPlusPlugin.flush(),
    );
    test(
      '.getAnonymousId returns a string',
      () async =>
          expect(await flutterSegmentPlusPlugin.getAnonymousId, isA<String>()),
    );
    test(
      '.group do not throw',
      // If it'll throw, the test will fail
      () => flutterSegmentPlusPlugin.group(groupId: 'test-groupId'),
    );
    test(
      '.identify do not throw',
      // If it'll throw, the test will fail
      () => flutterSegmentPlusPlugin.identify(userId: 'test-userId'),
    );
    test(
      '.reset do not throw',
      // If it'll throw, the test will fail
      () => flutterSegmentPlusPlugin.reset(),
    );
    test(
      '.setContext do not throw',
      // If it'll throw, the test will fail
      () => flutterSegmentPlusPlugin.setContext({}),
    );
    test(
      '.track do not throw',
      // If it'll throw, the test will fail
      () => flutterSegmentPlusPlugin.track(eventName: 'test-event'),
    );
    test(
      '.screen do not throw',
      // If it'll throw, the test will fail
      () => flutterSegmentPlusPlugin.screen(screenName: 'test-screen'),
    );
  });
}
