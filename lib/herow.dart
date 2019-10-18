import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:io' show Platform;

/// The optins type managed through the SDK
enum OPTIN_TYPE {
  /// All data related to user ids and user location - as default the SDK does not collect these data
  USER_DATA,
  /// All data related to the status of various hardware or sensor or software feature (wifi, bluetooth, location, motion deteciont)- as default the SDK collects these data
  STATUS
}

/// The status of the inAppAction -
enum IN_APP_ACTION_EVENT_STATUS {
  /// The SDK detects the user arrives at a Place (a Geofence zone created on https://my.herow.io
  CREATE,
  /// The SDK detects the user leaves a place
  REMOVE
}

/// Data accessible when a in app action event is detected
class InAppActionEvent {
  InAppActionEvent(this.status, this.id, this.title, this.description, this.tag);
  ///The status of the event
  final IN_APP_ACTION_EVENT_STATUS status;
  /// The id of the place
  final String id;
  /// A title associate to the event
  final String title;
  /// A description associate to the event
  final String description;
  /// A tag related to the place categories (Airport, restaurant, pub etc...)
  final String tag;
}

/// Provides an access to the main methods of the Herow Framework, a framework developped by Connecthings.
class Herow {
  static const MethodChannel _channelPush = const MethodChannel('connecthings.com/herow/push');

  /// Channel used to communicate with native code for the optin methods
  static const MethodChannel _channelOptin =
  const MethodChannel('connecthings.com/herow/optin');

  /// Channel used to communicate with native code for the inAppActions events
  static const EventChannel _channelInAppActions =
  const EventChannel('connecthings.com/herow/inAppActions');


  /***************************************** PUSH *******************************************************/

  static setCustomId(String customId) {
    _channelPush.invokeMethod('setCustomId', { "customId" : customId });
  }

  static registerForRemoteNotifications(bool automaticIntegration) {
    _channelPush.invokeMethod('registerForRemoteNotifications', { "automaticIntegration" : automaticIntegration });
  }

  static  setAppGroupName(String groupName) {
	  if (Platform.isIOS) {
		_channelPush.invokeMethod('setAppGroupName', { "groupName" : groupName });		
	  }
  }

  /// to get the current status of a given optin
  static Future<String> getPushID() async {
    final String pushID = await _channelPush.invokeMethod('getPushID');
    return pushID;
  }

  static removeCustomId() {
    _channelPush.invokeMethod("removeCustomId");
  }

  /***************************************** OPTIN *******************************************************/

  ///return true if the application has never asked the optins to the user
  static Future<bool> get optinsNeverAsked async {
    final bool neverAsked = await _channelOptin.invokeMethod('optinsNeverAsked');
    return neverAsked;
  }

  /// to transmit if the user accepts or denies a given optin
  static updateOptin(OPTIN_TYPE type, bool validate) {
    _channelOptin.invokeMethod('updateOptin', <String, dynamic>{"type": type.toString().split('.').last,
      "validate": validate});
  }

  /// to validate the optins to the SDK after on or several updateOptin
  static allOptinsAreUpdated() {
    _channelOptin.invokeMethod('allOptinsAreUpdated');
  }

  /// to get the current status of a given optin
  static Future<bool> isOptinAuthorized(OPTIN_TYPE type) async {
    final bool all = await _channelOptin.invokeMethod('isOptinAuthorized',
        <String, dynamic>{"type": type.toString().split('.').last});
    return all;
  }


  /***************************************** In App Action *******************************************************/

  InAppActionEvent _convertToInAppctionEvent(Map<String, dynamic> event) {
    return InAppActionEvent(
        "CREATE" == event["status"]?IN_APP_ACTION_EVENT_STATUS.CREATE : IN_APP_ACTION_EVENT_STATUS.REMOVE,
        event["id"],
        event["title"],
        event["description"],
        event["tag"]
    );
  }

  Stream<InAppActionEvent> _inAppActionEvents;

  /// To receive the events related to he inAppAction - a inAppAction is triggered when a user reaches or leaves a place (Beacon or Geofence) configured on Herow (https://my.herow.io)
  Stream<InAppActionEvent> get inAppActionEvents {
    if (_inAppActionEvents == null) {
      _inAppActionEvents = _channelInAppActions
          .receiveBroadcastStream().map(
              (dynamic event) => _convertToInAppctionEvent(Map<String,String>.from(event))
      );
    }
    return _inAppActionEvents;
  }
}