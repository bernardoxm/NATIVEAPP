# native

This app is a simple demonstration of communication between Flutter and native apps, using a calculator. It showcases the integration of Flutter with Kotlin and Flutter with Swift UI.

## Getting Started

# Flutter Native Method Channel Example

## Overview
This method handles the calculation process by awaiting the result from the native method channel, either in Swift for iOS or Kotlin for Android.

dart
Future<void> _calSum() async {
  const channel = MethodChannel('meuapp.com.br/nativo');

  try {
    final sum = await channel.invokeMethod('calcSum', {"a": _a, "b": _b});
    setState(() {
      _sum = sum;
    });
  } on PlatformException {
    setState(() {
      _sum = 0;
    });
  }

  setState(() {
    _sum = _a + _b;
  });
}

## Explanation
In this code, the method sends the values _a and _b to the native platform via a method channel. The native code (Swift for iOS or Kotlin for Android) performs the calculation and returns the result. The app then updates its state with the result, or sets the sum to 0 if there’s an error. Additionally, a local calculation is performed as a fallback.


##APPDELEGATE.SWIFT
# Native Swift Method Channel Implementation

## Overview
This code sets up a method channel in Swift to communicate with a Flutter application. The method receives parameters from the Flutter side and returns the result, or an error if the input is invalid.

## Swift Code Implementation

import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Access the FlutterViewController
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    // Create a method channel named 'meuapp.com.br/nativo'
    let nativoChannel = FlutterMethodChannel(name: "meuapp.com.br/nativo", binaryMessenger: controller.binaryMessenger)
    // Set up the method call handler
    nativoChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      // Check if the method is 'calcSum'
      guard call.method == "calcSum" else {
        result(FlutterMethodNotImplemented)
        return
      }
      // Extract the arguments and perform the sum
      if let args = call.arguments as? [String: Any],
         let a = args["a"] as? Int,
         let b = args["b"] as? Int {
        result(a + b) // Return the sum of `a` and `b`
      } else {
        // Return an error if the arguments are invalid
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Argumentos inválidos", details: nil))
      }
    }
    // Register the generated plugins
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

##Explanation

Method Channel: The FlutterMethodChannel is used to establish communication between Flutter and native iOS (Swift).

Method Handler: The setMethodCallHandler listens for method calls from the Flutter side. In this example, it handles the calcSum method.

Error Handling: If the arguments are invalid or the method is not implemented, appropriate errors are returned to the Flutter side.

This native Swift code integrates with the Flutter app via the method channel named "meuapp.com.br/nativo". It expects two integer arguments, a and b, to calculate their sum and return it to the Flutter app. If invalid arguments are provided, it 

returns a FlutterError.


##MAINACTIVITY.KT
# Native Kotlin Method Channel Implementation

## Overview
This Kotlin code integrates the Flutter app with native Android functionality through a method channel. The method receives parameters from Flutter and performs a sum operation, returning the result to the Flutter app.

## Kotlin Code Implementation


package com.example.nativoapp
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // Define the method channel name
    private val CHANNEL = "meuapp.com.br/nativo"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Set up the method channel to listen for method calls
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            // Handle the 'calcSum' method
            if (call.method == "calcSum") {
                val a = call.argument<Int>("a") ?: 0
                val b = call.argument<Int>("b") ?: 0
                result.success(a + b) // Return the sum of `a` and `b`
            } else {
                // If the method is not implemented, return an error
                result.notImplemented()
            }
        }
    }
}


##Explanation

Method Channel: The MethodChannel is used to establish communication between Flutter and native Android (Kotlin). The channel name is defined as "meuapp.com.br/nativo".

Method Handler: The setMethodCallHandler listens for method calls from the Flutter side. In this case, it listens for the calcSum method.

Arguments and Sum Operation: The method expects two integer arguments, a and b, which are used to compute the sum. If these values are missing, the default is set to 0.

Error Handling: If an unimplemented method is called, the result.notImplemented() method is invoked to handle the error.

This Kotlin code is responsible for receiving method calls from Flutter, performing the sum calculation, and sending the result back to the Flutter app.

