//
//  BitmapUtil.h
//  flutter_image_expansion
//
//  Created by 刘永生 on 2019/7/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BitmapUtil : NSObject

+ (NSString *)getImageLongitudeFromData:(NSData *)data;
+ (NSString *)getImageLatitudeFromData:(NSData *)data;
+ (NSString *)getImagePhotoTimeFromData:(NSData *)data;


/// 获取图片的信息
//+ (NSDictionary *)getImageAllInfoFromPath:(NSString *)imagePath;

/// 获取图片的信息
+ (NSDictionary *)getImageAllInfoFromData:(NSData *)data;

/// 保存图片信息到data
//+ (BOOL)saveImageInfoFromPath:(NSString *)imagePath map:(NSDictionary *)map;

/// 保存图片信息到data
+ (NSMutableData *)saveImageInfoFromData:(NSData *)data map:(NSDictionary *)map ;

@end

NS_ASSUME_NONNULL_END
