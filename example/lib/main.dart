import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

// import 'package:flutter/services.dart';
import 'package:flutter_image_expansion/flutter_image_expansion.dart';
import 'package:flutter_image_expansion/image_expansion_bean.dart';

import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

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
  @override
  void initState() {
    super.initState();
    this._sliderValue = 1.0;
    _imageMaxLength = 0;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    ImageExpansionBean bean =
        await FlutterImageExpansion.imageQuality(image.path, 1);

    setState(() {
      _image = image;
      _originalImageBean = bean;
      _imageBean = bean;

      _imageMaxLength =
          _originalImageBean.imageHeight > _originalImageBean.imageWidth
              ? _originalImageBean.imageHeight
              : _originalImageBean.imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          leading: FlatButton(
            child: Text("+"),
            onPressed: getImage,
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: Text(
                  "图片大小${_imageBean?.imageLength}\n图片质量:$_sliderValue\n图片高度:${_imageBean?.imageHeight}\n图片宽度:${_imageBean?.imageWidth}"),
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
                                    _image.path, end);

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
                              quality: _sliderValue,
                              maxLength: end,
                              imagePath: _image.path,
                            );

                            setState(() {
                              this._imageMaxLength = end;
                              this._imageBean = bean;
                            });
                          },
                        )
                      ],
                    ))
          ],
        ),
      ),
    );
  }
}
