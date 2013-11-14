@isTest
private class DFDemo_CaseUtilsTest {
    private static final String SUPPORT_LEVEL = 'Premier';
    private static final String REGION = 'AMER East';
    private static final String CASE_TEMPLATE_RECORD_TYPE_NAME = 'Template Case RT';
    private static final String TEST_TEMPLATE = 'Onboarding Case template';
    private static final String TEST_CASE_SUBJECT = 'Test Case Subject';
    private static final String TEST_CASE_DESCRIPTION = 'Test Case Description';
    private static final String TEST_CASE_PRIORITY = 'Medium';
    private static final String TEST_CASE_STATUS = 'New';
    private static String CASE_TEMPLATE_RECORD_TYPE_ID;
    private static User templateOwner;
    
    static {
    	Schema.Describesobjectresult soResult = Case.SObjectType.getDescribe();
    	map<String, Schema.Recordtypeinfo> recordTypeInfos = soResult.getRecordTypeInfosByName();
    	CASE_TEMPLATE_RECORD_TYPE_ID = recordTypeInfos.get(CASE_TEMPLATE_RECORD_TYPE_NAME).getRecordTypeId();
    	templateOwner = DFDemo_ObjectFactory.getTestUser('venom@labbit.com', null);   
    	setupCaseTemplates(); 	
    }    

    @isTest
    static void simpleTestByID() {
    	Account a = DFDemo_ObjectFactory.getAccount();
        Case template = new Case(AccountId = a.id, subject = 'Test Case');
        Test.startTest();
        List<Case> newCases = (new DFDemo_CaseUtils()).createCasesFromTemplate(template, new set<Id>{a.id}, null, false);
        Test.stopTest();
        System.assertEquals(1, newCases.size());

        List<Case> foundCases = [Select id, description, priority, subject, status, recordtypeid, recordtype.name from Case where AccountId = :a.id];
        System.assertEquals(1, foundCases.size());
    }
    
    @isTest
    static void simpleTestByAccount() {
    	Account a = DFDemo_ObjectFactory.getAccount();
        Case template = new Case(AccountId = a.id, subject = 'Test Case');
        Test.startTest();
        List<Case> newCases = (new DFDemo_CaseUtils()).createCasesFromNamedTemplate(TEST_TEMPLATE, new set<Id>{a.id});
        Test.stopTest();
        System.assertEquals(1, newCases.size());

        List<Case> foundCases = [Select id, description, priority, subject, status, recordtypeid, recordtype.name from Case where AccountId = :a.id];
        System.assertEquals(1, foundCases.size());
    }
    
    @isTest
    static void simpleTestByAccountList() {
    	Account a = DFDemo_ObjectFactory.getAccount();
        Case template = new Case(AccountId = a.id, subject = 'Test Case');
        Test.startTest();
        List<Case> newCases = (new DFDemo_CaseUtils()).createCasesFromNamedTemplate(TEST_TEMPLATE, new list<Account>{a}, true);
        Test.stopTest();
        System.assertEquals(1, newCases.size());

        List<Case> foundCases = [Select id, description, priority, subject, status, recordtypeid, recordtype.name from Case where AccountId = :a.id];
        System.assertEquals(1, foundCases.size());
    }

    @isTest
    static void getAccountListErrorTextTest() {
    	List<id> fakeIds = new List<id> {'001009999999001', '001009999999002', '001009999999003'};
    	Set<Id> idset = new set<id>(fakeIds);
    	List<String> idStrings = fakeIds;
        Test.startTest();
        String errorText = (new DFDemo_CaseUtils()).getAccountListErrorText(idset);
        Test.stopTest();

        System.assert(errorText.contains('No case was created for the following accounts:'));
        for (String idString : idStrings) {
        	System.assert(errorText.contains(idString));
        }
    }
    
    private static void setupCaseTemplates() {
        Account tmplAcct = DFDemo_ObjectFactory.getAccount();
        User u = DFDEmo_ObjectFactory.getTestUser(DFDemo_ObjectFactory.RANDOM_NAME + DFDemo_ObjectFactory.SFDC_DOMAIN, null);
        Case template  = new Case(
           AccountId   = tmplAcct.id,
           Subject     = TEST_CASE_SUBJECT,
           Description = TEST_CASE_DESCRIPTION,
           Priority    = TEST_CASE_PRIORITY,
           Status      = TEST_CASE_STATUS,
           RecordTypeId= CASE_TEMPLATE_RECORD_TYPE_ID,
           OwnerId     = templateOwner.id);
           
        insert template;

        DFDemo_CaseUtils_Templates__c templateMapEntry = new DFDemo_CaseUtils_Templates__c(
        	Name			= TEST_TEMPLATE, 
        	TemplateId__c 	= template.id, 
        	RecordTypeId__c	= CASE_TEMPLATE_RECORD_TYPE_ID);
        	
        insert templateMapEntry;
    }
}