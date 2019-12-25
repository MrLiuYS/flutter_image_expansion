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
    
    NSLog(@"call.arguments : %@",call.arguments);
    
    // 图片data
    NSData * imageData;
    
    // 图片路径
    NSString *imagePath = @"";
    
    FlutterStandardTypedData * flutterData = call.arguments[@"imageData"];
    
    if (flutterData) {
        
        imageData = flutterData.data;
        
    }else {
        
        NSString * pImagePath = call.arguments[@"imagePath"];

        if (pImagePath) {
            imagePath = pImagePath;
            imageData = [NSData dataWithContentsOfFile:imagePath];
        }
    }
    if (!imageData) {
        result(FlutterMethodNotImplemented);
        return;
    }
    
    // 图片
    UIImage * image = [UIImage imageWithData:imageData];
    
    // 获取图片的exif
    NSDictionary * imageExif;
    
    // 是否保留图片信息
    bool keepExif = [call.arguments[@"keepExif"] boolValue];
    
    if (keepExif) {
        
        imageExif = [BitmapUtil getImageAllInfoFromData:imageData];
    }
    
    // 图片压缩
    if([@"imageCompress" isEqualToString:call.method]){
        
        if (call.arguments[@"maxImageLength"]) {
            double maxImageLength = [call.arguments[@"maxImageLength"] doubleValue];
            if (maxImageLength < image.size.width || maxImageLength < image.size.height) {
                image = [self imageZoomImage:image maxImageLength:maxImageLength];
            }
        }

        // 图片大小最大值
        double maxDataLength = [call.arguments[@"maxDataLength"] doubleValue];
        
        NSData * data = [self compressWithImage:image maxDataLength:maxDataLength];
        
        if (imageExif) {
            
            data = [BitmapUtil saveImageInfoFromData:data map:imageExif];
            
        }
        
        image = [UIImage imageWithData:data];
        
        result(@{@"imageData":[FlutterStandardTypedData typedDataWithBytes:data],
                 @"dataLength":@(data.length),
                 @"imageWidth":@(image.size.width),
                 @"imageHeight":@(image.size.height),
                 @"imagePath":imagePath});
        
    }
    
    if ([@"imageQuality" isEqualToString:call.method]) {

        double quality = [call.arguments[@"quality"] doubleValue];

        NSData *data = UIImageJPEGRepresentation(image, quality);
        
        if (imageExif) {
                   
           data = [BitmapUtil saveImageInfoFromData:data map:imageExif];

        }

        result(@{@"imageData":[FlutterStandardTypedData typedDataWithBytes:data],
                 @"dataLength":@(data.length),
                 @"imageWidth":@(image.size.width),
                 @"imageHeight":@(image.size.height),
                 @"imagePath":imagePath});

    }

    if ([@"imageZoom" isEqualToString:call.method]) {

        double maxImageLength = 1920;
        if (call.arguments[@"maxImageLength"]) {
           maxImageLength = [call.arguments[@"maxImageLength"] doubleValue];
        }
        
        double quality = 1;
        
        if (call.arguments[@"quality"]) {
           quality = [call.arguments[@"quality"] doubleValue];
        }
        
        UIImage *resultImage = [self imageZoomImage:image maxImageLength:maxImageLength];
        
        NSData *resultData = UIImageJPEGRepresentation(resultImage, quality);

        result(@{@"imageData":[FlutterStandardTypedData typedDataWithBytes:resultData],
                @"dataLength":@(resultData.length),
                @"imageWidth":@(resultImage.size.width),
                @"imageHeight":@(resultImage.size.height)});

    }
    
    if ([@"getImageLongitude" isEqualToString:call.method]) {
        
        result([BitmapUtil getImageLongitudeFromData:imageData]);
        
    }
    if ([@"getImageLatitude" isEqualToString:call.method]) {
        result([BitmapUtil getImageLatitudeFromData:imageData]);
    }
    if ([@"getImagePhotoTime" isEqualToString:call.method]) {
        result([BitmapUtil getImagePhotoTimeFromData:imageData]);
    }
    if ([@"getImageAllInfo" isEqualToString:call.method]) {
        result([BitmapUtil getImageAllInfoFromData:imageData]);
    }
    if ([@"saveImageInfo" isEqualToString:call.method]) {
        
        NSDictionary *map = call.arguments[@"map"];
        if (map) {
            
            imageData = [BitmapUtil saveImageInfoFromData:imageData map:map];
            
            result(@{@"imageData":[FlutterStandardTypedData typedDataWithBytes:imageData],
                    @"dataLength":@(imageData.length)});
            
        }else {
            result(@{@"imageData":[FlutterStandardTypedData typedDataWithBytes:imageData],
                    @"dataLength":@(imageData.length)});
        }

    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (UIImage *)imageZoomImage:(UIImage *)image maxImageLength:(double)maxImageLength {
    
    double width = image.size.width;
    double height = image.size.height;

    if (width > height && width > maxImageLength){

        height = maxImageLength / width * height;

        width = maxImageLength;

    }else if (width < height && height > maxImageLength){
        
        width = maxImageLength / height * width;
        
        height = maxImageLength;
    }else {
        return image;
    }
    UIImage * resultImage ;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}


- (NSData *)compressWithImage:(UIImage *)image maxDataLength:(NSUInteger)maxDataLength{
    
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



