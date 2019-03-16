#import <Foundation/Foundation.h>
#import <FlipperKit/FlipperPlugin.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlipperReduxInspectorPlugin : NSObject <FlipperPlugin>
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
@end

NS_ASSUME_NONNULL_END
