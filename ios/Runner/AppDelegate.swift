import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController
    let icloudChannel = FlutterMethodChannel(name: "com.seungrain.dailyDiary/icloud",
                                             binaryMessenger: controller.binaryMessenger)

    icloudChannel.setMethodCallHandler { (call, result) in
      if call.method == "getICloudPath" {
        if let url = FileManager.default.url(forUbiquityContainerIdentifier: nil) {
          result(url.path)
        } else {
          result(nil)
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
