@isTest
public with sharing class DFDemo_ObjectFactory {
	public static final String RANDOM_NAME = 'RandomName_' + String.valueOf(Math.random());
    public static final String SFDC_DOMAIN = '@salesforce.com';
    public static final String STANDARD_USER = 'Standard User';
    public static final String SYSTEM_ADMIN = 'System Administrator';    
    
    public static User getTestUser(string e, string profileName){
        profileName = String.isBlank(profileName) ? STANDARD_USER : profileName;
        list<Profile> profiles = [Select id from Profile where Name =: profileName limit 1];
        
        if(profiles.isEmpty()) return null;
        
        User u = new User(
            Username = e,
            LastName = RANDOM_NAME,
            CommunityNickname = 'nick' + String.valueOf(Math.random()),
            alias = 'testuser', //max length 8
            Email = e,
            ProfileId = profiles[0].id,
            TimeZoneSidKey = 'America/New_York',
            EmailEncodingKey='UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u;
        return u;
    }
    
    //given a list of SObjects, returns the set of unique object ids
    public static Set<Id> getObjectIds(List<SObject> objects) {
    	Set<id> ids = new Set<id>();
    	if (objects !=null) {
	    	for (SObject o : objects) {
	    		ids.add(o.id);
	    	}
    	}
    	return ids;

    }
    
    @isTest
    private static void getTestUser() {
        User u = getTestUser(RANDOM_NAME + SFDC_DOMAIN, STANDARD_USER);
        System.assertNotEquals(null, u);
    }
    
    public static Account getAccount() {
        return getAccount(RANDOM_NAME);
    }
    
    public static Account getAccount(String name) {
        return getAccounts(1, name)[0];
    }
    
    public static List<Account> getAccounts(Integer num) {
        return getAccounts(num, null);
    }

    public static List<Account> getAccounts(integer num, String accountName) {
        List<Account> accounts = new List<Account>{};

        for(Integer i = 0; i < num; i++) {
            Account a = new Account(name = String.isBlank(accountName) ? RANDOM_NAME : accountName + String.valueOf(i), ShippingCountry = 'US');
            accounts.add(a);
        }
        insert accounts;
        return accounts;
    }
}