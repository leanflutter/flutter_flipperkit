#import <Foundation/Foundation.h>
#import <FlipperKit/FlipperPlugin.h>
#import <FlipperKitNetworkPlugin/SKBufferingPlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlipperReduxInspectorPlugin : SKBufferingPlugin
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
@end

NS_ASSUME_NONNULL_END
