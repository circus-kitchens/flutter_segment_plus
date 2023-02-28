//
//  ContextMerge.swift
//  flutter_segment_plus
//
//  Created by Marcin Wróblewski on 06/03/2023.
//

import Segment

class ContextMerge: EventPlugin {
  let type: PluginType = .enrichment
  var analytics: Segment.Analytics?
  var segmentContext: [String: Any] = [:]
  
  public func track(event: TrackEvent) -> TrackEvent? {
    var workingEvent = event;
    workingEvent.context = mergeContexts(eventContext: event.context)
    return workingEvent
  }
  
  public func identify(event: IdentifyEvent) -> IdentifyEvent? {
    var workingEvent = event;
    workingEvent.context = mergeContexts(eventContext: event.context)
    return workingEvent
  }
  
  public func screen(event: ScreenEvent) -> ScreenEvent? {
    var workingEvent = event;
    workingEvent.context = mergeContexts(eventContext: event.context)
    return workingEvent
  }
  
  public func group(event: GroupEvent) -> GroupEvent? {
    var workingEvent = event;
    workingEvent.context = mergeContexts(eventContext: event.context)
    return workingEvent
  }
  
  public func alias(event: AliasEvent) -> AliasEvent? {
    var workingEvent = event;
    workingEvent.context = mergeContexts(eventContext: event.context)
    return workingEvent
  }
  
  func mergeContexts(eventContext: JSON?) -> JSON? {
    let mergedContexts = deepMerge(
      source: eventContext?.dictionaryValue ?? [:],
      target: segmentContext
    )
    do {
      let mergedContextsJson: JSON = try JSON.init(mergedContexts)
      return mergedContextsJson
    } catch let error{
      print(error)
      return eventContext
    }
  }
  
  func deepMerge(source: [String: Any], target: [String: Any]) -> [String: Any] {
    var merged: [String: Any] = [:]
    let keys = Array(source.keys) + Array(target.keys)
    
    for key in Set(keys) {
      if (target[key] is [String: Any] && source[key] is [String: Any]) {
        merged[key] = deepMerge(
          source: source[key] as! [String: Any],
          target: target[key] as! [String: Any]
        )
      } else {
        merged[key] = target[key] ?? source[key]
      }
    }
    return merged
  }
}
