import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'segment_config.dart';
import 'flutter_segment_plus_method_channel.dart';

abstract class FlutterSegmentPlusPlatform extends PlatformInterface {
  /// Constructs a FlutterSegmentPlusPlatform.
  FlutterSegmentPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterSegmentPlusPlatform _instance =
      MethodChannelFlutterSegmentPlus();

  /// The default instance of [FlutterSegmentPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterSegmentPlus].
  static FlutterSegmentPlusPlatform get instance => _instance;
  @visibleForTesting
  static set instance(instance) => _instance = instance;

  Future<void> config({
    required SegmentConfig options,
  }) {
    throw UnimplementedError('config() has not been implemented.');
  }

  Future<void> identify({
    String? userId,
    Map<String, dynamic>? traits,
  }) {
    throw UnimplementedError('identify() has not been implemented.');
  }

  Future<void> track({
    required String eventName,
    required Map<String, dynamic> properties,
  }) {
    throw UnimplementedError('track() has not been implemented.');
  }

  Future<void> screen({
    required String screenName,
    required Map<String, dynamic> properties,
  }) {
    throw UnimplementedError('screen() has not been implemented.');
  }

  Future<void> group({
    required String groupId,
    required Map<String, dynamic> traits,
  }) {
    throw UnimplementedError('group() has not been implemented.');
  }

  Future<void> alias({required String alias}) {
    throw UnimplementedError('alias() has not been implemented.');
  }

  Future<String?> get getAnonymousId {
    throw UnimplementedError('getAnonymousId() has not been implemented.');
  }

  Future<void> reset() {
    throw UnimplementedError('reset() has not been implemented.');
  }

  Future<void> flush() {
    throw UnimplementedError('flush() has not been implemented.');
  }

  Future<void> setContext(Map<String, dynamic> context) {
    throw UnimplementedError('setContext() has not been implemented.');
  }

  Future<String?> get adid {
    throw UnimplementedError('setContext() has not been implemented.');
  }
}
