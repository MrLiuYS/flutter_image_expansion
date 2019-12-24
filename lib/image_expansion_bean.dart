import 'dart:typed_data';

class ImageExpansionBean {
  /// 图片data
  Uint8List imageData;

  /// 图片原始路径
  String imagePath;

  /// 图片宽度
  num imageWidth;

  /// 图片高度
  num imageHeight;

  /// 图片体积
  num dataLength;

  ImageExpansionBean({
    this.imageData,
    this.imagePath,
    this.imageWidth,
    this.imageHeight,
    this.dataLength,
  });

  ImageExpansionBean.fromMap(Map m) {
    imageData = m["imageData"];
    imagePath = m["imagePath"];
    imageWidth = m["imageWidth"];
    imageHeight = m["imageHeight"];
    dataLength = m["dataLength"];
  }
}
