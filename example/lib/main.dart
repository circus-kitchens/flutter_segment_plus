import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_segment_plus/flutter_segment_plus.dart';
import 'package:flutter_segment_plus/segment_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterSegmentPlusPlugin = FlutterSegmentPlus();
  String anonymousId = '';

  @override
  void initState() {
    super.initState();
    unawaited(_flutterSegmentPlusPlugin.config(
      options: SegmentConfig(
        writeKey: Platform.isAndroid
            ? const String.fromEnvironment('ANDROID_SEGMENT_WRITE_KEY')
            : const String.fromEnvironment('IOS_SEGMENT_WRITE_KEY'),
        trackApplicationLifecycleEvents: true,
        collectDeviceId: true,
      ),
    ));
  }

  Future<void> addContext() async {
    await _flutterSegmentPlusPlugin.setContext(
      {
        'context-additional bool field': true,
        'context-additional num field': .3,
        'context-additional string field': 'test',
        'context-nested': {'element': 'nested'},
        'context-array': [1, .3, 'test', false],
        'traits': {
          'customTrait': true,
        },
        'device': {
          'customTrait': 1234321,
        },
      },
    );
  }

  Future<void> identify() async {
    await _flutterSegmentPlusPlugin.identify(
      userId: 'test-userId',
      traits: {
        'additional bool field': true,
        'additional num field': .3,
        'additional string field': 'test',
        'nested': {'element': 'nested'},
        'array': [1, .3, 'test', false]
      },
    );
  }

  Future<void> track() async {
    await _flutterSegmentPlusPlugin
        .track(eventName: 'testEvent', properties: {'customProperty': true});
  }

  Future<void> screen() async {
    await _flutterSegmentPlusPlugin.screen(screenName: 'test-screen');
  }

  Future<void> group() async {
    await _flutterSegmentPlusPlugin.group(
      groupId: 'test-group',
      traits: {
        'group-trait': 1,
      },
    );
  }

  Future<void> alias() async {
    await _flutterSegmentPlusPlugin.alias(alias: 'test-alias');
  }

  Future<void> getAnonymousId() async {
    final id = await _flutterSegmentPlusPlugin.getAnonymousId;
    setState(() {
      anonymousId = id ?? '?';
    });
  }

  Future<void> reset() async {
    await _flutterSegmentPlusPlugin.reset();
  }

  Future<void> flush() async {
    await _flutterSegmentPlusPlugin.flush();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(children: [
          TextButton(
            onPressed: identify,
            child: const Text('identify'),
          ),
          TextButton(
            onPressed: track,
            child: const Text('track'),
          ),
          TextButton(
            onPressed: addContext,
            child: const Text('setContext'),
          ),
          TextButton(
            onPressed: screen,
            child: const Text('screen'),
          ),
          TextButton(
            onPressed: group,
            child: const Text('group'),
          ),
          TextButton(
            onPressed: alias,
            child: const Text('alias'),
          ),
          TextButton(
            onPressed: getAnonymousId,
            child: Text('getAnonymousId - $anonymousId'),
          ),
          TextButton(
            onPressed: reset,
            child: const Text('reset'),
          ),
          TextButton(
            onPressed: flush,
            child: const Text('flush'),
          ),
        ]),
      ),
    );
  }
}
