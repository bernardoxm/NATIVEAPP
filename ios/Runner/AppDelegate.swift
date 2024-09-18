import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let nativoChannel = FlutterMethodChannel(name: "meuapp.com.br/nativo", binaryMessenger: controller.binaryMessenger)
    
    nativoChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard call.method == "calcSum" else {
        result(FlutterMethodNotImplemented)
        return
      }
      
      if let args = call.arguments as? [String: Any],
         let a = args["a"] as? Int,
         let b = args["b"] as? Int {
        result(a + b) // Retorna a soma de `a` e `b`
      } else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Argumentos inválidos", details: nil)) // Retorna um erro se os argumentos forem inválidos
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
