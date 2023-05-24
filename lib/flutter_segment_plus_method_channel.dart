import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'segment_config.dart';
import 'flutter_segment_plus_platform_interface.dart';

/// An implementation of [FlutterSegmentPlusPlatform] that uses method channels.
class MethodChannelFlutterSegmentPlus extends FlutterSegmentPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_segment_plus');

  @override
  Future<void> config({
    required SegmentConfig options,
  }) async {
    await methodChannel.invokeMethod('config', {
      'options': options.toMap(),
    });
  }

  @override
  Future<void> identify({
    String? userId,
    Map<String, dynamic>? traits,
  }) async {
    await methodChannel.invokeMethod('identify', {
      'userId': userId,
      'traits': traits,
    });
  }

  @override
  Future<void> track({
    required String eventName,
    required Map<String, dynamic> properties,
  }) async {
    await methodChannel.invokeMethod('track', {
      'eventName': eventName,
      'properties': properties,
    });
  }

  @override
  Future<void> screen({
    required String screenName,
    required Map<String, dynamic> properties,
  }) async {
    await methodChannel.invokeMethod('screen', {
      'screenName': screenName,
      'properties': properties,
    });
  }

  @override
  Future<void> group({
    required String groupId,
    required Map<String, dynamic> traits,
  }) async {
    await methodChannel.invokeMethod('group', {
      'groupId': groupId,
      'traits': traits,
    });
  }

  @override
  Future<void> alias({required String alias}) async {
    await methodChannel.invokeMethod('alias', {
      'alias': alias,
    });
  }

  @override
  Future<String?> get getAnonymousId {
    return methodChannel.invokeMethod('anonymousId');
  }

  @override
  Future<void> reset() async {
    await methodChannel.invokeMethod('reset');
  }

  @override
  Future<void> flush() async {
    await methodChannel.invokeMethod('flush');
  }

  @override
  Future<void> setContext(Map<String, dynamic> context) async {
    await methodChannel.invokeMethod('setContext', {
      'context': context,
    });
  }

  @override
  Future<String?> get adid => methodChannel.invokeMethod('adid');
}
