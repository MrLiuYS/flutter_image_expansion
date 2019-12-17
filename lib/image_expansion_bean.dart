
import 'dart:io';
import 'dart:typed_data';

class ImageExpansionBean {

  ImageExpansionBean({
    this.imageData,
    this.imagePath,
    this.imageWidth,
    this.imageHeight,
    this.imageLength,
  });
  
  Uint8List imageData;
  String imagePath;
  num imageWidth;
  num imageHeight;
  num imageLength;

  ImageExpansionBean.fromMap(Map m){
    imageData = m["imageData"];
    imagePath = m["imagePath"];
    imageWidth = m["imageWidth"];
    imageHeight = m["imageHeight"];
    imageLength = m["imageLength"];
  }



}