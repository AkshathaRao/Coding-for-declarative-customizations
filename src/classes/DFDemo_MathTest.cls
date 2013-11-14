@isTest
public class DFDemo_MathTest{
	@isTest
   	private static void inRange() {
        System.assertEquals(true, DFdemo_Math.inRange(1.0, 0.0, 10.0));
        System.assertEquals(false, DFdemo_Math.inRange(0.0, 1.0, 10.0));
        System.assertEquals(false, DFdemo_Math.inRange(11.0, 1.0, 10.0));
    }
    
    @isTest
    private static void inRangeEqualTo() {
        System.assertEquals(true, DFdemo_Math.inRangeEqualTo(1.0, 1.0, 10.0));
        System.assertEquals(true, DFdemo_Math.inRangeEqualTo(10.0, 1.0, 10.0));
        System.assertEquals(true, DFdemo_Math.inRangeEqualTo(5.0, 1.0, 10.0));
        System.assertEquals(false, DFdemo_Math.inRangeEqualTo(0.0, 1.0, 10.0));
    }
}