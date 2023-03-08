package com.circuskitchens.flutter_segment_plus


import android.content.Context
import com.segment.analytics.kotlin.android.Analytics
import com.segment.analytics.kotlin.core.*
import com.segment.analytics.kotlin.core.platform.Plugin
import com.segment.analytics.kotlin.core.utilities.safeJsonObject
import com.segment.analytics.kotlin.core.utilities.toJsonElement
import com.segment.analytics.kotlin.core.utilities.updateJsonObject
import com.segment.analytics.kotlin.destinations.amplitude.AmplitudeSession
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.*
import kotlinx.serialization.json.*

/** FlutterSegmentPlusPlugin */
class FlutterSegmentPlusPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context : Context
  private var segment : Analytics? = null
  private var segmentContext : JsonObject = JsonObject(mapOf())
  @OptIn(DelicateCoroutinesApi::class)
  private val scope = CoroutineScope(newSingleThreadContext("scope"))

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_segment_plus")
    channel.setMethodCallHandler(this)
    this.context = flutterPluginBinding.applicationContext

  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("")
      }
      "config" -> {
        segment = config(call)
        result.success(true)
      }
      "setContext" -> {
        segmentContext = parseSegmentContext(call)
        result.success(true)
      }
      "identify" -> {
        identify(call, segment!!)
        result.success(true)
      }
      "track" -> {
        track(call, segment!!)
        result.success(true)
      }
      "screen" -> {
        screen(call, segment!!)
        result.success(true)
      }
      "group" -> {
        group(call, segment!!)
        result.success(true)
      }
      "alias" -> {
        alias(call, segment!!)
        result.success(true)
      }
      "anonymousId" -> {
        scope.launch {
          anonymousId(result, segment!!)
        }
      }
      "reset" -> {
        reset(segment!!)
        segmentContext = JsonObject(mapOf())
        result.success(true)
      }
      "flush" -> {
        flush(segment!!)
        result.success(true)
      }
      else -> {
        result.notImplemented()
      }
    }
  }


  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun config(call: MethodCall): Analytics {
    assert(call.argument("options") as Map<String, Any>? != null)
    val configData: Map<String, Any> = call.argument("options")!!
    assert(configData["writeKey"] != null)
    val writeKey: String = configData["writeKey"] as String
    val trackApplicationLifecycleEvents: Boolean = configData["trackApplicationLifecycleEvents"] as Boolean? ?: false
    val trackDeepLinks: Boolean = configData["trackDeeplinks"] as Boolean? ?: false
    val collectDeviceId: Boolean = configData["collectDeviceId"] as Boolean? ?: false
    val enableBraze: Boolean = configData["appboyIntegrationEnabled"] as Boolean? ?: false
    val enableAmplitude: Boolean = configData["amplitudeIntegrationEnabled"] as Boolean? ?: false
    val enableAdjust: Boolean = configData["adjustIntegrationEnabled"] as Boolean? ?: false

    val segmentInstance = Analytics(writeKey, context) {
      this.trackApplicationLifecycleEvents = trackApplicationLifecycleEvents
      flushAt = 3
      flushInterval = 10
      this.collectDeviceId = collectDeviceId
      this.trackDeepLinks = trackDeepLinks
    }

    segmentInstance.add(object: Plugin {
      override lateinit var analytics: Analytics
      override val type = Plugin.Type.Enrichment

      override fun execute(event: BaseEvent): BaseEvent {
        event.context = event.context.deepMergeWith(segmentContext)
        return event
      }
    })

    if (enableBraze) {
      // TODO: replace Braze integration with custom one
      val braze = BrazeDestination(context)
      segmentInstance.add(plugin = braze)
      braze.add(BrazeMiddleware())
    }

    if (enableAmplitude) {
      segmentInstance.add(plugin = AmplitudeSession())
    }

    if (enableAdjust) {
      // Waiting for Segment to publish Kotlin-based Segment-Adjust integration
      // Actually, they have no ETA for this integration, BUT
      // when it'll be ready, it'll be public at
      // https://github.com/segment-integrations/analytics-kotlin-adjust
      // and importable by
      // implementation 'com.segment.analytics.kotlin.destinations:adjust:+'.
    }

    return segmentInstance
  }

  private fun identify(call: MethodCall, segment: Analytics) {
    val userId = call.argument<String>("userId")
    val traits = call.argument<Map<String, Any>>("traits").toJsonElement()
    if (userId != null) {
      segment.identify(userId, traits)
    } else {
      segment.identify(traits)
    }
  }

  private fun track(call: MethodCall, segment: Analytics) {
    val eventName = call.argument<String>("eventName")!!
    val properties = call.argument<Map<String, Any>>("properties").toJsonElement()
    segment.track(eventName, properties)
  }

  private fun screen(call: MethodCall, segment: Analytics) {
    val screenName = call.argument<String>("screenName")!!
    val properties = call.argument<Map<String, Any>>("properties").toJsonElement()
    segment.screen(screenName, properties)
  }

  private fun group(call: MethodCall, segment: Analytics) {
    val groupId = call.argument<String>("groupId")!!
    val traits = call.argument<Map<String, Any>>("traits").toJsonElement()
    segment.group(groupId, traits)
  }

  private fun alias(call: MethodCall, segment: Analytics) {
    val alias = call.argument<String>("alias")!!
    segment.alias(alias)
  }

  private suspend fun anonymousId(result: Result, segment: Analytics) {
    withContext(Dispatchers.IO) {
      result.success(segment.anonymousIdAsync())
    }
  }

  private fun reset(segment: Analytics) {
    segment.reset()
  }

  private fun flush(segment: Analytics) {
    segment.flush()
  }

  private fun parseSegmentContext(call: MethodCall): JsonObject {
    val contextMap = call.argument<Map<String, Any>>("context")
    assert(contextMap != null)
    val contextJson = contextMap.toJsonElement()
    return contextJson.jsonObject
  }
}

