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
    
//    if (!imagePath) {
//        return;
//    }
    
    if ([@"imageQuality" isEqualToString:call.method]) {
           
        double quality = [call.arguments[@"quality"] doubleValue];
        
        UIImage *image = [UIImage imageWithContentsOfFile:call.arguments[@"imagePath"]];
        
        NSData *data = UIImageJPEGRepresentation(image, quality);
                
        result(@{@"imageData":[FlutterStandardTypedData typedDataWithBytes:data],
                 @"imageLength":@(data.length),
                 @"imageWidth":@(image.size.width),
                 @"imageHeight":@(image.size.height),
                 @"imagePath":imagePath
        });
        
    }
    
    if ([@"imageZoom" isEqualToString:call.method]) {
        
        double maxLength = [call.arguments[@"maxLength"] doubleValue];
        double quality = [call.arguments[@"quality"] doubleValue];
        FlutterStandardTypedData * flutterData = call.arguments[@"imageData"];
        NSData * data = flutterData.data;
        UIImage *dataImage = [UIImage imageWithData:data];
        
        double width = dataImage.size.width;
        double height = dataImage.size.height;
        
        if (width > height && width > maxLength){
            
            height = maxLength / width * height;
            
            width = maxLength;
            
        }else if (width < height && height > maxLength){
            width = maxLength / height * width;
            height = maxLength;
        }
        UIImage * resultImage ;
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [dataImage drawInRect:CGRectMake(0, 0, width, height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        NSData *resultData = UIImageJPEGRepresentation(resultImage, quality);
                     
         result(@{@"imageData":[FlutterStandardTypedData typedDataWithBytes:resultData],
                  @"imageLength":@(resultData.length),
                  @"imageWidth":@(resultImage.size.width),
                  @"imageHeight":@(resultImage.size.height)
         });
        
        
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


-(NSData *)compressWithImage:(UIImage *)image maxDataLength:(NSUInteger)maxDataLength{
    
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    
    if (data.length < maxDataLength){
        return data;
    }
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxDataLength * 0.9) {
            min = compression;
        } else if (data.length > maxDataLength) {
            max = compression;
        } else {
            break;
        }
    }
    if (data.length < maxDataLength){
        return data;
    }
    
    UIImage *resultImage = [UIImage imageWithData:data];
    
    NSUInteger lastDataLength = 0;
    while (data.length > maxDataLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxDataLength / data.length;
    
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return data;
}





@end




