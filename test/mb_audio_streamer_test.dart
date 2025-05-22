import 'package:flutter_test/flutter_test.dart';
import 'package:mb_audio_streamer/mb_audio_streamer.dart';
import 'package:mb_audio_streamer/mb_audio_streamer_platform_interface.dart';
import 'package:mb_audio_streamer/mb_audio_streamer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMbAudioStreamerPlatform
    with MockPlatformInterfaceMixin
    implements MbAudioStreamerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MbAudioStreamerPlatform initialPlatform =
      MbAudioStreamerPlatform.instance;

  test('$MethodChannelMbAudioStreamer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMbAudioStreamer>());
  });

  test('getPlatformVersion', () async {
    MBAudioStreamer mbAudioStreamerPlugin = MBAudioStreamer();
    MockMbAudioStreamerPlatform fakePlatform = MockMbAudioStreamerPlatform();
    MbAudioStreamerPlatform.instance = fakePlatform;

    expect(await mbAudioStreamerPlugin.sampleRate, 44100);
  });
}