fun JsonObject.deepMergeWith(target: JsonObject): JsonObject = deepMerge(this, target)

fun deepMerge(source: JsonObject, target: JsonObject): JsonObject {
  var merged = JsonObject(mapOf())
  val keys = (target.keys + source.keys).toSet()
  for (key in keys) {
    if (target[key]?.safeJsonObject != null && source[key]?.safeJsonObject != null) {
      val targetChild = target[key]!!.jsonObject
      val sourceChild = source[key]!!.jsonObject
      merged = updateJsonObject(merged) {
        it[key] = deepMerge(sourceChild, targetChild)
      }
    } else {
      merged = updateJsonObject(merged) {
        it[key] = target[key] ?: source[key]!!
      }
    }
  }
  return merged
}

fun Any?.toJsonElement(): JsonElement =
  when (this) {
    null -> JsonNull
    is Map<*, *> -> toJsonElement()
    is Collection<*> -> toJsonElement()
    is Boolean -> JsonPrimitive(this)
    is Number -> JsonPrimitive(this)
    is String -> JsonPrimitive(this)
    is Enum<*> -> JsonPrimitive(this.toString())
    else -> throw IllegalStateException("Can't serialize unknown type: $this")
  }

private fun Collection<*>.toJsonElement(): JsonElement {
  val list: MutableList<JsonElement> = mutableListOf()
  this.forEach { value ->
    when (value) {
      null -> list.add(JsonNull)
      is Map<*, *> -> list.add(value.toJsonElement())
      is Collection<*> -> list.add(value.toJsonElement())
      is Boolean -> list.add(JsonPrimitive(value))
      is Number -> list.add(JsonPrimitive(value))
      is String -> list.add(JsonPrimitive(value))
      is Enum<*> -> list.add(JsonPrimitive(value.toString()))
      else -> throw IllegalStateException("Can't serialize unknown collection type: $value")
    }
  }
  return JsonArray(list)
}

private fun Map<*, *>.toJsonElement(): JsonElement {
  val map: MutableMap<String, JsonElement> = mutableMapOf()
  this.forEach { (key, value) ->
    key as String
    when (value) {
      null -> map[key] = JsonNull
      is Map<*, *> -> map[key] = value.toJsonElement()
      is Collection<*> -> map[key] = value.toJsonElement()
      is Boolean -> map[key] = JsonPrimitive(value)
      is Number -> map[key] = JsonPrimitive(value)
      is String -> map[key] = JsonPrimitive(value)
      is Enum<*> -> map[key] = JsonPrimitive(value.toString())
      else -> throw IllegalStateException("Can't serialize unknown type: $value")
    }
  }
  return JsonObject(map)
}
