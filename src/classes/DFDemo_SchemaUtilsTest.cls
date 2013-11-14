@isTest
public with sharing class DFDemo_SchemaUtilsTest {
	private static final string CASE_FIELDSET = 'DFDemo_CaseUtils_AutoCreate_Fields';
    private static final string FAKE_FIELDSET = 'PHONEY_FIELDSET';

    private static void verifySoql(String soql, String soql_expect) {
        System.assertEquals(true, soql.contains(soql_expect));
    }
    
    @isTest
    static void GetFieldSetBySObjectTypeTest() {
        Schema.FieldSet fs = DFDemo_SchemaUtils.getFieldSet(Case.getSObjectType(), CASE_FIELDSET);
        system.assertNotEquals(null, fs, 'getFieldSet (by SObjectType) should not return null for existing FS');
        system.assertEquals(Case.getSObjectType(), fs.getSObjectType(), 'getFieldSet (by SObjectType) should return a fieldset on Case object');
        system.assertEquals(CASE_FIELDSET, fs.getName(), 'getFieldSet (by SObjectType) should return correct fieldset');
    }

    @isTest
    static void GetFieldSetBySObjectNameTest() {
        Schema.FieldSet fs = DFDemo_SchemaUtils.getFieldSet('Case', CASE_FIELDSET);
        system.assertNotEquals(null, fs, 'getFieldSet (by SObject name) should not return null for existing FS');
        system.assertEquals(Case.getSObjectType(), fs.getSObjectType(), 'getFieldSet (by SObject name) should return a fieldset on Case object');
        system.assertEquals(CASE_FIELDSET, fs.getName(), 'getFieldSet (by SObject name) should return correct fieldset');
    }

    @isTest
    static void GetFieldSetWithBadName() {
        Schema.FieldSet fs = DFDemo_SchemaUtils.getFieldSet('Case', FAKE_FIELDSET);
        system.assertEquals(null, fs);
    }

    @isTest
    static void GetFieldSetSOQLTest() {
        Schema.FieldSet fs = DFDemo_SchemaUtils.getFieldSet(Case.getSObjectType(), CASE_FIELDSET);
        String soql = DFDemo_SchemaUtils.getFieldSetSOQL(fs);
        string soql_expect = 'SELECT description, priority, status, subject FROM Case';
        verifySoql(soql, soql_expect);
    }

    @isTest
    static void GetFieldSetSOQLAddFieldsTest() {
        Schema.FieldSet fs = DFDemo_SchemaUtils.getFieldSet(Case.getSObjectType(), CASE_FIELDSET);
        List<String> addFields = new List<String>{'id', 'ActivityDate'};
        String soql = DFDemo_SchemaUtils.getFieldSetSOQL(fs, addFields);
        string soql_expect = 'SELECT activitydate, description, id, priority, status, subject FROM Case';
        verifySoql(soql, soql_expect);
    }

    @isTest
    static void GetFieldSetSOQLAddFieldsDuplicatesTest() {
        Schema.FieldSet fs = DFDemo_SchemaUtils.getFieldSet(Case.getSObjectType(), CASE_FIELDSET);
        List<String> addFields = new List<String>{'id', 'ActivityDate', 'Priority'};
        String soql = DFDemo_SchemaUtils.getFieldSetSOQL(fs, addFields);
        string soql_expect = 'SELECT activitydate, description, id, priority, status, subject FROM Case';
        verifySoql(soql, soql_expect);
    }

    @isTest
    static void CheckFieldsetReadTest() {
        Schema.FieldSet fs = DFDemo_SchemaUtils.getFieldSet(Case.getSObjectType(), CASE_FIELDSET);
        DFDemo_SecurityUtils.objectErrorMap.clear();
        try {
            DFDemo_SchemaUtils.checkFieldsetRead(fs);
        } catch(DFDemo_SecurityUtils.DFDemo_SecurityException se){
            system.debug(se);
        }
        System.assertNotEquals(true,DFDemo_SecurityUtils.objectErrorMap.containsKey('Case'));
    }

    @isTest
    static void getObjectDescribeTest() {
        Schema.DescribeSObjectResult objDesc = DFDemo_SchemaUtils.getObjectDescribe('Case');
        system.assertEquals(Case.getSObjectType().getDescribe().getName(), objDesc.getName());

    }

    @isTest
    static void GetFieldSetFieldsTest() {
        Schema.FieldSet fs = DFDemo_SchemaUtils.getFieldSet(Case.getSObjectType(), CASE_FIELDSET);
        List<String> fl = DFDemo_SchemaUtils.getFieldSetFields(fs);
        fl.sort(); //make assertion simpler
        String got = String.join(fl, ', ');
        System.assertEquals('description, priority, status, subject', got);
    }

    @isTest
    static void GetFieldSetLabelsTest() {
        Schema.FieldSet fs = DFDemo_SchemaUtils.getFieldSet(Case.getSObjectType(), CASE_FIELDSET);
        List<String> fl = DFDemo_SchemaUtils.getFieldSetLabels(fs);
        fl.sort(); //make assertion simpler
        String got = String.join(fl, ', ');
        System.assertEquals('Description, Priority, Status, Subject', got);
    }
}