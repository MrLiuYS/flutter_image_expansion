//
//  BitmapUtil.m
//  flutter_image_expansion
//
//  Created by 刘永生 on 2019/7/24.
//

#import "BitmapUtil.h"

@implementation BitmapUtil


+ (NSString *)getImageLongitude:(NSString *)imagePath{
    
    NSString * longitude = @"";
    
    NSDictionary * metaDataDic = [BitmapUtil getImageAllInfo:imagePath];
    
    NSMutableDictionary *GPSDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyGPSDictionary]mutableCopy];
    
    if (GPSDic[(NSString *)kCGImagePropertyGPSLongitude]) {
        
         longitude = [NSString stringWithFormat:@"%@",GPSDic[(NSString *)kCGImagePropertyGPSLongitude]];
        
//        longitude = GPSDic[(NSString *)kCGImagePropertyGPSLongitude];
    }
    

    return longitude;
}

+ (NSString *)getImageLatitude:(NSString *)imagePath{
    
    NSString * latitude = @"";
    
    NSDictionary * metaDataDic = [BitmapUtil getImageAllInfo:imagePath];
    
    NSMutableDictionary *GPSDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyGPSDictionary]mutableCopy];
    
    if (GPSDic[(NSString *)kCGImagePropertyGPSLatitude]) {
        latitude = [NSString stringWithFormat:@"%@",GPSDic[(NSString *)kCGImagePropertyGPSLatitude]];
    }
    
    return latitude;
}

+ (NSString *)getImagePhotoTime:(NSString *)imagePath{
    
    NSString * photoTime = @"";
    
    NSDictionary * metaDataDic = [BitmapUtil getImageAllInfo:imagePath];
    
    NSMutableDictionary *exifDic =[[metaDataDic objectForKey:(NSString*)kCGImagePropertyExifDictionary]mutableCopy];
    
    if (exifDic[(NSString *)kCGImagePropertyGPSLatitude]) {
        
        photoTime = [NSString stringWithFormat:@"%@",exifDic[(NSString *)kCGImagePropertyGPSLatitude]];
        
//        photoTime = exifDic[(NSString *)kCGImagePropertyTIFFDateTime];
    }
    
    return photoTime;
}

//获取图片所有的信息
+ (NSDictionary *)getImageAllInfo:(NSString *)imagePath{
    
    NSData *data = [NSData dataWithContentsOfFile:imagePath];

    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    NSDictionary *imageInfo = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    
    NSMutableDictionary *metaDataDic = [imageInfo mutableCopy];
    
    NSLog(@"图片信息：%@",metaDataDic);
    
    return metaDataDic;
}

+ (BOOL)saveImageInfo:(NSString *)imagePath map:(NSDictionary *)map{
    
    BOOL isSave = NO;
    
    @try {
        
        NSData *data = [NSData dataWithContentsOfFile:imagePath];
        
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
        
        NSDictionary *imageInfo = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
        
        NSMutableDictionary *metaDataDic = [imageInfo mutableCopy];
        
        for (NSString * key in map) {
            [metaDataDic setObject:map[key] forKey:key];
        }
        
        CFStringRef UTI = CGImageSourceGetType(source);
        NSMutableData *newImageData = [NSMutableData data];
        CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)newImageData, UTI, 1,NULL);
        
        CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef)metaDataDic);
        CGImageDestinationFinalize(destination);
        
        isSave = YES;
        
    } @catch (NSException *exception) {
        isSave = NO;
    } @finally {
        return isSave;
    }
    
}

@end
