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
        NSDictionary *payload = call.arguments[@"payload"];
        NSDictionary *prevState = call.arguments[@"prevState"];
        NSDictionary *nextState = call.arguments[@"nextState"];

        NSDictionary<NSString *, id> *actionObject = @{
                                                       @"uniqueId": call.arguments[@"uniqueId"],
                                                       @"actionType": call.arguments[@"actionType"],
                                                       @"timeStamp": call.arguments[@"timeStamp"],
                                                       @"payload": payload ? payload : [NSNull null],
                                                       @"prevState": prevState ? prevState : [NSNull null],
                                                       @"nextState": nextState ? nextState : [NSNull null],
                                                       };

        [self.flipperConnection send:@"newAction" withParams:actionObject];
    }
}

#pragma mark - Private methods
@end
