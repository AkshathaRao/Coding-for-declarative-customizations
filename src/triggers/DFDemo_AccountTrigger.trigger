trigger DFDemo_AccountTrigger on Account (after delete, after insert, after update, before delete, before insert, before update) {
    if(Trigger.isUpdate && Trigger.isBefore) {
    	DFDemo_CustomerOnboarding dFDemoCustomerOnboarding = new DFDemo_CustomerOnboarding(Trigger.newmap);
        dFDemoCustomerOnboarding.processAccount();
    }
}