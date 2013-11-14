<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_onboarding_status_to_Evaluating</fullName>
        <description>Set onboarding status to &apos;Evaluating&apos;</description>
        <field>On_boarding_Status__c</field>
        <formula>$Label.DFDemo_Onboarding_Status_Evaluate</formula>
        <name>Set onboarding status to Evaluating</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_onboarding_status_to_Evaluating_fail</fullName>
        <description>Set Onboarding status to evaluating again if the Account has failed the onboarding program</description>
        <field>On_boarding_Status__c</field>
        <formula>IF( On_boarding_Status__c = $Label.DFDemo_Onboarding_Status_Failed , $Label.DFDemo_Onboarding_Status_Evaluate, On_boarding_Status__c)</formula>
        <name>Set onboarding status to Evaluating fail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_onboarding_status_to_processing</fullName>
        <description>Sets onboarding status to Processing</description>
        <field>On_boarding_Status__c</field>
        <formula>$Label.DFDemo_Onboarding_Status_Processing</formula>
        <name>Set onboarding status to Processing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set account Onboarding status to %27Evaluating%27</fullName>
        <active>true</active>
        <description>Sets Onboarding status to &apos;Evaluating&apos; at 2,5,10,15 days after Activation Date</description>
        <formula>AND(On_boarding_Status__c = $Label.DFDemo_Onboarding_Status_In_Progress, Activation_Date__c &gt;= TODAY() - 16 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_onboarding_status_to_Evaluating</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Set_onboarding_status_to_Evaluating_fail</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>12</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Set_onboarding_status_to_Evaluating_fail</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Set_onboarding_status_to_Evaluating_fail</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Set account onboarding status to %27Processing%27</fullName>
        <actions>
            <name>Set_onboarding_status_to_processing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets onboarding status to &apos;Processing&apos; when the account is activated.</description>
        <formula>AND( NOT(ISBLANK(Activation_Date__c)) , On_boarding_Status__c = &apos;&apos;, OR( ISPICKVAL(Support_Level__c, &apos;Premier&apos;), ISPICKVAL(Support_Level__c, &apos;Basic&apos;) ), OR( ISPICKVAL(Region__c, &apos;AMER East&apos;), ISPICKVAL(Region__c, &apos;AMER West&apos;) ), Account_Value__c &gt;=  $Setup.DFDemo_Filter_Criteria__c.Current_Band_Min__c  , Account_Value__c&lt;= $Setup.DFDemo_Filter_Criteria__c.Current_Band_Max__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
