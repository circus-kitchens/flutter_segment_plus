import Flutter
import UIKit
import Segment
import SegmentBraze
import SegmentSwiftAmplitude

public class FlutterSegmentPlusPlugin: NSObject, FlutterPlugin {
  var segment: Analytics? = nil
  var contextMerge = ContextMerge()
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_segment_plus", binaryMessenger: registrar.messenger())
    let instance = FlutterSegmentPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "config") {
      segment = config(call)
      result(true)
    }
    switch call.method {
    case "config":
      segment = config(call)
      result(true)
    case "setContext":
      contextMerge.segmentContext = parseSegmentContext(call)
      result(true)
    case "identify":
      identify(call, segment!)
      result(true)
    case "track":
      track(call, segment!)
      result(true)
    case "screen":
      screen(call, segment!)
      result(true)
    case "group":
      group(call, segment!)
      result(true)
    case "alias":
      alias(call, segment!)
      result(true)
    case "anonymousId":
      anonymousId(result, segment!)
    case "reset":
      reset(segment!)
      contextMerge.segmentContext = [:]
      result(true)
    case "flush":
      reset(segment!)
      result(true)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  func config(_ call: FlutterMethodCall) -> Analytics {
    let arguments = call.arguments as! [String: Any?]
    assert(arguments["options"] != nil)
    let configData = arguments["options"] as! [String: Any?]
    assert(configData["writeKey"] != nil)
    let writeKey: String = configData["writeKey"] as! String
    let trackApplicationLifecycleEvents: Bool = configData["trackApplicationLifecycleEvents"] as! Bool? ?? false
    let enableBraze: Bool = configData["appboyIntegrationEnabled"] as! Bool? ?? false
    let enableAmplitude: Bool = configData["amplitudeIntegrationEnabled"] as! Bool? ?? false
    let enableAdjust: Bool = configData["adjustIntegrationEnabled"] as! Bool? ?? false
    
    let configuration = Configuration(writeKey: writeKey)
      .trackApplicationLifecycleEvents(trackApplicationLifecycleEvents)
      .flushAt(3)
      .flushInterval(10)
    
    let segment = Analytics(configuration: configuration)

    segment.add(plugin: contextMerge)
    
    if (enableBraze) {
      let braze = BrazeDestination()
      braze.add(plugin: BrazeMiddleware())
      segment.add(plugin: braze)
    }
    
    if (enableAmplitude) {
      segment.add(plugin: AmplitudeSession())
    }
    
    if (enableAdjust) {
      segment.add(plugin: AdjustDestination())
    }
    
    if #available(iOS 14, *) {
      let enableIdfaCollection: Bool = configData["collectDeviceId"] as! Bool? ?? false
      if (enableIdfaCollection) {
        segment.add(plugin: IDFACollection())
      }
    }
    
    return segment
  }
  
  func parseSegmentContext(_ call: FlutterMethodCall) -> [String: Any] {
    let arguments = call.arguments as! [String: Any?]
    return arguments["context"] as! [String: Any]
  }
  
  func identify(_ call: FlutterMethodCall, _ segment: Analytics) {
    let arguments = call.arguments as! [String: Any?]
    let userId = arguments["userId"] as! String?
    let traits = arguments["traits"] as! [String: Any]
    if (userId == nil) {
      do {
        segment.identify(traits: try JSON(traits))
      } catch let error {
        print(error)
      }
    } else {
      segment.identify(userId: userId!, traits: traits)
    }
  }
  
  func track(_ call: FlutterMethodCall, _ segment: Analytics) {
    let arguments = call.arguments as! [String: Any?]
    let eventName = arguments["eventName"] as! String
    let properties = arguments["properties"] as! [String: Any]?
    if (properties == nil) {
      segment.track(name: eventName)
    } else {
      segment.track(name: eventName, properties: properties!)
    }
  }
  
  func screen(_ call: FlutterMethodCall, _ segment: Analytics) {
    let arguments = call.arguments as! [String: Any?]
    let screenName = arguments["screenName"] as! String
    let properties = arguments["properties"] as! [String: Any]?
    if (properties == nil) {
      segment.screen(title: screenName)
    } else {
      segment.screen(title: screenName, properties: properties!)
    }
  }
  
  func group(_ call: FlutterMethodCall, _ segment: Analytics) {
    let arguments = call.arguments as! [String: Any?]
    let groupId = arguments["groupId"] as! String
    let traits = arguments["traits"] as! [String: Any]?
    if (traits == nil) {
      segment.group(groupId: groupId)
    } else {
      segment.group(groupId: groupId, traits: traits!)
    }
  }
  
  func alias(_ call: FlutterMethodCall, _ segment: Analytics) {
    let arguments = call.arguments as! [String: Any?]
    let alias = arguments["alias"] as! String
    segment.alias(newId: alias)
  }
  
  func anonymousId(_ result: FlutterResult, _ segment: Analytics) {
    result(segment.anonymousId)
  }
  
  func reset(_ segment: Analytics) {
    segment.reset()
  }
  
  func flush(_ segment: Analytics) {
    segment.flush()
  }
}
