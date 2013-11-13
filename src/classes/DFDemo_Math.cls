public with sharing class DFDemo_Math{
    public static Boolean inRangeEqualTo(Double val, Double min, Double max) {
        return val >= min && val <= max;
    }
    
    public static Boolean inRange(Double val, Double min, Double max) {
        return val > min && val < max;
    }
    
    public static Boolean inRangeEqualTo(Decimal val, Decimal min, Decimal max) {
        return inRangeEqualTo((Double) val, (Double) min, (Double) max);
    }
    
    public static Boolean inRange(Decimal val, Decimal min, Decimal max) {
        return inRange((Double) val, (Double) min, (Double) max);
    }
}