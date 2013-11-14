@isTest
public class DFDemo_FilterCriteriaTest{

   	@isTest
	private static void testDefaultValues() {
        String TEST_NAME = 'MosIsley';
        System.assertEquals(DFDemo_FilterCriteria.CURR_BAND_MAX, DFDemo_FilterCriteria.get().getCurrentBandMax());
        System.assertEquals(DFDemo_FilterCriteria.CURR_BAND_MIN, DFDemo_FilterCriteria.get().getCurrentBandMin());
        
        DFDemo_FilterCriteria.clear();
        
		Test.startTest();
            DFDemo_Filter_Criteria__c filter = new DFDemo_Filter_Criteria__c();
            filter.Name = TEST_NAME;
            filter.SetupOwnerId = UserInfo.getOrganizationId();
            filter.Current_Band_Max__c = DFDemo_FilterCriteria.CURR_BAND_MAX;
            filter.Current_Band_Min__c = DFDemo_FilterCriteria.CURR_BAND_MIN;
            insert filter;
        Test.stopTest();
        
        System.assertEquals(DFDemo_FilterCriteria.CURR_BAND_MAX, DFDemo_FilterCriteria.get(TEST_NAME).getCurrentBandMax());
        System.assertEquals(DFDemo_FilterCriteria.CURR_BAND_MIN, DFDemo_FilterCriteria.get(TEST_NAME).getCurrentBandMin());
    }
}