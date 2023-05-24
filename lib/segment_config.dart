class SegmentConfig {
  SegmentConfig({
    required this.writeKey,
    this.trackApplicationLifecycleEvents = false,
    this.amplitudeIntegrationEnabled = false,
    this.appboyIntegrationEnabled = false,
    this.adjustIntegrationEnabled = false,
    this.collectDeviceId = false,
    this.debug = false,
    this.adjustExternalDeviceId,
  });

  final String writeKey;
  final bool trackApplicationLifecycleEvents;
  final bool amplitudeIntegrationEnabled;
  final bool appboyIntegrationEnabled;
  final bool adjustIntegrationEnabled;
  final bool collectDeviceId;
  final bool debug;
  final String? adjustExternalDeviceId;

  Map<String, dynamic> toMap() => {
        'writeKey': writeKey,
        'trackApplicationLifecycleEvents': trackApplicationLifecycleEvents,
        'amplitudeIntegrationEnabled': amplitudeIntegrationEnabled,
        'appboyIntegrationEnabled': appboyIntegrationEnabled,
        'adjustIntegrationEnabled': adjustIntegrationEnabled,
        'collectDeviceId': collectDeviceId,
        'debug': debug,
        'adjustExternalDeviceId': adjustExternalDeviceId,
      };
}
