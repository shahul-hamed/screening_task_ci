import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let CHANNEL = "com.task.screening_ui/installed_apps"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)

        methodChannel.setMethodCallHandler { (call, result) in
            if call.method == "getInstalledApps" {
                // Get installed apps
                let installedApps = self.getInstalledApps()
                if installedApps.count > 0 {
                    result(installedApps) // Return list of installed apps
                } else {
                    result(FlutterError(code: "UNAVAILABLE", message: "Installed apps not available", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func getInstalledApps() -> [String] {
        var appList = [String]()

        // iOS doesn't provide an easy way to get all installed apps like Android does
        // You can access certain apps through `UIApplication.shared` or specific API.
        // However, as of now, there is no direct public API to access all installed apps.
        // A workaround could be showing a list of certain known apps or using specific APIs.

        // In iOS, there isn't a direct way to access all installed apps for security reasons.
        appList.append("com.apple.Maps")
        appList.append("com.apple.Music")

        return appList
    }
}
