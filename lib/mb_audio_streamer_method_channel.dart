import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mb_audio_streamer_platform_interface.dart';

/// An implementation of [MbAudioStreamerPlatform] that uses method channels.
class MethodChannelMbAudioStreamer extends MbAudioStreamerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mb_audio_streamer');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
