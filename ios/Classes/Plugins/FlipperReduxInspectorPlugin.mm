#import <Flutter/Flutter.h>
#import <FlipperKit/FlipperConnection.h>
#import <FlipperKit/FlipperResponder.h>
#import "SKBufferingPlugin+CPPInitialization.h"
#import "FlipperReduxInspectorPlugin.h"

@implementation FlipperReduxInspectorPlugin

- (instancetype)init {
    if (self = [super initWithQueue:dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)]) {
    }
    return self;
}

- (NSString *)identifier {
    return @"flipper-plugin-reduxinspector";
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

        [self send:@"newAction" sonarObject:actionObject];
    }
    result([NSNumber numberWithBool:YES]);
}

#pragma mark - Private methods
@end
