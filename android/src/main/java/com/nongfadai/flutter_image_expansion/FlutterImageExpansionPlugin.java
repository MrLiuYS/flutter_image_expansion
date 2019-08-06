package com.nongfadai.flutter_image_expansion;

import android.media.ExifInterface;
import android.util.Log;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterImageExpansionPlugin */
public class FlutterImageExpansionPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_image_expansion");
    channel.setMethodCallHandler(new FlutterImageExpansionPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {

    String imagePath = call.argument("imagePath").toString();

    if (StringUtils.isEmpty(imagePath)){
      result.success(null);
    }
    //获取经度
    if (call.method.equals("getImageLongitude")){
      result.success(BitmapUtil.getImageLongitude(imagePath));
    }
    if (call.method.equals("getImageLatitude")){
      result.success(BitmapUtil.getImageLatitude(imagePath));

    }
    if (call.method.equals("getImagePhotoTime")){
      result.success(BitmapUtil.getImagePhotoTime(imagePath));

    }
    if (call.method.equals("getImageAllInfo")){
      result.success(BitmapUtil.getImageAllInfo(imagePath));
    }
    if (call.method.equals("saveImageInfo")){

      if (call.hasArgument("map")){
        Map<String, String> map = call.argument("map");

        Log.d("mrliuys 保存图片信息: ",map.toString());
        result.success(BitmapUtil.saveImageInfo(imagePath,map));
      }else {
        result.success(false);
      }
    }

    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else {
      result.notImplemented();
    }
  }




}
