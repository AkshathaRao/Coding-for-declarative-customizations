public with sharing class DFDemo_Bands {
    private Map<String, DFDemo_Bands__c> configObj = null;
    private static DFDemo_Bands config = null;
    private static Decimal band, tlp, licUtil, luTlp;
    private static Boolean evalUpgrade, evalDowngrade;
    private String MAX_VALUE = 'max';
    private String MIN_VALUE = 'min';
    private static DFDemo_Bands__c[] defaultValues;
    @TestVisible private static final Decimal FIRST_BAND_MIN = 1001;
    @TestVisible private static final Decimal FIRST_BAND_MAX = 100000;
    @TestVisible private static final Decimal FIRST_BAND_LIC_UTIL = 77;
    @TestVisible private static final Decimal FIRST_BAND_TLP = 66;
    @TestVisible private static final String FIRST_BAND_NAME = String.valueOf(FIRST_BAND_MIN) + '-' + String.valueOf(FIRST_BAND_MAX);
    @TestVisible private static final Decimal SECOND_BAND_MIN = 100001;
    @TestVisible private static final Decimal SECOND_BAND_MAX = 200000;
    @TestVisible private static final Decimal SECOND_BAND_LIC_UTIL = 58;
    @TestVisible private static final Decimal SECOND_BAND_TLP = 62;
    @TestVisible private static final String SECOND_BAND_NAME = String.valueOf(SECOND_BAND_MIN) + '-' + String.valueOf(SECOND_BAND_MAX);

    private void init() {
        if(defaultValues == null) defaultValues = new DFDemo_Bands__c[]{};
        DFDemo_Bands__c firstBand = new DFDemo_Bands__c();
        DFDemo_Bands__c secondBand = new DFDemo_Bands__c();

        firstBand.Lic_Util__c = FIRST_BAND_LIC_UTIL;
        firstBand.TLP__c = FIRST_BAND_TLP;
        firstBand.Name = FIRST_BAND_NAME;
        firstBand.SetupOwnerId = UserInfo.getOrganizationId();

        secondBand.Lic_Util__c = SECOND_BAND_LIC_UTIL;
        secondBand.TLP__c = SECOND_BAND_TLP;
        secondBand.Name = SECOND_BAND_NAME;
        secondBand.SetupOwnerId = UserInfo.getOrganizationId();

        defaultValues.add(firstBand);
        defaultValues.add(secondBand);

        insert defaultValues;

        setupConfigObj();
    }

    public void setupConfigObj() {
        configObj = DFDemo_Bands__c.getAll();
    }

    public static DFDemo_Bands get() {
        if (config == null) config = new DFDemo_Bands();
        return config;
    }

    public DFDemo_Bands() {
        setupConfigObj();
        if(configObj == null || configObj.isEmpty()) init();
    }

    public static void clear() {
        config = null;
    }

    public Decimal getTLP(Decimal val) {
        if(configObj == null || configObj.isEmpty() || val == null) return null;

        if(val == band && tlp != null && band != null) return tlp;

        setTLPAndLicUtil(val);

        return tlp;
    }

    public Decimal getLicUtil(Decimal val) {
        if(configObj == null || configObj.isEmpty() || val == null) return null;

        if(val == band && licUtil != null && band != null) return licUtil;

        setTLPAndLicUtil(val);

        return licUtil;
    }
    
    public Decimal getBandValue(String value) {
        Decimal min, max;
        List<Decimal> values = new List<Decimal>();

        if(String.isBlank(value) || (!value.equalsIgnoreCase(MAX_VALUE) && !value.equalsIgnoreCase(MIN_VALUE))) return null;

        for(String key :configObj.keySet()) {
            for(String bandValue :key.split('-')) {
                values.add(Decimal.valueOf(bandValue.replaceAll(',', '')));
            }
        }

        values.sort();

        if(values.isEmpty()) return null;

        if(value.equalsIgnoreCase(MAX_VALUE)) return values[values.size() - 1];

        return values[0];
    }

    private void setTLPAndLicUtil(Decimal val) {
        for(String key :configObj.keySet()) {
            Decimal min, max;
            Integer i;

            i = 0;
            //Try to match up the value from the current band value from the account to a range of account band values set in the custom setting
            for(String bandValue :key.split('-')) {
                if(min != null && max != null) break;

                if(i == 0) min = Decimal.valueOf(bandValue.replaceAll(',', ''));
                if(i == 1) max = Decimal.valueOf(bandValue.replaceAll(',', ''));

                i++;
            }

            if(DFdemo_Math.inRangeEqualTo(val, min, max)) {
                tlp = configObj.get(key).TLP__c;
                licUtil = configObj.get(key).Lic_Util__c;       
                band = val;
                break;
            } else {
                tlp = null;
                licUtil = null;
                band = null;
            }
        }
    }
}