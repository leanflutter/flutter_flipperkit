#import "FlutterFlipperkitPlugin.h"

@implementation FlutterFlipperkitPlugin {
}

- (instancetype)init
{
    self = [super init];
    if (self) {
      // TODO:
    }
    return self;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_flipperkit"
            binaryMessenger:[registrar messenger]];
  FlutterFlipperkitPlugin* instance = [[FlutterFlipperkitPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"clientAddPlugin" isEqualToString:call.method]) {
    [self clientAddPlugin:call result:result];
  } else if ([@"clientStart" isEqualToString:call.method]) {
    [self clientStart:call result:result];
  } else if ([@"clientStart" isEqualToString:call.method]) {
    [self clientStop:call result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void) clientAddPlugin:(FlutterMethodCall*)call result:(FlutterResult)result {
//    result(YES);
}

- (void) clientStart:(FlutterMethodCall*)call result:(FlutterResult)result {
//    result(YES);
}

- (void) clientStop:(FlutterMethodCall*)call result:(FlutterResult)result {
//    result(YES);
}

- (void) pluginNetworkReportRequest:(FlutterMethodCall*)call result:(FlutterResult)result {
//    result(YES);
}

- (void) pluginNetworkReportResponse:(FlutterMethodCall*)call result:(FlutterResult)result {
//    result(YES);
}

@end
