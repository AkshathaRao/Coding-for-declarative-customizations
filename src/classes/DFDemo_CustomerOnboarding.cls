public with sharing class DFDemo_CustomerOnboarding{
 private Map<Id, Account> accountsNew { get; set; }
 public final string ONBOARDING_CASE_TEMPLATE = 'Onboarding Case template';
 private Set<Id> accountsReadyToProcess {
        get {
            if(accountsReadyToProcess == null) accountsReadyToProcess = new Set<Id>();
            return accountsReadyToProcess;
        }
        set;
    }
       
 public DFDemo_CustomerOnboarding(Map<Id, Account> acctsNew) {
        accountsNew = acctsNew;
    }
    
 private boolean getAccountsReadyToProcess() {
        for(Account acct :accountsNew.values()) {
            if(String.isBlank(acct.On_boarding_Status__c)) continue;

            if(acct.On_boarding_Status__c.equalsIgnoreCase(Label.DFDemo_Onboarding_Status_Processing)) {
                accountsReadyToProcess.add(acct.Id);
            }
        }

        return !accountsReadyToProcess.isEmpty();
    }
    
 private void createCaseAndSetAccountsInProgress() {
     DFDemo_CaseUtils caseUtils = new DFDemo_CaseUtils();
     caseUtils.gackEmails = System.label.DFDemo_Case_Creation_Failure_Email.split(',');
     caseUtils.createCasesFromNamedTemplate(ONBOARDING_CASE_TEMPLATE,accountsReadyToProcess);
     for(Account currentAccount : [Select Id, On_boarding_Status__c from Account where Id In :accountsReadyToProcess]) {
         Account accountToUpdate = accountsNew.get(currentAccount.Id);
         accountToUpdate.On_boarding_Status__c = Label.DFDemo_Onboarding_Status_In_Progress;
     }
 }
 
 public void processAccount() {
        if (getAccountsReadyToProcess()) {
            createCaseAndSetAccountsInProgress();
        }
    }
}