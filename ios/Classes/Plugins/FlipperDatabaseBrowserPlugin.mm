#import <Flutter/Flutter.h>
#import <FlipperKit/FlipperConnection.h>
#import <FlipperKit/FlipperResponder.h>
#import "FlipperDatabaseBrowserPlugin.h"

@interface FlipperDatabaseBrowserPlugin ()
@property (nonatomic, strong) id<FlipperConnection> flipperConnection;
@end

@implementation FlipperDatabaseBrowserPlugin {
    FlutterEventSink _eventSink;
}

- (void)didConnect:(id<FlipperConnection>)connection {
    self.flipperConnection = connection;
    [self.flipperConnection receive:@"execQuery" withBlock:^(NSDictionary *params, id<FlipperResponder> responder) {
        _eventSink(params);
        [responder success:@{}];
    }];
}

- (void)didDisconnect {
    self.flipperConnection = nil;
}

- (NSString *)identifier {
    return @"flipper-plugin-dbbrowser";
}

- (void)setEventSink:(FlutterEventSink) eventSink {
    _eventSink = eventSink;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method hasSuffix:@"ReportQueryResult"]) {
        NSDictionary *results = call.arguments[@"results"];
        NSDictionary<NSString *, id> *queryResultObject = @{
                                                       @"action": call.arguments[@"action"],
                                                       @"table": call.arguments[@"table"],
                                                       @"results": results ? results : [NSNull null],
                                                       };

        [self.flipperConnection send:@"newQueryResult" withParams:queryResultObject];
    }
    
    result([NSNumber numberWithBool:YES]);
}

#pragma mark - Private methods
@end
