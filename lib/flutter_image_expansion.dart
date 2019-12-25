import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_image_expansion/image_expansion_bean.dart';

class FlutterImageExpansion {
  static const MethodChannel _channel =
      const MethodChannel('flutter_image_expansion');

  /// 图片压缩
  /// [imageData] 原始图片data.如果有,则不取imagePath的数据
  /// [imagePath] 原始图片路径.没有imageData,才会取imagePath路径下的数据
  /// [maxDataLength] 图片最大体积, 单位b
  /// [maxImageLength] 图片最大边,如果有,则先进行等比压缩,到指定大小的边,再进行体积的压缩
  /// [keepExif] 图片压缩处理是否保留exif数据,默认保留
  /// return  Future<ImageExpansionBean> 压缩后的图片数据
  static Future<ImageExpansionBean> imageCompress({
    Uint8List imageData,
    String imagePath,
    double maxDataLength,
    double maxImageLength,
    bool keepExif = false,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "maxDataLength": maxDataLength,
      "keepExif": keepExif
    };
    if (imagePath != null) {
      params["imagePath"] = imagePath;
    }
    if (imageData != null) {
      params["imageData"] = imageData;
    }
    if (maxImageLength != null) {
      params["maxImageLength"] = maxImageLength;
    }

    final res = await _channel.invokeMethod('imageCompress', params);
    return ImageExpansionBean.fromMap(res);
  }

  /// 图片质量设置
  /// [imageData] 原始图片data.如果有,则不取imagePath的数据
  /// [imagePath] 原始图片路径.没有imageData,才会取imagePath路径下的数据
  /// [quality] 图片质量 [0,1]
  /// [keepExif] 图片压缩处理是否保留exif数据,默认保留
  /// return Future<ImageExpansionBean> 质量处理后的图片数据
  static Future<ImageExpansionBean> imageQuality({
    Uint8List imageData,
    String imagePath,
    double quality,
    bool keepExif = false,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "quality": quality,
      "keepExif": keepExif
    };
    if (imagePath != null) {
      params["imagePath"] = imagePath;
    }
    if (imageData != null) {
      params["imageData"] = imageData;
    }
    final res = await _channel.invokeMethod('imageQuality', params);
    return ImageExpansionBean.fromMap(res);
  }

  /// 图片缩放到指定宽高
  /// [imageData] 原始图片data.如果有,则不取imagePath的数据
  /// [imagePath] 原始图片路径.没有imageData,才会取imagePath路径下的数据
  /// [maxImageLength] 图片最大边,如果有,则先进行等比压缩,到指定大小的边,再进行体积的压缩
  /// [keepExif] 图片压缩处理是否保留exif数据,默认保留
  /// /// return  Future<ImageExpansionBean> 处理后的图片数据
  static Future<ImageExpansionBean> imageZoom({
    Uint8List imageData,
    String imagePath,
    double maxImageLength,
    bool keepExif = false,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      "maxImageLength": maxImageLength,
      "keepExif": keepExif
    };
    if (imagePath != null) {
      params["imagePath"] = imagePath;
    }
    if (imageData != null) {
      params["imageData"] = imageData;
    }
    final res = await _channel.invokeMethod('imageZoom', params);
    return ImageExpansionBean.fromMap(res);
  }

  /// 获取图片经度，
  /// [imageData] 原始图片data.如果有,则不取imagePath的数据
  /// [imagePath] 原始图片路径.没有imageData,才会取imagePath路径下的数据
  /// 如果图片没有经度信息，返回的是“”空字符串
  static Future<String> getImageLongitude({
    Uint8List imageData,
    String imagePath,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{};
    if (imagePath != null) {
      params["imagePath"] = imagePath;
    }
    if (imageData != null) {
      params["imageData"] = imageData;
    }
    final String longitude =
        await _channel.invokeMethod('getImageLongitude', params);
    return longitude;
  }

  /// 获取图片纬度
  /// [imageData] 原始图片data.如果有,则不取imagePath的数据
  /// [imagePath] 原始图片路径.没有imageData,才会取imagePath路径下的数据
  /// imagePath：图片的绝对路径
  static Future<String> getImageLatitude({
    Uint8List imageData,
    String imagePath,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{};
    if (imagePath != null) {
      params["imagePath"] = imagePath;
    }
    if (imageData != null) {
      params["imageData"] = imageData;
    }
    final String latitude =
        await _channel.invokeMethod('getImageLatitude', params);
    return latitude;
  }

  /// 获取图片拍照时间
  /// [imageData] 原始图片data.如果有,则不取imagePath的数据
  /// [imagePath] 原始图片路径.没有imageData,才会取imagePath路径下的数据
  /// 如果没有返回的是“”空字符串
  static Future<String> getImagePhotoTime({
    Uint8List imageData,
    String imagePath,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{};
    if (imagePath != null) {
      params["imagePath"] = imagePath;
    }
    if (imageData != null) {
      params["imageData"] = imageData;
    }

    final String latitude =
        await _channel.invokeMethod('getImagePhotoTime', params);
    return latitude;
  }

  /// 获取图片所有的信息
  /// [imageData] 原始图片data.如果有,则不取imagePath的数据
  /// [imagePath] 原始图片路径.没有imageData,才会取imagePath路径下的数据
  /// 如果没有返回的是{}空表
  /// imagePath：图片的绝对路径
  static Future<Map> getImageAllInfo({
    Uint8List imageData,
    String imagePath,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{};
    if (imagePath != null) {
      params["imagePath"] = imagePath;
    }
    if (imageData != null) {
      params["imageData"] = imageData;
    }
    var fromRes = await _channel.invokeMethod('getImageAllInfo', params);
    return transferData(fromRes); 
  }

  /// 保存信息到图片
  /// [imageData] 原始图片data.如果有,则不取imagePath的数据
  /// [imagePath] 原始图片路径.没有imageData,才会取imagePath路径下的数据
  static Future<bool> saveImageInfo({
    Uint8List imageData,
    String imagePath,
    Map<String, dynamic> map,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{};
    if (imagePath != null) {
      params["imagePath"] = imagePath;
    }
    if (imageData != null) {
      params["imageData"] = imageData;
    }
    if (map != null) {
      params["map"] = map;
    }
    bool res = await _channel.invokeMethod('saveImageInfo', params);
    return res;
  }

  ///数据转化
  static Future<Map<String, dynamic>> transferData(
      Map<Object, Object> fromRes) async {
    if (fromRes != null) {
      final Map<String, Object> toMap = <String, Object>{};
      for (String key in fromRes.keys) {
        toMap[key] = fromRes[key];
      }
      return toMap;
    } else {
      return fromRes;
    }
  }
}
