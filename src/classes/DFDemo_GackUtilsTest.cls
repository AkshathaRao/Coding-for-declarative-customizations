@isTest
public with sharing class DFDemo_GackUtilsTest{
    private static final String BODY = 'body';
    private static final String SUBJECT = 'subject';
    
    @isTest
    private static void getDefaultExceptionEmailList() {
        System.assertEquals(false, DFDemo_GackUtils.getDefaultExceptionEmailList().isEmpty());
    }
    
    @isTest
    private static void sendGack() {
        try {
	        DFDemo_GackUtils.sendGack(DFDemo_GackUtils.getDefaultExceptionEmailList(), BODY, SUBJECT);
            System.assertEquals(true, true);
            
            DFDemo_GackUtils.sendGack(new List<String>{}, BODY, SUBJECT);
        } catch(System.Exception e) {
            System.assertEquals(false, true, 'Error processing gack: ' + e);
        }
    }
    
    @isTest
    private static void testGacks() {
        List<String> gackEmailIds = DFDemo_GackUtils.getDefaultExceptionEmailList();
        List<String[]> gacks = DFDemo_GackUtils.initGacks(gackEmailIds);
        
        System.assertEquals(false, gackEmailIds.isEmpty());
        
        DFDemo_GackUtils.gack(gacks, SUBJECT);
        DFDemo_GackUtils.gack(gacks, SUBJECT, BODY);
        DFDemo_GackUtils.processGacks(gacks);
    }
}