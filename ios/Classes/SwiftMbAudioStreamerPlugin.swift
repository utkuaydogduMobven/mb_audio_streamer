import AVFoundation
import Flutter
import UIKit

public class SwiftMbAudioStreamerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

  private var eventSink: FlutterEventSink?
  var engine = AVAudioEngine()
  var audioData: [Float] = []
  var recording = false
  var preferredSampleRate: Int? = nil

  // Register plugin
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftMbAudioStreamerPlugin()

    // Set flutter communication channel for emitting updates
    let eventChannel = FlutterEventChannel.init(
      name: "mb_audio_streamer.eventChannel", binaryMessenger: registrar.messenger())
    // Set flutter communication channel for receiving method calls
    let methodChannel = FlutterMethodChannel.init(
      name: "mb_audio_streamer.methodChannel", binaryMessenger: registrar.messenger())
    methodChannel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) -> Void in
      if call.method == "getSampleRate" {
        // Return sample rate that is currently being used, may differ from requested
        result(Int(AVAudioSession.sharedInstance().sampleRate))
      }
    }
    eventChannel.setStreamHandler(instance)
    instance.setupNotifications()
  }

  private func setupNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleInterruption(notification:)),
      name: AVAudioSession.interruptionNotification,
      object: nil)
  }

  @objc func handleInterruption(notification: Notification) {
    guard let sink = eventSink else {
      return
    }

    guard let userInfo = notification.userInfo,
      let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
      let type = AVAudioSession.InterruptionType(rawValue: typeValue)
    else {
      return
    }

    switch type {
    case .began:
      break
    case .ended:
      guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {
        return
      }
      let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
      if options.contains(.shouldResume) {
        startRecording(sampleRate: preferredSampleRate)
      }
    default:
      sink(
        FlutterError(
          code: "100",
          message: "Recording was interrupted",
          details: "Another process interrupted recording."))
    }
  }

  private func emitValues(values: [Float]) {
    guard let sink = eventSink else {
      return
    }
    sink(values)
  }

  public func onListen(
    withArguments arguments: Any?,
    eventSink: @escaping FlutterEventSink
  ) -> FlutterError? {
    self.eventSink = eventSink
    if let args = arguments as? [String: Any] {
      preferredSampleRate = args["sampleRate"] as? Int
      startRecording(sampleRate: preferredSampleRate)
    } else {
      startRecording(sampleRate: nil)
    }
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    NotificationCenter.default.removeObserver(self)
    eventSink = nil
    engine.stop()
    return nil
  }

  func startRecording(sampleRate: Int?) {
    guard let sink = eventSink else {
      print("⚠️ EventSink is nil. Aborting startRecording.")
      return
    }

    engine = AVAudioEngine()

    do {
      try AVAudioSession.sharedInstance().setCategory(
        AVAudioSession.Category.playAndRecord,
        options: .mixWithOthers)
      try AVAudioSession.sharedInstance().setActive(true)

      if let sampleRateNotNull = sampleRate {
        try AVAudioSession.sharedInstance().setPreferredSampleRate(Double(sampleRateNotNull))
      }

      let input = engine.inputNode
      let bus = 0

      input.installTap(onBus: bus, bufferSize: 22050, format: input.inputFormat(forBus: bus)) {
        buffer, _ in
        let samples = buffer.floatChannelData?[0]
        let arr = Array(UnsafeBufferPointer(start: samples, count: Int(buffer.frameLength)))
        self.emitValues(values: arr)
      }

      try engine.start()
    } catch {
      sink(
        FlutterError(
          code: "100",
          message: "Unable to start audio session",
          details: error.localizedDescription))
    }
  }
}
