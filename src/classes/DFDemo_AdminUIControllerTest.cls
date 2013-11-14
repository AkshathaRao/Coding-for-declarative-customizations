@isTest
public with sharing class DFDemo_AdminUIControllerTest {

    private static List<DFDemo_AdminUIController.Wrapper> getGoodBands() {
        //create a few bands as Wrapper objects that don't break any rules
        List<DFDemo_AdminUIController.Wrapper> bands = new List<DFDemo_AdminUIController.Wrapper>();
        bands.add(new DFDemo_AdminUIController.Wrapper(1001,5000,22.0,33.0));
        bands.add(new DFDemo_AdminUIController.Wrapper(5001,10000,44.0,55.0));
        bands.add(new DFDemo_AdminUIController.Wrapper(10001,50000,66.0,77.0));
        return bands;

    }

    @isTest
    static void happyPathTest() {

    	//level set
    	List<DFDemo_Bands__c> dbBands = [select name, Licenses__c, Logins__c from DFDemo_Bands__c];
    	System.assertEquals(0, dbBands.size());

        List<DFDemo_AdminUIController.Wrapper> bands = getGoodBands();
        //save 'em
        String jsonIn = System.JSON.serialize(bands);
        String res = DFDemo_AdminUIController.saveBands(jsonIn, true);
        System.assertEquals('OK: Custom Settings Saved.', res);

        //check the db
        dbBands= [select name, Licenses__c, Logins__c from DFDemo_Bands__c];
        System.assertEquals(3, dbBands.size());
        System.assertEquals('5001-10000', dbBands[1].name);
        System.assertEquals(44.0, dbBands[1].Licenses__c);
        System.assertEquals(55.0, dbBands[1].Logins__c);

        //check filter criteria
        DFDemo_Filter_Criteria__c fc = DFDemo_Filter_Criteria__c.getOrgDefaults();
        System.assertEquals(1001.0,fc.Current_Band_Min__c);
        System.assertEquals(50000.0,fc.Current_Band_Max__c);

        //read 'em back out
        DFDemo_AdminUIController ctrl = new DFDemo_AdminUIController();
        String jsonOut = ctrl.getBandsJSON();
        System.assertEquals(jsonIn, jsonOut);

    }

    @isTest
    static void testNegativeMinimum() {
    	List<DFDemo_AdminUIController.Wrapper> bands = getGoodBands();
    	bands[0].bandmin = -1000;
        String jsonIn = System.JSON.serialize(bands);
        String res = DFDemo_AdminUIController.saveBands(jsonIn, false);
    	System.assertEquals('ERROR: Band Minimum must be greater than 0.',res);
    }

    @isTest
    static void testMaxBelowMin() {
        List<DFDemo_AdminUIController.Wrapper> bands = getGoodBands();
        bands[0].bandmax = bands[0].bandmin - 1;
        String jsonIn = System.JSON.serialize(bands);
        String res = DFDemo_AdminUIController.saveBands(jsonIn, false);
        System.assertEquals('ERROR: Band Maximum must be greater than its minimum.',res);
    }

    @isTest
    static void testMinBelowPriorMin() {
        List<DFDemo_AdminUIController.Wrapper> bands = getGoodBands();
        bands[1].bandmin = bands[0].bandmin - 1;
        String jsonIn = System.JSON.serialize(bands);
        String res = DFDemo_AdminUIController.saveBands(jsonIn, false);
        System.assertEquals('ERROR: Band Minimum must be 1 greater than prior band minimum.',res);
    }

    @isTest
    static void testBadLICENSESPctLow() {
        List<DFDemo_AdminUIController.Wrapper> bands = getGoodBands();
        bands[1].licenses = -1.0;
        String jsonIn = System.JSON.serialize(bands);
        String res = DFDemo_AdminUIController.saveBands(jsonIn, false);
        System.assertEquals('ERROR: Minimum licenses must be between 0 and 100.',res);
    }

    @isTest
    static void testBadLICENSESPctHigh() {
        List<DFDemo_AdminUIController.Wrapper> bands = getGoodBands();
        bands[1].licenses = 101.0;
        String jsonIn = System.JSON.serialize(bands);
        String res = DFDemo_AdminUIController.saveBands(jsonIn, false);
        System.assertEquals('ERROR: Minimum licenses must be between 0 and 100.',res);
    }

    @isTest
    static void testBadUtilPctLow() {
        List<DFDemo_AdminUIController.Wrapper> bands = getGoodBands();
        bands[1].logins = -1.0;
        String jsonIn = System.JSON.serialize(bands);
        String res = DFDemo_AdminUIController.saveBands(jsonIn, false);
        System.assertEquals('ERROR: Minimum logins must be between 0 and 100.',res);
    }

    @isTest
    static void testBadUtilPctHigh() {
        List<DFDemo_AdminUIController.Wrapper> bands = getGoodBands();
        bands[1].logins = 101.0;
        String jsonIn = System.JSON.serialize(bands);
        String res = DFDemo_AdminUIController.saveBands(jsonIn, false);
        System.assertEquals('ERROR: Minimum logins must be between 0 and 100.',res);
    }

    @isTest
    static void testBoundsWarning() {
        List<DFDemo_AdminUIController.Wrapper> bands = getGoodBands();
        String jsonIn = System.JSON.serialize(bands);
        String res = DFDemo_AdminUIController.saveBands(jsonIn, true);
        List<DFDemo_Bands__c> dbBands = [select name, Licenses__c, Logins__c from DFDemo_Bands__c];
        System.assertEquals(3, dbBands.size());

        bands.remove(0); //this will change the overall minimum
        jsonIn = System.JSON.serialize(bands);
        res = DFDemo_AdminUIController.saveBands(jsonIn, false); //try without accepting warnings
        system.assertEquals('WARNING: The new minimum for the first band is greater than the old value.  Any cases that have already entered the process but no longer fall into one of the Bands will be given the Status \'Exception\'. ', res);
        res = DFDemo_AdminUIController.saveBands(jsonIn, true); //try again with warnings accepted
        System.assertEquals('OK: Custom Settings Saved.', res);

    }
}