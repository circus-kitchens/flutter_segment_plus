package com.circuskitchens.flutter_segment_plus

import com.segment.analytics.kotlin.core.*
import com.segment.analytics.kotlin.core.platform.Plugin

class BrazeMiddleware: Plugin {
    override lateinit var analytics: Analytics
    override val type: Plugin.Type = Plugin.Type.Enrichment
    var lastKnownPayload: IdentifyEvent? = null

    override fun execute(event: BaseEvent): BaseEvent? {
        if (event.type != EventType.Identify) {
            return event
        }

        if (!shouldSend(event as IdentifyEvent)) {
            return null
        }
        lastKnownPayload = event
        return event
    }

    private fun shouldSend(event: IdentifyEvent): Boolean {
        if (event.userId != lastKnownPayload?.userId) {
            return true
        }

        if (event.anonymousId != lastKnownPayload?.anonymousId) {
            return true
        }

        if (areTraitsEqual(event.traits, lastKnownPayload?.traits)) {
            return false
        }

        return true
    }

    private fun areTraitsEqual(first: Traits, second: Traits?): Boolean {
        if (first.keys.isEmpty() && second == null) {
            return true
        }

        return first == second
    }
}