#import "FlutterFlipperkitPlugin.h"
#import <FlipperKit/FlipperClient.h>
#import <FlipperKitUserDefaultsPlugin/FKUserDefaultsPlugin.h>
#import <FlipperKitNetworkPlugin/FlipperKitNetworkPlugin.h>
#import <SKIOSNetworkPlugin/SKIOSNetworkAdapter.h>

@implementation FlutterFlipperkitPlugin {
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//      FlipperClient *client = [FlipperClient sharedClient];
//      [client addPlugin:[[FKUserDefaultsPlugin alloc] initWithSuiteName:nil]];  [client start];
//      [client addPlugin: [[FlipperKitNetworkPlugin alloc] initWithNetworkAdapter:[SKIOSNetworkAdapter new]]];
//      [client start];
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
  } else if ([@"pluginNetworkReportRequest" isEqualToString:call.method]) {
    [self pluginNetworkReportRequest:call result:result];
  } else if ([@"pluginNetworkReportResponse" isEqualToString:call.method]) {
    [self clientStop:call result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void) clientAddPlugin:(FlutterMethodCall*)call result:(FlutterResult)result {
    result([NSNumber numberWithBool:YES]);
}

- (void) clientStart:(FlutterMethodCall*)call result:(FlutterResult)result {
    result([NSNumber numberWithBool:YES]);
}

- (void) clientStop:(FlutterMethodCall*)call result:(FlutterResult)result {
    result([NSNumber numberWithBool:YES]);
}

- (void) pluginNetworkReportRequest:(FlutterMethodCall*)call result:(FlutterResult)result {
    result([NSNumber numberWithBool:YES]);
}

- (void) pluginNetworkReportResponse:(FlutterMethodCall*)call result:(FlutterResult)result {
    result([NSNumber numberWithBool:YES]);
}

@end
