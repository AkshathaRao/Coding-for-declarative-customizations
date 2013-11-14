@isTest
public with sharing class DFDemo_BandsTest {
    private static final Decimal TEST_VAL = 20.0;
    
    @isTest
    private static void testInit() {
    	Map<String, DFDemo_Bands__c> bandsMap = DFDemo_Bands__c.getAll();
        delete bandsMap.values();
        System.assertEquals(DFDemo_Bands.FIRST_BAND_LOGINS, DFDemo_Bands.get().getLogins(DFDemo_Bands.FIRST_BAND_MIN)); 
    }
    
    @isTest
    private static void testDefaultValues() {
        DFDemo_Bands.clear();
        
        System.assertEquals(DFDemo_Bands.FIRST_BAND_LOGINS, DFDemo_Bands.get().getLogins(DFDemo_Bands.FIRST_BAND_MIN));
        System.assertEquals(DFDemo_Bands.SECOND_BAND_LOGINS, DFDemo_Bands.get().getLogins(DFDemo_Bands.SECOND_BAND_MIN));
        
        System.assertEquals(DFDemo_Bands.FIRST_BAND_LICENSES, DFDemo_Bands.get().getLicenses(DFDemo_Bands.FIRST_BAND_MIN));
        System.assertEquals(DFDemo_Bands.SECOND_BAND_LICENSES, DFDemo_Bands.get().getLicenses(DFDemo_Bands.SECOND_BAND_MIN));
    }
    
    //Order matters to make sure we have 100% code coverage
    @isTest
    private static void setLowerMinTestOutsideOfRange() {
        DFDemo_Bands.clear();
        Decimal min = DFDemo_Bands.get().getBandValue('min') == null ? -1000 : DFDemo_Bands.get().getBandValue('min') - 1000;
        DFDemo_Bands.clear();
        
        Decimal val = min == null ? -100 : min + 100;
        Decimal max = min == null ? -500 : min + 500;
        Decimal licenses = 10.0;
        Decimal logins = 20.0;
        
        DFDemo_Bands__c band = new DFDemo_Bands__c();
        band.SetupOwnerId = UserInfo.getOrganizationId();
        band.Name = String.valueOf(min) + '-' + String.valueOf(max);
        band.Licenses__c = licenses;
        band.Logins__c = logins;
        
        upsert band;
        
        System.assertEquals(logins, DFDemo_Bands.get().getLogins(val));
        System.assertEquals(licenses, DFDemo_Bands.get().getLicenses(val));
        
        //try with out of range value to get licenses
        System.assertEquals(null, DFDemo_Bands.get().getLogins(min - 1000));
    }
    
    @isTest
    private static void getLicensesFirst() {
        Decimal min = DFDemo_Bands.get().getBandValue('max') == null ? 1 : DFDemo_Bands.get().getBandValue('max') + 1;
        DFDemo_Bands.clear();
        
        Decimal val = min == null ? 100 : min + 100;
        Decimal max = min == null ? 1000 : min + 1000;
        Decimal licenses = 10.0;
        Decimal logins = 20.0;
        
        DFDemo_Bands__c band = new DFDemo_Bands__c();
        band.SetupOwnerId = UserInfo.getOrganizationId();
        band.Name = String.valueOf(min) + '-' + String.valueOf(max);
        band.Licenses__c = licenses;
        band.Logins__c = logins;
        
        upsert band;
        
        System.assertEquals(logins, DFDemo_Bands.get().getLogins(val));
        System.assertEquals(licenses, DFDemo_Bands.get().getLicenses(val));
    }
    
    @isTest
    private static void getLoginsFirst() {
        Decimal min = DFDemo_Bands.get().getBandValue('max') == null ? 1 : DFDemo_Bands.get().getBandValue('max') + 1;
        DFDemo_Bands.clear();
        
        Decimal val = min == null ? 100 : min + 100;
        Decimal max = min == null ? 1000 : min + 1000;
        Decimal licenses = 10.0;
        Decimal logins = 20.0;
        
        DFDemo_Bands__c band = new DFDemo_Bands__c();
        band.SetupOwnerId = UserInfo.getOrganizationId();
        band.Name = String.valueOf(min) + '-' + String.valueOf(max);
        band.Licenses__c = licenses;
        band.Logins__c = logins;
        
        upsert band;
        
        System.assertEquals(licenses, DFDemo_Bands.get().getLicenses(val));
        System.assertEquals(logins, DFDemo_Bands.get().getLogins(val));
    }
}