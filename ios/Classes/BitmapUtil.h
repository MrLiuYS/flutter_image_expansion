//
//  BitmapUtil.h
//  flutter_image_expansion
//
//  Created by 刘永生 on 2019/7/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BitmapUtil : NSObject

+ (NSString *)getImageLongitude:(NSString *)imagePath;
+ (NSString *)getImageLatitude:(NSString *)imagePath;
+ (NSString *)getImagePhotoTime:(NSString *)imagePath;

+ (NSDictionary *)getImageAllInfo:(NSString *)imagePath;

+ (BOOL)saveImageInfo:(NSString *)imagePath map:(NSDictionary *)map;

@end

NS_ASSUME_NONNULL_END
