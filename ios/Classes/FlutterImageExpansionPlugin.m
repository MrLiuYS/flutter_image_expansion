#import "FlutterImageExpansionPlugin.h"

#import "BitmapUtil.h"

@implementation FlutterImageExpansionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_image_expansion"
            binaryMessenger:[registrar messenger]];
  FlutterImageExpansionPlugin* instance = [[FlutterImageExpansionPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString * imagePath = call.arguments[@"imagePath"];
    
    if (!imagePath) {
        return;
    }
    
    if ([@"getImageLongitude" isEqualToString:call.method]) {
        
        result([BitmapUtil getImageLongitude:imagePath]);
        
    }
    if ([@"getImageLatitude" isEqualToString:call.method]) {
        result([BitmapUtil getImageLatitude:imagePath]);
    }
    if ([@"getImagePhotoTime" isEqualToString:call.method]) {
        result([BitmapUtil getImagePhotoTime:imagePath]);
    }
    if ([@"getImageAllInfo" isEqualToString:call.method]) {
        result([BitmapUtil getImageAllInfo:imagePath]);
    }
    if ([@"saveImageInfo" isEqualToString:call.method]) {
//        [self saveImageInfo:call result:result];
        
        NSDictionary *map = call.arguments[@"map"];
        if (map) {
            result(@([BitmapUtil saveImageInfo:imagePath map:map]));
        }
        result(@(NO));
        
    }
    
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}


//- (void)getImageLongitude:(FlutterMethodCall*)call result:(FlutterResult)result {
//
////    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
//
//
//}
//- (void)getImageLatitude:(FlutterMethodCall*)call result:(FlutterResult)result {
//
//}
//- (void)getImagePhotoTime:(FlutterMethodCall*)call result:(FlutterResult)result {
//
//}
//- (void)getImageAllInfo:(FlutterMethodCall*)call result:(FlutterResult)result {
//
//}
//- (void)saveImageInfo:(FlutterMethodCall*)call result:(FlutterResult)result {
//
//}


@end
