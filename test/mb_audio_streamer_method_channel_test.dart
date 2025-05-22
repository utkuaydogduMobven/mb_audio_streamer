import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mb_audio_streamer/mb_audio_streamer_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMbAudioStreamer platform = MethodChannelMbAudioStreamer();
  const MethodChannel channel = MethodChannel('mb_audio_streamer');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
