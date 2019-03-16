#import <Flutter/Flutter.h>
#import <FlipperKit/FlipperConnection.h>
#import <FlipperKit/FlipperResponder.h>
#import "FlipperReduxInspectorPlugin.h"

@interface FlipperReduxInspectorPlugin ()
@property (nonatomic, strong) id<FlipperConnection> flipperConnection;
@end

@implementation FlipperReduxInspectorPlugin

- (void)didConnect:(id<FlipperConnection>)connection {
    self.flipperConnection = connection;
}

- (void)didDisconnect {
    self.flipperConnection = nil;
}

- (NSString *)identifier {
    return @"ReduxInspector";
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method hasSuffix:@"Report"]) {
        NSDictionary *state = call.arguments[@"state"];

        NSDictionary<NSString *, id> *actionObject = @{
                                                       @"uniqueId": call.arguments[@"uniqueId"],
                                                       @"actionType": call.arguments[@"actionType"],
                                                       @"timeStamp": call.arguments[@"timeStamp"],
                                                       @"state": state ? state : [NSNull null],
                                                       };

        [self.flipperConnection send:@"newAction" withParams:actionObject];
    }
}

#pragma mark - Private methods
@end
