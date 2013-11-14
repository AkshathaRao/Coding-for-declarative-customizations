@isTest
public with sharing class DFDemo_SecurityUtilsTest {
    private static User user = DFDemo_ObjectFactory.getTestUser('jhbcasjdvbajvb@werr.com',null);
    private static final String CASE_TEMPLATE_RECORD_TYPE_NAME = 'Template Case RT';
    private static String CASE_TEMPLATE_RECORD_TYPE_ID;
	
	static {
    	Schema.Describesobjectresult soResult = Case.SObjectType.getDescribe();
    	map<String, Schema.Recordtypeinfo> recordTypeInfos = soResult.getRecordTypeInfosByName();
    	CASE_TEMPLATE_RECORD_TYPE_ID = recordTypeInfos.get(CASE_TEMPLATE_RECORD_TYPE_NAME).getRecordTypeId();
    } 
    
    @isTest
    private static void testCheckRead() {
        System.runAs(user){
            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkRead(Opportunity.getSObjectType(), new String[] {'Name'});
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Opportunity'));

            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkRead(Case.getSObjectType(), new String[] {'CaseNumber'});
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Case'));
        }
    }

    @isTest
    private static void testCheckInsert() {
        System.runAs(user){
            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkCreate(Case.getSObjectType(), new String[] {'CaseNumber'});
            System.assertEquals(true, DFDemo_SecurityUtils.objectErrorMap.containsKey('Case'));

            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkCreate(Contact.getSObjectType(), new String[] {'Title'});
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Contact'));
        }
    }

    @isTest
    private static void testCheckUpdate() {
        System.runAs(user){
            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkUpdate(Contact.getSObjectType(), new String[] {'Title'});
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Contact'));

            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkUpdate(Contract.getSObjectType(), new String[] {'Name'});
            System.assertEquals(true, DFDemo_SecurityUtils.objectErrorMap.containsKey('Contract'));
        }
    }

    @isTest
    private static void testCheckDelete() {
        System.runAs(user){
            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkDelete(Contract.getSObjectType(), new String[] {'Name'});
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Contract'));

            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkDelete(Account.getSObjectType(), new String[] {'Name'});
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Account'));
        }
    }

    @isTest
    private static void testCheckIfObjectIsAccessible() {
        System.runAs(user){
            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkIfObjectIsAccessible('Opportunity',Opportunity.getSObjectType(),true);
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Opportunity'));

            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkIfObjectIsAccessible('Case',Case.getSObjectType(),true);
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Case'));
        }
    }

    @isTest
    private static void testCheckIfObjectIsCreateable() {
        System.runAs(user){
            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkIfObjectIsCreateable('Case',Case.getSObjectType(),true);
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Case'));

            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkIfObjectIsCreateable('Contact',Contact.getSObjectType(),true);
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Contact'));
        }
    }

    @isTest
    private static void testCheckIfObjectIsUpdateable() {
        System.runAs(user){
            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkIfObjectIsUpdateable('Contact',Contact.getSObjectType(),true);
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Contact'));

            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkIfObjectIsUpdateable('Contract',Contract.getSObjectType(),true);
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Contract'));
        }
    }

    @isTest
    private static void testCheckIfObjectIsDeletable() {
        System.runAs(user){
            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkIfObjectIsDeletable('Contract',Contract.getSObjectType(),true);
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Contract'));

            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkIfObjectIsDeletable('Account',Account.getSObjectType(),true);
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Account'));
        }
    }


    @isTest
    private static void testcheckIfFieldIsAccessible() {
        System.runAs(user){
            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkIfFieldIsAccessible('Account', Account.getSObjectType(), 'Name', true);
            System.assertNotEquals(true,DFDemo_SecurityUtils.objectErrorMap.containsKey('Account'));

            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkIfFieldIsAccessible('Account', Account.getSObjectType(), 'NumberOfEmployees', true);
            System.assertEquals(false,DFDemo_SecurityUtils.objectErrorMap.containsKey('Account'));

        }
    }

    @isTest
    private static void testcheckIfFieldIsCreateable() {
        System.runAs(user){
            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkIfFieldIsCreateable('Account', Account.getSObjectType(), 'Name', true);
            System.assertNotEquals(true,DFDemo_SecurityUtils.objectErrorMap.containsKey('Account'));

            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkIfFieldIsCreateable('Account', Account.getSObjectType(), 'NumberOfEmployees', true);
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Account'));
        }
    }

    @isTest
    private static void testcheckIfFieldIsUpdateable() {
        System.runAs(user){
            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkIfFieldIsUpdateable('Account', Account.getSObjectType(), 'Name', true);
            System.assertNotEquals(true,DFDemo_SecurityUtils.objectErrorMap.containsKey('Account'));
            
            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.checkIfFieldIsUpdateable('Account', Account.getSObjectType(), 'NumberOfEmployees', true);
            System.assertEquals(false, DFDemo_SecurityUtils.objectErrorMap.containsKey('Account'));

        }
    }

    @isTest
    private static void testHasObjectError() {
        System.runAs(user) {
            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.errorObjFieldList.clear();
            DFDemo_SecurityUtils.checkRead(Opportunity.getSObjectType(), new String[] {'Name'});
            System.assertEquals(false,DFDemo_SecurityUtils.hasObjectError('Opportunity'));

            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.errorObjFieldList.clear();
            DFDemo_SecurityUtils.checkRead(Case.getSObjectType(), new String[] {'CaseNumber'});
            System.assertNotEquals(true,DFDemo_SecurityUtils.hasObjectError('Case'));
        }
    }

    @isTest
    private static void testHasFieldError() {
        system.runAs(user) {
            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.errorObjFieldList.clear();
            DFDemo_SecurityUtils.checkIfFieldIsAccessible('Account', Account.getSObjectType(), 'Name', true);
            System.assertNotEquals(true,DFDemo_SecurityUtils.hasObjectError('Account'));
            System.assertNotEquals(true,DFDemo_SecurityUtils.hasFieldError('Account', 'Name'));

            DFDemo_SecurityUtils.objectErrorMap.clear();
            DFDemo_SecurityUtils.errorObjFieldList.clear();
            DFDemo_SecurityUtils.checkIfFieldIsAccessible('Account', Account.getSObjectType(), 'NumberOfEmployees', true);
            System.assertNotEquals(true,DFDemo_SecurityUtils.hasObjectError('Account'));
            System.assertEquals(false,DFDemo_SecurityUtils.hasFieldError('Account', 'NumberOfEmployees'));

        }
    }
    
    @isTest
    private static void testCheckIfRecordTypeIsAvailableByName() {
    	clearMap();
    	
    	System.runAs(user) {
    		DFDemo_SecurityUtils.checkIfRecordTypeIsAvailableByName(Case.getSObjectType(), CASE_TEMPLATE_RECORD_TYPE_NAME);
    	}
    }
    
    @isTest
    private static void checkIfRecordTypeIsAvailableById() {
    	clearMap();
    	
    	System.runAs(user) {
    		DFDemo_SecurityUtils.checkIfRecordTypeIsAvailableById(Case.getSObjectType(), CASE_TEMPLATE_RECORD_TYPE_ID);
    	}
    }
    
    private static void clearMap() {	
        DFDemo_SecurityUtils.objectErrorMap.clear();
        DFDemo_SecurityUtils.errorObjFieldList.clear();
    }
}