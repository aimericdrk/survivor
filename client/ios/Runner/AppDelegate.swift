import UIKit
import Flutter
import WatchConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var session: WCSession?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        initFlutterChannel()
        if WCSession.isSupported() {
            session = WCSession.default;
            session?.delegate = self;
            session?.activate();
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func initFlutterChannel() {
        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(
                name: "com.soul.connection",
                binaryMessenger: controller.binaryMessenger)

            channel.setMethodCallHandler({ [weak self] (
                call: FlutterMethodCall,
                result: @escaping FlutterResult) -> Void in
                switch call.method {
                case "flutterToWatch":
                    guard let watchSession = self?.session,
                          watchSession.isPaired,
                          watchSession.isReachable,
                          let methodData = call.arguments as? [String: Any],
                          let method = methodData["method"] as? String,
                          let datas = methodData["datas"] as? [String: Any] else {
                        result(false)
                        return
                    }
                      if let tips = datas["tips"] as? [[String: Any]] {
                        let watchData: [String: Any] = [
                            "method": method,
                            "tips": tips,
                        ]
                        watchSession.sendMessage(watchData, replyHandler: nil, errorHandler: { error in
                            print("Error sending message to Watch: \(error.localizedDescription)")
                        })
                        result(true)
                    } else {
                        result(false)
                    }
                default:
                    result(FlutterMethodNotImplemented)
                }
            })
        }
    }
}

extension AppDelegate: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }
    override func applicationDidFinishLaunching(_ application: UIApplication) {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    func sessionDidDeactivate(_ session: WCSession) {

    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        NSLog("Received message on iOS: \(message)")
        DispatchQueue.main.async {
            if let method = message["method"] as? String, let controller = self.window?.rootViewController as? FlutterViewController {
                let channel = FlutterMethodChannel(
                    name: "com.soul.connection",
                    binaryMessenger: controller.binaryMessenger)
                channel.invokeMethod(method, arguments: message)
            }
        }
    }
}
