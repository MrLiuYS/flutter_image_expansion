//
//  BitmapUtil.m
//  flutter_image_expansion
//
//  Created by 刘永生 on 2019/7/24.
//

#import "BitmapUtil.h"

@implementation BitmapUtil


+ (NSString *)getImageLongitudeFromData:(NSData *)data{
    
    NSString * longitude = @"";
    
    NSDictionary * metaDataDic = [BitmapUtil getImageAllInfoFromData:data];
    
    NSMutableDictionary *GPSDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyGPSDictionary]mutableCopy];
    
    if (GPSDic[(NSString *)kCGImagePropertyGPSLongitude]) {
        
         longitude = [NSString stringWithFormat:@"%@",GPSDic[(NSString *)kCGImagePropertyGPSLongitude]];
        
//        longitude = GPSDic[(NSString *)kCGImagePropertyGPSLongitude];
    }
    

    return longitude;
}

+ (NSString *)getImageLatitudeFromData:(NSData *)data{
    
    NSString * latitude = @"";
    
    NSDictionary * metaDataDic = [BitmapUtil getImageAllInfoFromData:data];
    
    NSMutableDictionary *GPSDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyGPSDictionary]mutableCopy];
    
    if (GPSDic[(NSString *)kCGImagePropertyGPSLatitude]) {
        latitude = [NSString stringWithFormat:@"%@",GPSDic[(NSString *)kCGImagePropertyGPSLatitude]];
    }
    
    return latitude;
}

+ (NSString *)getImagePhotoTimeFromData:(NSData *)data;{
    
    NSString * photoTime = @"";
    
    NSDictionary * metaDataDic = [BitmapUtil getImageAllInfoFromData:data];
    
    NSMutableDictionary *exifDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyExifDictionary]mutableCopy];
    
    if (exifDic[(NSString *)kCGImagePropertyGPSLatitude]) {
        
        photoTime = [NSString stringWithFormat:@"%@",exifDic[(NSString *)kCGImagePropertyGPSLatitude]];
    }
    
    return photoTime;
}

////获取图片所有的信息
//+ (NSDictionary *)getImageAllInfoFromPath:(NSString *)imagePath{
//    
//    NSData *data = [NSData dataWithContentsOfFile:imagePath];
//
//    return [self  getImageAllInfoFromData:data];
//}

//获取图片所有的信息
+ (NSDictionary *)getImageAllInfoFromData:(NSData *)data{
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    NSDictionary *imageInfo = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    
    NSMutableDictionary *metaDataDic = [imageInfo mutableCopy];
    
    return metaDataDic;
}


//+ (BOOL)saveImageInfoFromPath:(NSString *)imagePath map:(NSDictionary *)map{
//    
//    NSData *data = [NSData dataWithContentsOfFile:imagePath];
//    
//    return  [self saveImageInfoFromData:data map:map];
//    
//}

+ (NSMutableData *)saveImageInfoFromData:(NSData *)data map:(NSDictionary *)map {
    
    NSMutableData *newImageData;
    
    @try {
        
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
        
        NSDictionary *imageInfo = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
        
        NSMutableDictionary *metaDataDic = [imageInfo mutableCopy];
        
        for (NSString * key in map) {
            [metaDataDic setObject:map[key] forKey:key];
        }
        
        CFStringRef UTI = CGImageSourceGetType(source);
        newImageData = [NSMutableData data];
        CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)newImageData, UTI, 1,NULL);
        
        CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef)metaDataDic);
        CGImageDestinationFinalize(destination);
        
        
        
    } @catch (NSException *exception) {
        newImageData = [NSMutableData dataWithData:data];
    } @finally {
        return newImageData;
    }
    
}



@end
