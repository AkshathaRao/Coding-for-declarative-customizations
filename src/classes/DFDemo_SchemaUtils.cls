public class DFDemo_SchemaUtils {

    private static Map<String, Schema.SObjectType> typeMap;
    private static Map<Schema.SObjectType, Map<String, Schema.FieldSet>> sobjectFieldSetMap = new map<Schema.SObjectType, Map<String, Schema.FieldSet>>();
    private static Map<Schema.SObjectType, Schema.DescribeSObjectResult> sobjectDescribeMap = new map<Schema.SObjectType, Schema.DescribeSObjectResult>();

    // given an SObject name, get the Describe info for the object
    // cached - will only call Schema.Sobjecttype.getDescribe() once per object type
    public static Schema.DescribeSObjectResult getObjectDescribe(string SObjectName) {
        Schema.SObjectType sot = getSObjectType(sObjectName);
        if (sot == null) return null;
        return getObjectDescribe(sot);

    }

    // given an SObjectType, get the Describe info for the object
    // cached - will only call Schema.Sobjecttype.getDescribe() once per object type
    public static Schema.DescribeSObjectResult getObjectDescribe(Schema.SObjectType sObjType) {
        if (! sobjectDescribeMap.containsKey(sObjType)) {
            sobjectDescribeMap.put(sObjType, sObjType.getDescribe());
        }
        return sobjectDescribeMap.get(sObjType);
    }


    // given an SObject name as a string, return the Schema.SObjectType token for the sobject
    // cached - will only call Schema.getGlobalDescribe() once
    public static Schema.SObjectType getSObjectType(string SObjectName) {
        if (typeMap == null) {
            typeMap = Schema.getGlobalDescribe();
        }
        return typeMap.get(SObjectName);
    }

    // given an Sobject name as a string and a fieldSet name, return the corresponding Schema.FieldSet object
    // cached - will only call getDescribe once per SObjectType
    public static Schema.FieldSet getFieldSet(string sObjName, string fieldSetName){
        Schema.SObjectType sot = getSObjectType(sObjName);
        if (sot == null) return null;
        return getFieldSet(sot, fieldSetName);
    }

    // given an SobjectType token and a fieldSet name, return the corresponding Schema.FieldSet object
    // cached - will only call getDescribe once per SObjectType
    public static Schema.FieldSet getFieldSet(Schema.SObjectType sObjType, string fieldSetName){
        Map<String, Schema.FieldSet> fsMap = sobjectFieldSetMap.get(sObjType);
        if (fsMap == null) {
            fsMap = sObjType.getDescribe().fieldSets.getMap();
            sobjectFieldSetMap.put(sObjType, fsMap);
        }
        return fsMap.get(fieldSetName);
    }

    // given a Schema.FieldSet object and a list of additional field names, constructs a dynamic soql query
    // for all the fields from the relevant SObjectType.  The additionalFields list allows fields to be included that
    // should not be user editable in the field list - for example, fields needed by a potential where clause
    // Generated SOQL text will always end with a space character, to allow direct concatenation of additional
    // SOQL elements such as a WHERE clause
    public static string getFieldSetSOQL(Schema.FieldSet fs, List<string> additionalFields){
        // use a set to prevent duplicate fields
        Set<string> f = getFSSet(fs, additionalFields);
        // use a list to join.  sort for testability
        List<string> fl = new List<string>();
        fl.addAll(f);
        fl.sort();
        // get the object name
        Schema.Describesobjectresult objDesc = getObjectDescribe(fs.getSObjectType());

        string SOQL = 'SELECT ' + string.join(fl, ', ') + ' FROM ' + objDesc.getName() + ' ';
        return String.escapeSingleQuotes(SOQL);

    }

    public static string getFieldSetSOQL(Schema.FieldSet fs){
        return getFieldSetSOQL(fs, null);
    }

    // convenience method to get a field from an sObject.  This is useful when your fieldset
    // contains related object fields.  For example, a fieldset on Case that contains
    // 'contact.name'.  If you need to iterate the fieldset pulling out values (for example,
    // constructing a param string) you can't use sObj.get(fieldpath) for fieldpath='contact.name'

    public static String getSObjectField(sObject sObj, String fieldpath) {
        String[] pathParts = fieldpath.split('[.]', 2);
        if (pathParts.size() == 1) return String.valueOf(sObj.get(fieldpath));
        return getSObjectField(sObj.getSObject(pathParts[0]), pathParts[1]);
    }

    // given a fieldset and a list of additional name, runs DFDemo_SecurityUtils.checkRead() for the
    // appopriate object and list of fields.  convenience method.
    public static void checkFieldsetRead(Schema.FieldSet fs, List<string> additionalFields){
        // use a set to prevent duplicate fields
        Set<string> f = getFSSet(fs, additionalFields);
        // use a list to join.  sort for testability
        List<string> fl = new List<string>();
        fl.addAll(f);
        DFDemo_SecurityUtils.checkRead(fs.getSObjectType(), fl);
    }

    public static void checkFieldsetRead(Schema.FieldSet fs){
        checkFieldsetRead(fs, null);
    }


    // convenience method: given a field set, returns a list of fieldpaths as strings
    // note that fieldpaths will be all lower case due ease uniquification
    public static List<String> getFieldSetFields(Schema.FieldSet fs) {
        List<String> fl = new List<String>();
        for (Schema.FieldSetMember member : fs.getFields()) {
            fl.add(member.getFieldPath().toLowerCase());
        }
        return fl;
    }

    // convenience method: given a field set, returns a list of field labels as strings
    public static List<String> getFieldSetLabels(Schema.FieldSet fs) {
        List<String> fl = new List<String>();
        for (Schema.FieldSetMember member : fs.getFields()) {
            fl.add(member.getLabel());
        }
        return fl;
    }

    // helper method to assemble a list of unique fields
    private static Set<String> getFSSet(Schema.FieldSet fs, List<string> additionalFields) {
        Set<string> f = new Set<string>();
        f.addAll(getFieldSetFields(fs));

        if (additionalFields != null) {
            for (string fld : additionalFields) {
                f.add(fld.toLowerCase());
            }
        }
        return f;
    }


}