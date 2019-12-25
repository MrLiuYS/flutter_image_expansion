package com.nongfadai.flutter_image_expansion;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.util.Log;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterImageExpansionPlugin
 */
public class FlutterImageExpansionPlugin implements MethodCallHandler {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_image_expansion");
        channel.setMethodCallHandler(new FlutterImageExpansionPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {

        if (!call.hasArgument("imagePath") && !call.hasArgument("imageData")) {

            result.notImplemented();
            return;

        }

        byte[] imageDataBytes = call.argument("imageData");


        if (imageDataBytes == null || imageDataBytes.length == 0) {

            String imagePath = call.argument("imagePath").toString();

            imageDataBytes = readFile(imagePath);
        }

        Map<String, String> imageExif = null;

//        if (call.hasArgument("keepExif")) {
//            boolean keepExif = call.argument("keepExif");
//
//            if (keepExif) {
                imageExif = BitmapUtil.getImageAllInfoFromData(imageDataBytes);

                Log.d("mrliuys 获取exif1: ", imageExif.toString());
//            }
//
//        }


        Bitmap image = getPicFromBytes(imageDataBytes, null);


        // 图片压缩
        if (call.method.equals("imageCompress")) {

            if (call.hasArgument("maxImageLength")) {
                // 图片缩放
                double maxImageLength = call.argument("maxImageLength");
                if (maxImageLength < image.getWidth() || maxImageLength < image.getHeight()) {
                    image = imageZoomImage(image, (float) maxImageLength);
                }
            }

            double maxDataLength = call.argument("maxDataLength");

            byte[] resultBytes = compressImage(image, maxDataLength);


//            if (imageExif != null) {
//
//// TODO: 2019-12-25 exif写入图片中
//                resultBytes = BitmapUtil.saveImageInfoFromData(resultBytes, imageExif);
//            }

            image = getPicFromBytes(resultBytes, null);

            Map<Object, Object> res = new HashMap();
            res.put("imageData", resultBytes);
            res.put("dataLength", resultBytes.length);
            res.put("imageWidth", image.getWidth());
            res.put("imageHeight", image.getHeight());

            result.success(res);


        }
        else if (call.method.equals("imageQuality")) {

            double quality = call.argument("quality");

            byte[] resultBytes = BitmapUtil.ImageJPEGRepresentation(image, quality);

//            if (imageExif != null) {
//
//// TODO: 2019-12-25 exif写入图片中
//
//                resultBytes = BitmapUtil.saveImageInfoFromData(resultBytes, imageExif);
//
//            }

            Map<Object, Object> res = new HashMap();
            res.put("imageData", resultBytes);
            res.put("dataLength", resultBytes.length);
            res.put("imageWidth", image.getWidth());
            res.put("imageHeight", image.getHeight());

            result.success(res);

        } else if (call.method.equals("imageZoom")) {

            double maxImageLength = 1920.0;

            if (call.hasArgument("maxImageLength")) {
                maxImageLength = call.argument("maxImageLength");
            }
            double quality = 1.0;
            Bitmap resultBitmap = imageZoomImage(image, (float) maxImageLength);

            byte[] resultBytes = BitmapUtil.ImageJPEGRepresentation(resultBitmap, quality);

            Map<Object, Object> res = new HashMap();
            res.put("imageData", resultBytes);
            res.put("dataLength", resultBytes.length);
            res.put("imageWidth", resultBitmap.getWidth());
            res.put("imageHeight", resultBitmap.getHeight());

            result.success(res);

        } else if (call.method.equals("getImageLongitude")) {
            //获取经度
            result.success(BitmapUtil.getImageLongitudeFromData(imageDataBytes));
        } else if (call.method.equals("getImageLatitude")) {
            result.success(BitmapUtil.getImageLatitudeFromData(imageDataBytes));
        } else if (call.method.equals("getImagePhotoTime")) {
            result.success(BitmapUtil.getImagePhotoTimeFromData(imageDataBytes));

        } else if (call.method.equals("getImageAllInfo")) {
            result.success(BitmapUtil.getImageAllInfoFromData(imageDataBytes));
        } else if (call.method.equals("saveImageInfo")) {

            if (call.hasArgument("map")) {
                Map<String, String> map = call.argument("map");

                Log.d("mrliuys 保存图片信息: ", map.toString());
//                result.success(BitmapUtil.saveImageInfo(imagePath, map));
            } else {
                result.success(false);
            }
        } else {
            result.notImplemented();
        }
    }

    private Bitmap imageZoomImage(Bitmap image, float maxImageLength) {

        float width = image.getWidth();
        float height = image.getHeight();
        float scale = 1;
        if (width > height && width > maxImageLength) {
            scale = maxImageLength / width;
        } else if (width < height && height > maxImageLength) {
            scale = maxImageLength / height;
        } else {
            return image;
        }
        Matrix matrix = new Matrix();
        matrix.postScale(scale, scale);

        Bitmap newBmp = Bitmap.createBitmap(image, 0, 0, (int) width, (int) height, matrix, true);
        return newBmp;

    }


    private byte[] compressImage(Bitmap image, double maxDataLength) {

        double compression = 1;

        byte[] data = BitmapUtil.ImageJPEGRepresentation(image, compression);

        if (data.length < maxDataLength) {
            return data;
        }

        double pMax = 1;
        double min = 0;
        for (int i = 0; i < 6; ++i) {
            compression = (pMax + min) / 2;
            data = BitmapUtil.ImageJPEGRepresentation(image, compression);

            if (data.length < maxDataLength * 0.9) {
                min = compression;
            } else if (data.length > maxDataLength) {
                pMax = compression;
            } else {
                break;
            }
        }
        if (data.length < maxDataLength) {
            return data;
        }
        Bitmap resultBitmap = getPicFromBytes(data, null);

        int lastDataLength = 0;

        while (data.length > maxDataLength && data.length != lastDataLength) {

            lastDataLength = data.length;
            float ratio = (float) maxDataLength / data.length;

            float maxLength = Math.max(resultBitmap.getHeight(), resultBitmap.getWidth());

            resultBitmap = imageZoomImage(resultBitmap, (float) (maxLength * Math.sqrt(ratio)));

            data = BitmapUtil.ImageJPEGRepresentation(resultBitmap, compression);
        }


        return data;
    }


    /// 根据路径多去byte[]
    private byte[] readFile(String imagePath) {
        File file = new File(imagePath);
        if (file.isFile()) {
            InputStream in = null;
            ByteArrayOutputStream os = new ByteArrayOutputStream();
            try {
                in = new FileInputStream(file);

                byte[] b = new byte[1024];
                int len;
                while ((len = in.read(b, 0, 1024)) != -1) {
                    os.write(b, 0, len);
                }
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    in.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            return os.toByteArray();
        } else {
            System.out.println("文件不存在！");
        }
        return null;
    }


    public static Bitmap getPicFromBytes(byte[] bytes, BitmapFactory.Options opts) {
        if (bytes != null) {
            if (opts != null) {

                return BitmapFactory.decodeByteArray(bytes, 0, bytes.length, opts);
            } else {

                return BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
            }
        }
        return null;
    }


}
