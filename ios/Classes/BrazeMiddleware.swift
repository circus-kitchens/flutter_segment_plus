//
//  BrazeMiddleware.swift
//  flutter_segment_plus
//
//  Created by Marcin Wróblewski on 07/03/2023.
//

import Segment

class BrazeMiddleware: EventPlugin {
  var analytics: Segment.Analytics?
  
  let type: PluginType = .enrichment
  var lastKnownPayload: IdentifyEvent? = nil
  
  func identify(event: IdentifyEvent) -> IdentifyEvent? {    
    if !shouldSend(event: event) {
      return nil
    }
    
    lastKnownPayload = event
    return event
  }
  
  private func shouldSend(event: IdentifyEvent) -> Bool {
    if event.userId != lastKnownPayload?.userId {
      return true
    }

    if event.anonymousId != lastKnownPayload?.anonymousId {
      return true
    }
    
    if areTraitsEqual(event.traits, lastKnownPayload?.traits) {
      return false
    }
    
    return true
  }
  
  private func areTraitsEqual(_ first: JSON?, _ second: JSON?) -> Bool {
    if first == nil && second == nil {
      return true
    }
    
    if let first = first, let second = second {
      return NSDictionary(dictionary: first.dictionaryValue ?? [:]).isEqual(to: second.dictionaryValue ?? [:])
    }
    
    return false
  }
}
