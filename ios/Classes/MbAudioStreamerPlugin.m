#import "MbAudioStreamerPlugin.h"
#if __has_include(<mb_audio_streamer/mb_audio_streamer-Swift.h>)
#import <mb_audio_streamer/mb_audio_streamer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "mb_audio_streamer-Swift.h"
#endif

@implementation MbAudioStreamerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  [SwiftMbAudioStreamerPlugin registerWithRegistrar:registrar];
}
@end