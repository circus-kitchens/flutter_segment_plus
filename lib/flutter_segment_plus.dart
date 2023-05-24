import 'segment_config.dart';
import 'flutter_segment_plus_platform_interface.dart';

class FlutterSegmentPlus {
  static FlutterSegmentPlusPlatform get _segment =>
      FlutterSegmentPlusPlatform.instance;

  Future<void> identify({
    String? userId,
    Map<String, dynamic>? traits,
  }) =>
      _segment.identify(
        userId: userId,
        traits: traits ?? {},
      );

  Future<void> config({
    required SegmentConfig options,
  }) =>
      _segment.config(
        options: options,
      );

  Future<void> track({
    required String eventName,
    Map<String, dynamic>? properties,
  }) =>
      _segment.track(
        eventName: eventName,
        properties: properties ?? {},
      );

  Future<void> screen({
    required String screenName,
    Map<String, dynamic>? properties,
  }) =>
      _segment.screen(
        screenName: screenName,
        properties: properties ?? {},
      );

  Future<void> group({
    required String groupId,
    Map<String, dynamic>? traits,
  }) =>
      _segment.group(
        groupId: groupId,
        traits: traits ?? {},
      );

  Future<void> alias({required String alias}) => _segment.alias(alias: alias);

  Future<String?> get getAnonymousId => _segment.getAnonymousId;

  Future<void> reset() => _segment.reset();

  Future<void> flush() => _segment.flush();

  Future<void> setContext(Map<String, dynamic> context) =>
      _segment.setContext(context);

  /// Returns Adjust's device identifier, if available.
  ///
  /// To work, Adjust integration have to be enabled.
  Future<String?> get adid => _segment.adid;
}
