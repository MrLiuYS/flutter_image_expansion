package com.nongfadai.flutter_image_expansion;

import android.media.ExifInterface;
import android.util.Log;

import java.lang.reflect.Field;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;


public class BitmapUtil {

    /**
     * 获取图片的经度
     * @param path 图片绝对路径
     * @return 图片的经度
     */
    public static String  getImageLongitude(String path) {
        String longitude = "";
        try {
            // 从指定路径下读取图片，并获取其EXIF信息
            ExifInterface exifInterface = new ExifInterface(path);
            // 获取图片的旋转信息
            String gpsLongitude = exifInterface.getAttribute(ExifInterface.TAG_GPS_LONGITUDE);
            String longitudeRef = exifInterface.getAttribute(ExifInterface.TAG_GPS_LONGITUDE_REF);
            longitude = StringUtils.convertRationalLatLonToFloat(gpsLongitude,longitudeRef)+"";
        } catch (Exception e) {
            e.printStackTrace();
        }

        Log.d("mrliuys 图片经度: ",longitude);
        return longitude;
    }


    /**
     * 获取图片的纬度
     * @param path 图片绝对路径
     * @return 图片的纬度
     */
    public static String  getImageLatitude(String path) {
        String latitude = "";
        try {
            // 从指定路径下读取图片，并获取其EXIF信息
            ExifInterface exifInterface = new ExifInterface(path);
            // 获取图片的旋转信息
            String gpsLatitude = exifInterface.getAttribute(ExifInterface.TAG_GPS_LATITUDE);
            String latitudeRef = exifInterface.getAttribute(ExifInterface.TAG_GPS_LATITUDE_REF);
            latitude = StringUtils.convertRationalLatLonToFloat(gpsLatitude,latitudeRef)+"";
        } catch (Exception e) {
            e.printStackTrace();
        }

        Log.d("mrliuys 图片纬度: ",latitude);
        return latitude;
    }
    /**
     * 获取图片拍照时间
     * @param path 图片绝对路径
     * @return 图片的拍照时间
     */
    public static String  getImagePhotoTime(String path) {
        String photoTime = "";
        try {
            // 从指定路径下读取图片，并获取其EXIF信息
            ExifInterface exifInterface = new ExifInterface(path);
            // 获取图片的旋转信息
            String originTime = exifInterface.getAttribute(ExifInterface.TAG_DATETIME_ORIGINAL);
            photoTime =  DateUtils.getStringToDate(originTime,DateUtils.TYPE_03)+"";
        } catch (Exception e) {
            photoTime = DateUtils.formatDate(new Date().getTime(),DateUtils.TYPE_03);
            e.printStackTrace();
        }

        Log.d("mrliuys 图片拍照时间: ",photoTime);
        return photoTime;
    }

    public static Map<String, String>  getImageAllInfo(String path) {
        Map<String, String> res = new HashMap<>();
        try {
            // 从指定路径下读取图片，并获取其EXIF信息
            ExifInterface exifInterface = new ExifInterface(path);
            Class<ExifInterface> cls = ExifInterface.class;
            Field[] fields = cls.getFields();
            for (int i = 0; i < fields.length; i++) {
                String fieldName = fields[i].getName();
                if (!StringUtils.isEmpty(fieldName) && fieldName.startsWith("TAG")) {
                    String fieldValue = fields[i].get(cls).toString();
                    String attribute = exifInterface.getAttribute(fieldValue);
                    if (attribute != null) {
                        res.put(fieldValue,attribute);
                    }
                }
            }
            //设置旋转角度为0
            res.put(ExifInterface.TAG_ORIENTATION,ExifInterface.ORIENTATION_NORMAL+"");
        } catch (Exception e) {
            e.printStackTrace();
        }


        Log.d("mrliuys 获取图片信息: ",res.toString());

        return res;
    }

    public static boolean  saveImageInfo(String path,  Map<String, String> map) {
        Boolean isSave = false;
        try {
            ExifInterface newExif=new ExifInterface(path);
            for (String key : map.keySet()){
                newExif.setAttribute(key, map.get(key));
            }
            //设置旋转角度为0
            newExif.setAttribute(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL+"");
            newExif.saveAttributes();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return isSave;
    }

////    /**
////     * 把旧的图片信息写入到压缩后的图片中去
////     * @param oldFilePath
////     * @param newFilePath
////     * @throws Exception
////     */
//    public static void saveExif(String oldFilePath, String newFilePath) throws Exception {
//        ExifInterface oldExif=new ExifInterface(oldFilePath);
//        ExifInterface newExif=new ExifInterface(newFilePath);
//        Class<ExifInterface> cls = ExifInterface.class;
//        Field[] fields = cls.getFields();
//        for (int i = 0; i < fields.length; i++) {
//            String fieldName = fields[i].getName();
//            if (!TextUtils.isEmpty(fieldName) && fieldName.startsWith("TAG")) {
//                String fieldValue = fields[i].get(cls).toString();
//                String attribute = oldExif.getAttribute(fieldValue);
//                if (attribute != null) {
////                    LogUtils.i("fieldValue--"+fieldValue+"attribute----"+attribute);
//                    newExif.setAttribute(fieldValue, attribute);
//                }
//            }
//        }
//        //设置旋转角度为0
//        newExif.setAttribute(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL+"");
//        newExif.saveAttributes();
//    }


}
