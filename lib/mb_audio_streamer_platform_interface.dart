import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mb_audio_streamer_method_channel.dart';

abstract class MbAudioStreamerPlatform extends PlatformInterface {
  /// Constructs a MbAudioStreamerPlatform.
  MbAudioStreamerPlatform() : super(token: _token);

  static final Object _token = Object();

  static MbAudioStreamerPlatform _instance = MethodChannelMbAudioStreamer();

  /// The default instance of [MbAudioStreamerPlatform] to use.
  ///
  /// Defaults to [MethodChannelMbAudioStreamer].
  static MbAudioStreamerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MbAudioStreamerPlatform] when
  /// they register themselves.
  static set instance(MbAudioStreamerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
