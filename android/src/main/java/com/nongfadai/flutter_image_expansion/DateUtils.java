package com.nongfadai.flutter_image_expansion;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtils {


    public static final String TYPE_01 = "yyyy-MM-dd HH:mm:ss";
    public static final String TYPE_02 = "yyyy-MM-dd";
    public static final String TYPE_03 = "yyyy:MM:dd HH:mm:ss";
    public static final String TYPE_04 = "yyyy年MM月dd日";
    public static final String TYPE_05 = "yyyy-MM-dd HH:mm";
    public static final String TYPE_06 = "yyyy.MM.dd";
    public static final String TYPE_07 = "yyyy/MM/dd";
    public static final String TYPE_08 = "MM月dd日";
    public static final String TYPE_09 = "yyyy.MM.dd HH:mm";
    public static final String TYPE_10 = "yyyy/MM/dd HH:mm:ss";
    public static final String TYPE_YEAR = "yy年";
    public static final String TYPE_HOURS = "HH:mm";
    public static final String TYPE_YEAR_MOUTH = "yyyy年MM月";
    public static final String TYPE_YEAR_MOUTH_NORMAL = "yyyy-MM";
    public static final String TYPE_MOUTH_DAY = "MM-dd";
    public static String END_TIME = " 23:59:59";
    public static String START_TIME = " 00:00:00";

    /**
     * 根据指定的格式格式话 毫秒数
     *
     * @return 格式化后的String
     */
    public static String formatDate(long time, String pattern) {
        if (time == 0) {
            return "- -";
        }
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(time);
        return new SimpleDateFormat(pattern).format(cal.getTime());
    }

    /**
     * 将字符串转为时间戳
     * @param dateString 时间字符
     * @param pattern 日期格式
     * @return
     */
    public static long getStringToDate(String dateString, String pattern) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(pattern);
        Date date = new Date();
        try{
            date = dateFormat.parse(dateString);
        } catch(ParseException e) {
            e.printStackTrace();
        }
        return date.getTime();
    }

}
