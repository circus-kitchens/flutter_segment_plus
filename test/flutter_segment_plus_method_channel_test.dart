import 'package:flutter/services.dart';
import 'package:flutter_segment_plus/segment_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_segment_plus/flutter_segment_plus_method_channel.dart';

void main() {
  MethodChannelFlutterSegmentPlus platform = MethodChannelFlutterSegmentPlus();
  const MethodChannel channel = MethodChannel('flutter_segment_plus');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'config':
          assert(methodCall.arguments['options'] != null);
          assert(methodCall.arguments['options']['writeKey'] != null);
          break;
        case 'setContext':
          assert(methodCall.arguments['context'] != null);
          break;
        case 'alias':
          assert(methodCall.arguments['alias'] != null);
          break;
        case 'group':
          assert(methodCall.arguments['groupId'] != null);
          break;
        case 'identify':
          assert(methodCall.arguments['userId'] != null);
          break;
        case 'anonymousId':
          return 'test-anonymous-id';
        case 'screen':
          assert(methodCall.arguments['screenName'] != null);
          break;
        case 'track':
          assert(methodCall.arguments['eventName'] != null);
          break;
        case 'flush':
          break;
        case 'reset':
          break;
        default:
          throw UnimplementedError();
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('.config provides required params to the method channel', () async {
    // If the assertion is not satisfied, the test will fail
    await platform.config(options: SegmentConfig(writeKey: 'test-key'));
  });
  test('.setContext provides required params to the method channel', () async {
    // If the assertion is not satisfied, the test will fail
    await platform.setContext({});
  });
  test('.alias provides required params to the method channel', () async {
    // If the assertion is not satisfied, the test will fail
    await platform.alias(alias: 'test-alias');
  });
  test('.group provides required params to the method channel', () async {
    // If the assertion is not satisfied, the test will fail
    await platform.group(groupId: 'test-group', traits: {});
  });
  test('.identify provides required params to the method channel', () async {
    // If the assertion is not satisfied, the test will fail
    await platform.identify(userId: 'test-id');
  });
  test('.getAnonymousId calls proper method and returns a string', () async {
    expect(await platform.getAnonymousId, isA<String>());
  });
  test('.screen provides required params to the method channel', () async {
    // If the assertion is not satisfied, the test will fail
    await platform.screen(screenName: 'test-name', properties: {});
  });
  test('.track provides required params to the method channel', () async {
    // If the assertion is not satisfied, the test will fail
    await platform.track(eventName: 'test-name', properties: {});
  });
  test('.flush provides required params to the method channel', () async {
    // If the assertion is not satisfied, the test will fail
    await platform.flush();
  });
  test('.reset provides required params to the method channel', () async {
    // If the assertion is not satisfied, the test will fail
    await platform.reset();
  });
}
