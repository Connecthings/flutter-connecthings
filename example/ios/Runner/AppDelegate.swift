import UIKit
import Flutter
import HerowConnection
import HerowLocationDetection
import ConnectPlaceCommon

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, HerowReceiveNotificationContentDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    let herowInitializer = HerowInitializer.shared
    herowInitializer.configPlatform(Platform.preProdAdtag).configApp(identifier: "plopi", sdkKey: "fSKbCEvCDCbYTDlk").synchronize()
    GlobalLogger.shared.startDebug()
    HerowDetectionManager.shared.registerReceiveNotificatonContentDelegate(self)
    GlobalLogger.shared.debug("herowDetectionManager appDelegate \(HerowDetectionManager.shared)")
    if #available(iOS 10.0, *) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if (error == nil) {
                NSLog("request authorization succeeded!");
            }
        }
    } else if(UIApplication.instancesRespond(to: #selector(UIApplication.registerUserNotificationSettings(_:)))){
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings (types: [.alert, .sound], categories: nil))
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    override func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        HerowDetectionManager.shared.didReceivePlaceNotification(notification.userInfo)
    }

    func didReceivePlaceNotification(_ placeNotification: HerowPlaceNotification) {
        NSLog("open a controller with a place notification")
    }

    func didReceiveWelcomeNotification(_ welcomeNotification: HerowPlaceWelcomeNotification) {
        NSLog("open a controller with a place welcome notification")
    }
}
