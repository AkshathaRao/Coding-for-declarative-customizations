public with sharing class DFDemo_CaseUtils {

    private static final String CASE_SOBJECT_NAME = 'Case';
    private static Map<String, DFDemo_CaseUtils_Templates__c> templateMap;
    private static Integer MAX_SOQL_QUERY_LENGTH = 20000; // as of Summer 13
    private static string baseURL;


    public List<String> gackEmails {get; set;}

    static {
       templateMap = DFDemo_CaseUtils_Templates__c.getAll();
       baseURL = URL.getSalesforceBaseUrl().toExternalForm() + '/';
    }

    public DFDemo_CaseUtils() {
        gackEmails = DFDemo_GackUtils.getDefaultExceptionEmailList();
    }

    public List<Case> createCasesFromTemplate(Case template, Set<Id> accountIds, Id recordTypeOverride, boolean applyAssignmentRules) {
        // CRUD Check - Case Create
        DFDemo_SecurityUtils.objectErrorMap.clear();
        DFDemo_SecurityUtils.checkIfObjectIsCreateable(CASE_SOBJECT_NAME, Case.SObjectType, true);
        if (DFDemo_SecurityUtils.hasObjectError(CASE_SOBJECT_NAME)) {
            String error = DFDemo_StringUtils.substitute(System.Label.DFDemo_CaseUtils_User_Create_Perms_Error, UserInfo.getUserName());
            System.debug('GACK: '+ error);
            error = error + getAccountListErrorText(accountIds);
            DFDemo_GackUtils.sendGack(gackEmails, error, System.Label.DFDemo_CaseUtils_Gack_Subject);
            return null;
        }
        // Perms Check - Case Record Type
        id targetRecordTypeId = recordTypeOverride == null ? template.recordTypeId : recordTypeOverride;
        Schema.RecordTypeInfo rtInfo = DFDemo_SecurityUtils.getRecordTypeInfoById(Case.SObjectType, targetRecordTypeId);
        if (rtInfo==null) {
            String error = DFDemo_StringUtils.substitute(System.Label.DFDemo_CaseUtils_Bad_RecordType, targetRecordTypeId);
            System.debug('GACK: '+ error);
            error = error + getAccountListErrorText(accountIds);
            DFDemo_GackUtils.sendGack(gackEmails, error, System.Label.DFDemo_CaseUtils_Gack_Subject);
            return null;
        }
        string targetRecordTypeName = rtInfo.getName();
        if (!DFDemo_SecurityUtils.checkIfRecordTypeIsAvailableById( Case.SObjectType, targetRecordTypeId )) {
            String error = DFDemo_StringUtils.substitute(System.Label.DFDemo_CaseUtils_User_RecordType_Perms_Error, targetRecordTypeName);
            System.debug('GACK: '+ error);
            error = error + getAccountListErrorText(accountIds);
            DFDemo_GackUtils.sendGack(gackEmails, error, System.Label.DFDemo_CaseUtils_Gack_Subject);
            return null;
        }

        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= applyAssignmentRules;

        List<Case> newCases = new List<Case>();
        for (id acctId : accountIds) {
            Case c = template.clone();
            if (recordTypeOverride != null) {
                c.RecordTypeId = recordTypeOverride;
            }
            c.accountId = acctId;
            c.setOptions(dmo);
            newCases.add(c);
        }

        Database.SaveResult[] results = Database.insert(newCases, false);

        String errorReport = getErrorReport(results, newCases);
        if ( String.isNotBlank(errorReport) ) {
            DFDemo_GackUtils.sendGack(gackEmails, errorReport, System.Label.DFDemo_CaseUtils_DML_Gack_Subject);
            return null;
        }

        return newCases;
    }
    
    public List<Case> createCasesFromNamedTemplate(String templateName, Set<Id> accountIds) {
        return createCasesFromNamedTemplate(templateName, accountIds, true);
    }

    public List<Case> createCasesFromNamedTemplate(String templateName, List<Account> accounts, boolean applyAssignmentRules) {
        Map<id, Account> tmpMap = new Map<id, Account>(accounts);
        return createCasesFromNamedTemplate(templateName, tmpMap.keySet(), applyAssignmentRules);
    }
   
    public List<Case> createCasesFromNamedTemplate(String templateName, Set<Id> accountIds, boolean applyAssignmentRules) {
        String gackSubject = DFDemo_StringUtils.substitute(System.Label.DFDemo_CaseUtils_NamedTemplate_Gack_Subject, templateName);

        DFDemo_CaseUtils_Templates__c templateInfo = templateMap.get(templateName);
        if (templateInfo == null || templateInfo.templateid__c == null) {
            String error = DFDemo_StringUtils.substitute(System.Label.DFDemo_CaseUtils_Bad_TemplateName, templateName);
            System.debug('GACK: '+ error);
            error = error + getAccountListErrorText(accountIds);
            DFDemo_GackUtils.sendGack(gackEmails, error, DFDemo_StringUtils.substitute(System.Label.DFDemo_CaseUtils_NamedTemplate_Gack_Subject, templateName));
            return null;
        }
        String templateId = templateInfo.templateid__c;

        Fieldset fs = DFDemo_SchemaUtils.getFieldSet(DFDemo_SchemaUtils.getSObjectType(CASE_SOBJECT_NAME), templateInfo.FieldSet_Name__c);
        if (fs == null) {
            String error = DFDemo_StringUtils.substitute(System.Label.DFDemo_CaseUtils_Bad_Fieldset, new List<String>{templateInfo.FieldSet_Name__c, templateName} );
            System.debug('GACK: '+ error);
            error = error + getAccountListErrorText(accountIds);
            DFDemo_GackUtils.sendGack(gackEmails, error, gackSubject);
            return null;
        }

        String query = DFDemo_SchemaUtils.getFieldSetSOQL(fs);
        query = query + 'where id = :templateId';

        if (query.length()> MAX_SOQL_QUERY_LENGTH) {
            String error = System.Label.DFDemo_CaseUtils_Query_Too_Long_Error;
            System.debug('GACK: '+ error);
            error = error + getAccountListErrorText(accountIds);
            DFDemo_GackUtils.sendGack(gackEmails, error, gackSubject);
            return null;

        }

        Case template;
        try {
            template = Database.query(query);
        }
        catch(Exception e) {
            String error = DFDemo_StringUtils.substitute(System.Label.DFDemo_CaseUtils_Query_Exception_Error, e.getMessage());
            System.debug('GACK: '+ error);
            error = error + getAccountListErrorText(accountIds);
            DFDemo_GackUtils.sendGack(gackEmails, error, gackSubject);
            return null;
        }

        if (template == null) {
            String error = DFDemo_StringUtils.substitute(System.Label.DFDemo_CaseUtils_Bad_TemplateId, new List<String>{templateId , templateName} );
            System.debug('GACK: '+ error);
            error = error + getAccountListErrorText(accountIds);
            DFDemo_GackUtils.sendGack(gackEmails, error, gackSubject);
            return null;
        }

        return createCasesFromTemplate(template, accountIds, templateInfo.RecordTypeId__c, applyAssignmentRules);

    }


    @TestVisible
    private String getAccountListErrorText(Set<id> acctIds) {
        String text = '\n' + System.Label.DFDemo_CaseUtils_No_Case_Created_Prefix + ' \n';
        for (id acct : acctIds) {
            text = text + baseURL + acct + '\n';
        }
        return text;
    }

    @TestVisible
    private String getErrorReport(List<Database.SaveResult> results, list<Case> newCases) {
        String errors = '';
        for (integer i = 0; i < results.size(); i++) {
            if (!results[i].isSuccess()) {
                errors = baseURL + newCases[i].accountId + ': ' + getAllErrors(results[i].getErrors()) + '\n';
            }
        }
        if (String.isNotBlank(errors)) {
            errors = System.Label.DFDemo_CaseUtils_Failed_Cases_Prefix + '\n' + errors;
        }
        return errors;
    }

    private String getAllErrors(List<Database.Error> errors) {
        List<String> msgs = new List<String>();
        for (Database.Error e : errors) {
            msgs.add(e.getMessage());
        }
        return String.join(msgs, '; ');

    }
}