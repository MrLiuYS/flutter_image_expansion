import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

// import 'package:flutter/services.dart';
import 'package:flutter_image_expansion/flutter_image_expansion.dart';
import 'package:flutter_image_expansion/image_expansion_bean.dart';
// import 'package:flutter_smart_cropper/flutter_smart_cropper.dart';

import 'package:image_picker/image_picker.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _image;

  ImageExpansionBean _originalImageBean;
  double _sliderValue;
  double _imageMaxLength;

  ImageExpansionBean _imageBean;

  double _imageMaxDataLength;
  double _imageDataLength;
  @override
  void initState() {
    super.initState();
    this._sliderValue = 1.0;
    _imageMaxLength = 0;

    // _imageMaxDataLength = 1000;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    ImageExpansionBean bean = await FlutterImageExpansion.imageQuality(
        imagePath: image.path, quality: 1);



    setState(() {
      _image = image;
      _originalImageBean = bean;
      _imageBean = bean;

      _imageMaxDataLength = bean.dataLength.toDouble();
      _imageDataLength = bean.dataLength.toDouble();

      _imageMaxLength =
          _originalImageBean.imageHeight > _originalImageBean.imageWidth
              ? _originalImageBean.imageHeight.toDouble()
              : _originalImageBean.imageWidth.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
        leading: FlatButton(
          child: Text("+"),
          onPressed: getImage,
        ),
      ),
      body: Column(
        children: <Widget>[
          buildRow(),
          Container(
            child: Text(
                "图片大小${_imageBean?.dataLength}\n图片质量:$_sliderValue\n图片高度:${_imageBean?.imageHeight}\n图片宽度:${_imageBean?.imageWidth}"),
          ),
          Expanded(
            child: _imageBean == null
                ? (_image == null
                    ? Text('No image selected.')
                    : Image.file(_image))
                : Image.memory(_imageBean.imageData),
          ),
          _originalImageBean == null
              ? Container()
              : Container(
                  height: 200,
                  color: Colors.grey,
                  child: Column(
                    children: <Widget>[
                      Slider(
                        label: "质量$_sliderValue",
                        divisions: 10,
                        activeColor: Colors.blue,
                        value: this._sliderValue,
                        onChanged: (double change) {
                          setState(() {
                            this._sliderValue = change;
                          });
                        },
                        onChangeEnd: (double end) async {
                          print("onChangeEnd: $end");

                          ImageExpansionBean bean =
                              await FlutterImageExpansion.imageQuality(
                                  imagePath: _image.path, quality: end);

                          setState(() {
                            this._sliderValue = end;
                            this._imageBean = bean;
                          });
                        },
                      ),
                      Slider(
                        label: "最大边$_imageMaxLength",
                        // divisions: 10,
                        activeColor: Colors.blue,
                        value: _imageMaxLength,
                        onChanged: (double change) {
                          setState(() {
                            this._imageMaxLength = change;
                          });
                        },
                        min: 320,
                        max: 5000,
                        onChangeEnd: (double end) async {
                          print("onChangeEnd: $end");

                          ImageExpansionBean bean =
                              await FlutterImageExpansion.imageZoom(
                            imageData: _originalImageBean.imageData,
                            maxImageLength: end,
                            imagePath: _image.path,
                          );

                          setState(() {
                            this._imageMaxLength = end;
                            this._imageBean = bean;
                          });
                        },
                      ),
                      Slider(
                        label: "data最大:$_imageDataLength",
                        divisions: 20,
                        activeColor: Colors.blue,
                        value: _imageDataLength,
                        onChanged: (double change) {
                          setState(() {
                            this._imageDataLength = change;
                          });
                        },
                        min: 10000,
                        max: _imageMaxDataLength,
                        onChangeEnd: (double end) async {
                          print("onChangeEnd: $end");

                          ImageExpansionBean bean =
                              await FlutterImageExpansion.imageCompress(
                                  imageData: _originalImageBean.imageData,
                                  maxDataLength: end,
                                  keepExif: false);

                          setState(() {
                            this._imageDataLength = end;
                            this._imageBean = bean;
                          });
                        },
                      )
                    ],
                  ))
        ],
      ),
    );
  }

  Wrap buildRow() {
    return Wrap(
      spacing: 2,
      runSpacing: 2,
      children: <Widget>[
        RaisedButton(
          child: Text("经度"),
          onPressed: () async {
            String longitude = await FlutterImageExpansion.getImageLongitude(
                imageData: _imageBean.imageData);
            showMyMaterialDialog(context, "经度: $longitude");
          },
        ),
        RaisedButton(
          child: Text("纬度"),
          onPressed: () async {
            String latitude = await FlutterImageExpansion.getImageLatitude(
                imageData: _imageBean.imageData);
            showMyMaterialDialog(context, "纬度: $latitude");
          },
        ),
        RaisedButton(
          child: Text("时间"),
          onPressed: () async {
            String time = await FlutterImageExpansion.getImagePhotoTime(
                imageData: _imageBean.imageData);
            showMyMaterialDialog(context, "拍照时间: $time");
          },
        ),
        RaisedButton(
          child: Text("详情"),
          onPressed: () async {
            Map map = await FlutterImageExpansion.getImageAllInfo(
                imageData: _imageBean.imageData);
            showMyMaterialDialog(context, "详情: ${map.toString()}");
          },
        ),
      ],
    );
  }

  void showMyMaterialDialog(BuildContext context, String content) {
    var alert = AlertDialog(
      title: Text("标题"),
      content: Text(content),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
