package com.segment.analytics.kotlin.destinations.amplitude

import com.segment.analytics.kotlin.core.*
import com.segment.analytics.kotlin.core.platform.Plugin
import com.segment.analytics.kotlin.core.platform.VersionedPlugin
import com.segment.analytics.kotlin.core.platform.plugins.logger.LogFilterKind
import com.segment.analytics.kotlin.core.platform.plugins.logger.log
import com.segment.analytics.kotlin.core.utilities.putIntegrations
import java.util.*
import kotlin.concurrent.schedule

// A Destination plugin that adds session tracking to Amplitude cloud mode.
class AmplitudeSession (sessionTimeoutMs : Long = 300000) : Plugin, VersionedPlugin {

    override val type: Plugin.Type = Plugin.Type.Enrichment
    override lateinit var analytics: Analytics
    var sessionID: Long = -1
    private val key = "Actions Amplitude"
    private var active = false

    private var timer: TimerTask? = null
    private val fireTime: Long = sessionTimeoutMs

    override fun update(settings: Settings, type: Plugin.UpdateType) {
        active = settings.hasIntegrationSettings(key)
    }

    // Add the session_id to the Amplitude payload for cloud mode to handle.
    private inline fun <reified T : BaseEvent?> insertSession(payload: T?): BaseEvent? {
        var returnPayload = payload
        payload?.let {
            analytics.log(
                message = "Running ${payload.type} payload through AmplitudeSession",
                kind = LogFilterKind.DEBUG
            )
            refreshSessionID()
            returnPayload =
                payload.putIntegrations(key, mapOf("session_id" to sessionID)) as T?
        }
        return returnPayload
    }

    override fun execute(event: BaseEvent): BaseEvent? {
        if (!active) { // If amplitude destination is disabled, no need to do this enrichment
            return event
        }

        var result: BaseEvent? = event
        when (result) {
            is IdentifyEvent -> {
                result = identify(result)
            }
            is TrackEvent -> {
                result = track(result)
            }
            is GroupEvent -> {
                result = group(result)
            }
            is ScreenEvent -> {
                result = screen(result)
            }
            is AliasEvent -> {
                result = alias(result)
            }
            else -> {}
        }
        return result
    }

    private fun track(payload: TrackEvent): BaseEvent? {
        if (payload.event == "Application Backgrounded") {
            onBackground()
        } else if (payload.event == "Application Opened") {
            onForeground()
        }
        return insertSession(payload)
    }

    private fun identify(payload: IdentifyEvent): BaseEvent? {
        return insertSession(payload)
    }

    private fun screen(payload: ScreenEvent): BaseEvent? {
        return insertSession(payload)
    }

    private fun group(payload: GroupEvent): BaseEvent? {
        return insertSession(payload)
    }

    private fun alias(payload: AliasEvent): BaseEvent? {
        return insertSession(payload)
    }

    private fun onBackground() {
    }

    private fun onForeground() {
        refreshSessionID()
    }

    private fun refreshSessionID() {
        if (sessionID == -1L) {
            // get a new session ID if we've been inactive for more than 5 min
            sessionID = Calendar.getInstance().timeInMillis
        }
        startTimer()
    }

    private fun startTimer() {
        timer?.cancel()
        timer = Timer().schedule(fireTime) {
            // invalidate the session ID at the end of the timer
            stopTimer()
        }
    }

    private fun stopTimer() {
        timer?.cancel()
        sessionID = -1
    }

    override fun version(): String {
        return "1.5.3"
    }
}
