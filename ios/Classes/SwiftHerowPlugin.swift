import Flutter
import UIKit
import HerowConnection
import ConnectPlaceCommon
import ConnectPlaceActions
import HerowLocationDetection

public class SwiftHerowPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftHerowPlugin()

        let channel = FlutterMethodChannel(name: "connecthings.com/herow/optin", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)

        let pushMethodChannel = FlutterMethodChannel(name: "connecthings.com/herow/push", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: pushMethodChannel)

        let channelEvent = FlutterEventChannel(name: "connecthings.com/herow/inAppActions", binaryMessenger: registrar.messenger())
        channelEvent.setStreamHandler(InAppActionStreamHandler())
    }

    let herowInitializer: HerowInitializer

    public override init() {
        self.herowInitializer = HerowInitializer.shared
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        GlobalLogger.shared.debug("herowPlugin - method: \(call.method)")
        switch call.method {
        case "optinsNeverAsked":
            result(self.herowInitializer.optinsNeverAsked())
            break
        case "setCustomId":
            if (proceedArguments(call: call, result: result, keys: [ "customId"])) {
             if let arguments = call.arguments, let arg = arguments as? [String: Any] {
                if let value: String = arg["customId"] as? String {
                  self.herowInitializer.setCustomId(value)
                  }
             }
            }
            break
        case "getPushID":
           result(self.herowInitializer.userManager.getPushID())
            break
        case "registerForRemoteNotifications":
            if (proceedArguments(call: call, result: result, keys: [ "automaticIntegration"])) {
                if let arguments = call.arguments, let arg = arguments as? [String: Any] {
                    if let value: Bool = arg["automaticIntegration"] as? Bool {
                        self.herowInitializer.registerForRemoteNotifications(automaticIntegration:value)
                    }
                }
            }
            break
        case "setAppGroupName":
            if (proceedArguments(call: call, result: result, keys: [ "groupName"])) {
                if let arguments = call.arguments, let arg = arguments as? [String: Any] {
                    if let value: String = arg["groupName"] as? String {
                        self.herowInitializer.setAppGroupName(groupName:value)
                    }
                }
            }
            break
        case "removeCustomId":
            self.herowInitializer.removeCustomId()
            break

        case "allOptinsAreUpdated":
            self.herowInitializer.allOptinsAreUpdated()
            break
        case "updateOptin":
            if (proceedArguments(call: call, result: result, keys: ["type", "validate"])) {
                if let arguments = call.arguments,
                    let arg = arguments as? [String: Any] {
                    let type = arg["type"] as! String == "USER_DATA" ? Optin.USER_DATA : Optin.STATUS
                    let value: Bool = arg["validate"] as! Bool
                    herowInitializer.updateOptin(type, permission: value)
                }
            }
            break
        case "isOptinAuthorized":
            if (proceedArguments(call: call, result: result, keys: ["type"])) {
                if let arguments = call.arguments,
                    let arg = arguments as? [String: Any] {
                    let type = arg["type"] as! String == "USER_DATA" ? Optin.USER_DATA : Optin.STATUS
                    result(herowInitializer.isOptinAuthorized(type))
                }
            }
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func proceedArguments(call: FlutterMethodCall, result: @escaping FlutterResult, keys: [String]) -> Bool {
        if let arguments = call.arguments,
            let arg = arguments as? [String: Any] {
            for key in keys {
                if arg[key] == nil {
                    result(FlutterError(code: "ARGUMENT_ERRROR", message: "Key \(key) is empty", details: nil))
                    return false
                }
            }
        } else if (call.arguments == nil) {
            result(FlutterError(code: "ARGUMENT_ERRROR", message: "Arguements is empty", details: nil))
            return false
        }
        return true
    }

}

class InAppActionStreamHandler: NSObject, FlutterStreamHandler {

    var inAppActionDetection: FlutterInAppActionDetection?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        let inAppActionDetection = FlutterInAppActionDetection(events: events)
        HerowDetectionManager.shared.registerInAppActionDelegate(inAppActionDetection)
        self.inAppActionDetection = inAppActionDetection
        GlobalLogger.shared.debug("herowDetectionManager \(HerowDetectionManager.shared)")
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        HerowDetectionManager.shared.unregisterInAppActionDelegate()
        inAppActionDetection = nil
        return nil
    }


}

class FlutterInAppActionDetection: NSObject, HerowInAppActionDelegate {
    let events: FlutterEventSink

    init(events: @escaping FlutterEventSink) {
        self.events = events
    }

    func createInAppAction(_ placeInAppAction: HerowPlaceInAppAction, statusManager: InAppActionStatusManagerDelegate) -> Bool {
        var content: [String: String] = [:]
        content["status"] = "CREATE"
        content["id"] = placeInAppAction.getPlaceId() as String
        content["title"] = placeInAppAction.getTitle()
        content["description"] = placeInAppAction.getDescription()
        content["tag"] = placeInAppAction.getTag()
        events(content)
        return true
    }

    func removeInAppAction(_ placeInAppAction: HerowPlaceInAppAction, inAppActionRemoveStatus: InAppActionRemoveStatus) -> Bool {
        var content: [String: String] = [:]
        content["status"] = "REMOVE"
        content["id"] = placeInAppAction.getPlaceId() as String
        content["title"] = placeInAppAction.getTitle()
        content["description"] = placeInAppAction.getDescription()
        content["tag"] = placeInAppAction.getTag()
        events(content)
        return true
    }
}
