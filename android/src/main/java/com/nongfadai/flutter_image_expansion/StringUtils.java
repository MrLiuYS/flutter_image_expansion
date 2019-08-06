package com.nongfadai.flutter_image_expansion;

public class StringUtils {


    /**
     * 是否 为空字符串 或 null
     */
    public static boolean isEmpty(String s) {
        return s == null || s.length() <= 0;
    }

    private static double parseDouble(String doubleValue, double defaultValue) {
        try {
            return Double.parseDouble(doubleValue);
        } catch (Throwable t) {
            return defaultValue;
        }
    }

    /**
     * @param rationalString 度分秒格式的经纬度字符串,形如: 114/1,23/1,538547/10000 或 30/1,28/1,432120/10000
     * @param ref 东西经 或 南北纬 的标记 S南纬 W西经
     * @return double格式的 经纬度
     */
    public static float convertRationalLatLonToFloat(String rationalString, String ref) {
        if (StringUtils.isEmpty(rationalString) || StringUtils.isEmpty(ref)) {
            return 0;
        }

        try {
            String[] parts = rationalString.split(",");

            String[] pair;
            pair = parts[0].split("/");
            double degrees = parseDouble(pair[0].trim(), 0)
                    / parseDouble(pair[1].trim(), 1);

            pair = parts[1].split("/");
            double minutes = parseDouble(pair[0].trim(), 0)
                    / parseDouble(pair[1].trim(), 1);

            pair = parts[2].split("/");
            double seconds = parseDouble(pair[0].trim(), 0)
                    / parseDouble(pair[1].trim(), 1);

            double result = degrees + (minutes / 60.0) + (seconds / 3600.0);
            if (("S".equals(ref) || "W".equals(ref))) {
                return (float) -result;
            }
            return (float) result;
        } catch (NumberFormatException e) {
            return 0;
        } catch (ArrayIndexOutOfBoundsException e) {
            return 0;
        } catch (Throwable e) {
            return 0;
        }
    }


}
