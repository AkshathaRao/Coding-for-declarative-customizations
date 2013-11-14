@isTest
private class DFDemo_StringUtilsTest {
    private static final String OUTER_DELIM = ',';
    private static final String INNER_DELIM = '=';
    private static final String NULL_REPLACEMENT = 'WASNULL';
   	private static final String NULL_STRING;
    private static final String EMPTY_STRING = '';
    private static final String BLANK_STRING = ' ';
    private static final String BLANKS_STRING = '    ';
    private static final String NON_BLANK_STRING = 'foo';
	
    @isTest
    static void splitByLines() {
        String s;
        System.assertEquals(true, DFDemo_StringUtils.splitByLines(s).isEmpty());

        s = DFDemo_ObjectFactory.RANDOM_NAME + '\n' + DFDemo_ObjectFactory.RANDOM_NAME;
        System.assertEquals(2, DFDemo_StringUtils.splitByLines(s).size());
    }
	
    @isTest
    static void getMapFromDelimitedString() {
        String s, outerDelimeter, innerDelimeter, key, value;
        Set<String> keys = new Set<String>();
        Map<String, String> retVal;

        key = DFDemo_ObjectFactory.RANDOM_NAME;
        value = DFDemo_ObjectFactory.RANDOM_NAME;

        retVal = DFDemo_StringUtils.getMapFromDelimitedString(s, outerDelimeter, innerDelimeter, keys);
        System.assertEquals(true, retVal.isEmpty());

        s = key + INNER_DELIM + value + OUTER_DELIM;
        retVal = DFDemo_StringUtils.getMapFromDelimitedString(s, outerDelimeter, innerDelimeter, keys);
        System.assertEquals(true, retVal.isEmpty());

        outerDelimeter = OUTER_DELIM;
        retVal = DFDemo_StringUtils.getMapFromDelimitedString(s, outerDelimeter, innerDelimeter, keys);
        System.assertEquals(true, retVal.isEmpty());

        innerDelimeter = INNER_DELIM;
        retVal = DFDemo_StringUtils.getMapFromDelimitedString(s, outerDelimeter, innerDelimeter, keys);
        System.assertEquals(true, retVal.isEmpty());

        keys.add(key);
        retVal = DFDemo_StringUtils.getMapFromDelimitedString(s, outerDelimeter, innerDelimeter, keys);
        System.assertEquals(false, retVal.isEmpty());
    }
    
    @isTest
    static void testSubstitute() {
		System.assertEquals(NON_BLANK_STRING, DFDemo_StringUtils.substitute(NON_BLANK_STRING, NULL_STRING));
		System.assertEquals(NON_BLANK_STRING, DFDemo_StringUtils.substitute(NON_BLANK_STRING, NON_BLANK_STRING));
    }

    @isTest
    static void testNullValue() {
        System.assertEquals(NULL_REPLACEMENT	, DFDemo_StringUtils.nullValue(NULL_STRING    	, 	NULL_REPLACEMENT));
        System.assertEquals(EMPTY_STRING        , DFDemo_StringUtils.nullValue(EMPTY_STRING   	, 	NULL_REPLACEMENT));
        System.assertEquals(BLANK_STRING        , DFDemo_StringUtils.nullValue(BLANK_STRING		, 	NULL_REPLACEMENT));
        System.assertEquals(BLANKS_STRING		, DFDemo_StringUtils.nullValue(BLANKS_STRING	, 	NULL_REPLACEMENT));
        System.assertEquals(NON_BLANK_STRING	, DFDemo_StringUtils.nullValue(NON_BLANK_STRING	, 	NULL_REPLACEMENT));
    }
}