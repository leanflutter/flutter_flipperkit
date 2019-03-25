#import <Foundation/Foundation.h>
#import <FlipperKit/FlipperPlugin.h>
#import <FlipperKit/FlipperConnection.h>
#import <FlipperKit/FlipperResponder.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlipperDatabaseBrowserPlugin : NSObject <FlipperPlugin>
- (void)setEventSink:(FlutterEventSink) eventSink;
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
@end

NS_ASSUME_NONNULL_END
