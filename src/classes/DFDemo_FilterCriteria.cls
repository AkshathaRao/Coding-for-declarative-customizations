public with sharing class DFDemo_FilterCriteria {
    private DFDemo_Filter_Criteria__c configObj = null;
    private static DFDemo_FilterCriteria config = null;
    @TestVisible private static final Double CURR_BAND_MIN = 10001;
    @TestVisible private static final Double CURR_BAND_MAX = 200000;
    
    public static DFDemo_FilterCriteria get() {
        return setupConfigObj(null);   
    }
    
    public static DFDemo_FilterCriteria get(String dataSetName) {
		return setupConfigObj(dataSetName);   
    }
    
    private static DFDemo_FilterCriteria setupConfigObj(String dataSetName) {
        if(config == null) config = new DFDemo_FilterCriteria(dataSetName);
        return config;
    }
    
    public static void clear() {
        config = null;
    }   

    public DFDemo_FilterCriteria(String dataSetName) {
        try {
	        configObj = String.isBlank(dataSetName) ? DFDemo_Filter_Criteria__c.getInstance() : DFDemo_Filter_Criteria__c.getInstance(dataSetName);
        } catch(System.Exception e) { 
        	//Send out an email as well if this happens in real life. Look at DFDemo_Bands for another option
            DFDemo_GackUtils.sendGack(DFDemo_GackUtils.getDefaultExceptionEmailList(), e.getStackTraceString(), e.getMessage());
        }
    }
    
    public Double getCurrentBandMin() {
        if(configObj == null || String.isBlank(String.valueOf(configObj.Current_Band_Min__c))) return CURR_BAND_MIN;
        return configObj.Current_Band_Min__c;
    }
    
    public Double getCurrentBandMax() {
        if(configObj == null || String.isBlank(String.valueOf(configObj.Current_Band_Max__c))) return CURR_BAND_MAX;
        return configObj.Current_Band_Max__c;
    }
}