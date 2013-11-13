public with sharing class DFDemo_AdminUIController {
	@TestVisible private static final string ERROR_NEGATIVE_MIN = 'ERROR: Band Minimum must be greater than 0.';
    @TestVisible private static final string ERROR_MAX_ABOVE_MIN = 'ERROR: Band Maximum must be greater than its minimum.';
    @TestVisible private static final string ERROR_GAP = 'ERROR: Band Minimum must be 1 greater than prior band minimum.';
    @TestVisible private static final string ERROR_BAD_TLP = 'ERROR: Minimum TLP % must be between 0 and 100.';
    @TestVisible private static final string ERROR_BAD_UTIL = 'ERROR: Minimum Utilization % must be between 0 and 100.';
    @TestVisible private static final string ERROR_BAD_JSON = 'ERROR: Unexpected Error - server could not process the Band Data.';
    @TestVisible private static final string ERROR_NO_BANDS = 'ERROR: At least  Band must be defined.';
    @TestVisible private static final string ERROR_DML_FAIL = 'ERROR: Unexpected Error - DML Error while saving Bands';
    @TestVisible private static final string WARNING_TAG = 'WARNING: ';
    @TestVisible private static final string WARNING_NEW_BAND_MIN = 'The new minimum for the first band is greater than the old value.  ';
    @TestVisible private static final string WARNING_NEW_BAND_MAX = 'The new maximum for the last band is less than the old value.  ';
    @TestVisible private static final string WARNING_EXPLANATION = 'Any cases that have already entered the process but no longer fall into one of the Bands will be given the Status \'Exception\'. ';
    @TestVisible private static final string SAVE_STATUS_OK = 'OK: Custom Settings Saved.';

    public class Wrapper implements Comparable{
        public integer bandmin;
        public integer bandmax;
        public Decimal tlp;
        public Decimal util;

        public Wrapper (integer min, integer max, Decimal t, Decimal u) {
            bandmin = min;
            bandmax = max;
            tlp = t;
            util = u;
        }

        public integer compareTo(Object other) {
            return bandmin - ((Wrapper)other).bandmin;
        }
    }

    public string getBandsJSON() {
        List<Wrapper> bands = new List<Wrapper>();
        Map<String, DFDemo_Bands__c> bandsCustomSetting = DFDemo_Bands__c.getAll();
        if (!bandsCustomSetting.isEmpty()) {
	        for (DFDemo_Bands__c b : bandsCustomSetting.values()) {
	                List<String> bounds = b.name.split('-');
	                integer bandmin = integer.valueOf(bounds[0].replaceAll(',', ''));
	                integer bandmax = integer.valueOf(bounds[1].replaceAll(',', ''));
	                bands.add(new Wrapper(bandmin, bandmax, b.TLP__c, b.Lic_Util__c));
	        }
            bands.sort();
        }
        return System.JSON.serialize(bands);
    }

    @remoteaction
    public static string saveBands(String BandsJSON, boolean BoundsWarningOk) {
        String[] gackEmail = DFDemo_GackUtils.getDefaultExceptionEmailList();
        String gackSubject = 'GACK in ACC_AdminUIController.saveBands';
        String gackBody = 'GACK in ACC_AdminUIController.saveBands: ';

    	List<Wrapper> bands;
    	try {
            bands = (List<Wrapper>)System.JSON.deserialize(BandsJSON, List<Wrapper>.class);
    	}
    	catch (Exception e) {
    		gackBody += + e.getMessage();
    		DFDemo_GackUtils.sendGack(gackEmail, gackBody, gackSubject);
    		return ERROR_BAD_JSON;
    	}
    	if (bands.isEmpty()) {
    		return ERROR_NO_BANDS;
    	}

        bands.sort();

        //validate
        integer totalMin = bands[0].bandmin;
        integer totalMax = bands[bands.size()-1].bandmax;

        if (totalMin < 1)
            return ERROR_NEGATIVE_MIN;

        integer lastmax = -1;
        for (Wrapper band : bands) {
            if (band.bandmin > band.bandmax)
                return ERROR_MAX_ABOVE_MIN;
            if (lastmax > -1 && (band.bandmin - lastmax) != 1)
                return ERROR_GAP;
            if (band.tlp < 0 || band.tlp > 100)
                return ERROR_BAD_TLP;
            if (band.util < 0 || band.util > 100)
                return ERROR_BAD_UTIL;

            lastmax = band.bandmax;
        }

        if (!boundsWarningOk) {
            String warning = WARNING_TAG;
            if ( totalMin > DFDemo_FilterCriteria.get().getCurrentBandMin())
                warning += WARNING_NEW_BAND_MIN;
            if (totalMax < DFDemo_FilterCriteria.get().getCurrentBandMax())
                warning += WARNING_NEW_BAND_MAX;

            if(warning!=WARNING_TAG) {
                warning += WARNING_EXPLANATION;
                return warning;
            }
        }

        //update custom setting
        Map<String,DFDemo_Bands__c> originalBandsMap = DFDemo_Bands__c.getAll().clone(); //original map immutable
        List<DFDemo_Bands__c> upsertBands = new List<DFDemo_Bands__c>();
        DFDemo_Filter_Criteria__c fc = DFDemo_Filter_Criteria__c.getOrgDefaults();

        for(Wrapper band : bands) {
                String bandname = String.valueOf(band.bandmin) + '-' + String.valueOf(band.bandmax);
                DFDemo_Bands__c newBand;
                if (originalBandsMap.containsKey(bandname)) {
                        newBand = originalBandsMap.get(bandname);
                        originalBandsMap.remove(bandname);
                }
                else {
                        newBand = new DFDemo_Bands__c(name=bandname );
                }
                newBand.TLP__c = band.tlp;
                newBand.Lic_Util__c = band.util;
                upsertBands.add(newBand);
        }

        try {
	        upsert upsertBands;
	        delete originalBandsMap.values();

	        if (bands[0].bandmin != fc.Current_Band_Min__c || bands[bands.size()-1].bandmax != fc.Current_Band_Max__c) {
	            fc.Current_Band_Min__c = bands[0].bandmin;
	            fc.Current_Band_Max__c = bands[bands.size()-1].bandmax;
	            upsert fc;  //not update, just incase OrgDefaults not yet created

	        }
        }
        catch (Exception e) {
            gackBody += e.getMessage();
            DFDemo_GackUtils.sendGack(gackEmail, gackBody, gackSubject);
            return ERROR_DML_FAIL;
        }

        return(SAVE_STATUS_OK);
    }
}