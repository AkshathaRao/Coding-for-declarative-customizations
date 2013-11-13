public class DFDemo_SecurityUtils {

    public class DFDemo_SecurityException extends Exception { }

    public static Map<String,String> errorMap = new Map<String,String>();
    private static final Boolean DO_DEBUG = true;
    private static final String DFDemo_INSERT = 'insert';
    private static final String DFDemo_READ = 'read';
    private static final String DFDemo_UPDATE = 'update';
    private static final String DFDemo_DELETE = 'delete';
    private static Map<String, Map<String,Schema.SObjectField>> objectFieldMap = new Map<String, Map<String, Schema.SObjectField>>();
    private static Map<String, Map<String,Schema.RecordTypeInfo>> objectRecordTypeMap = new Map<String, Map<String,Schema.RecordTypeInfo>>();

    public static Map<String,String> objectErrorMap = new Map<String,String>();
    public static Map<String,List<String>> errorObjFieldList = new Map<String,List<String>>();

    private static void writeDebug(String msg){
        if(DO_DEBUG){
           System.debug('*** DFDemo_SecurityUtils DEBUG ***: '+msg);
        }
    }

    public static Schema.RecordTypeInfo getRecordTypeInfoByName(Schema.SObjectType objectType, String recordTypeName) {
        String objectName = objectType.getDescribe().getName();
        Map<String, Schema.RecordTypeInfo> recordTypeMap = objectRecordTypeMap.get(objectName);
        if (recordTypeMap == null) {
            recordTypeMap = populateObjectRecordTypeMap(objectType);
        }
        return recordTypeMap.get(recordTypeName);
    }

    public static Schema.RecordTypeInfo getRecordTypeInfoById(Schema.SObjectType objectType, Id recordTypeId) {
        String objectName = objectType.getDescribe().getName();
        Map<String, Schema.RecordTypeInfo> recordTypeMap = objectRecordTypeMap.get(objectName);
        if (recordTypeMap == null) {
            recordTypeMap = populateObjectRecordTypeMap(objectType);
        }
        return recordTypeMap.get(recordTypeId);
    }

    //we want to provide RT lookup by name and by ID (just like DescribeSObjectResult). Instead of keeping two maps
    // just store each RTInfo twice, by name and by id.
    private static Map<String, Schema.RecordTypeInfo> populateObjectRecordTypeMap(Schema.SObjectType objectType) {
        List<Schema.RecordTypeInfo> recordTypes = objectType.getDescribe().getRecordTypeInfos();
        Map<String, Schema.RecordTypeInfo> recordTypeMap = new Map<String, Schema.RecordTypeInfo>();
        for (Schema.RecordTypeInfo rt : recordTypes) {
            recordTypeMap.put(rt.getName(), rt);
            recordTypeMap.put((String)rt.getRecordTypeId(), rt);
            if(rt.isDefaultRecordTypeMapping()) { // allow checkIfRecordTypeIsAvailableByXXX(null) to check default RT
                recordTypeMap.put(null, rt);
            }
        }
        objectRecordTypeMap.put(objectType.getDescribe().getName(), recordTypeMap);
        return recordTypeMap;
    }

    public static boolean checkIfRecordTypeIsAvailableByName(Schema.SObjectType objectType, String recordTypeName) {
        Schema.RecordTypeInfo rtInfo = getRecordTypeInfoByName(objectType, recordTypeName);
        if (rtInfo == null) {
            throw new DFDemo_SecurityException( DFDemo_StringUtils.substitute(System.Label.DFDemo_No_Such_Recordtype, new List<String>{recordTypeName, objectType.getDescribe().getName()}) );
        }
        return rtInfo.isAvailable();
    }

    public static boolean checkIfRecordTypeIsAvailableById(Schema.SObjectType objectType, id recordTypeId) {
        Schema.RecordTypeInfo rtInfo = getRecordTypeInfoById(objectType, recordTypeId);
        if (rtInfo == null) {
            throw new DFDemo_SecurityException( DFDemo_StringUtils.substitute(System.Label.DFDemo_No_Such_Recordtype, new List<String>{recordTypeId, objectType.getDescribe().getName()}) );
        }
        return rtInfo.isAvailable();

    }

    public static Schema.DescribeFieldResult getFieldDescribe(Schema.SObjectType objectType, String fieldName)
    {
        String objectName = objectType.getDescribe().getName();
        Map<String, Schema.SObjectField> fieldMap = objectFieldMap.get(objectName);
        if (fieldMap == null)
        {
            writeDebug('Getting the field describe data for object - ' + objectName);
            fieldMap = objectType.getDescribe().fields.getMap();
            objectFieldMap.put(objectName, fieldMap);
        }
        Schema.SObjectField field = fieldMap.get(fieldName);
        if (field == null)
            throw new DFDemo_SecurityException(DFDemo_StringUtils.substitute(System.Label.DFDemo_Invalid_Field, fieldName));
        writeDebug('Getting the field describe data for field - ' + field);
        return field.getDescribe();
    }

    public static void generateErrorMap(String objectName,String checkType){
        if(!errorObjFieldList.isEmpty() && errorObjFieldList!= null){
            if(errorObjFieldList.get(objectName) != null){
                if(errorObjFieldList.get(objectName).isEmpty()){
                    objectErrorMap.put(objectName, DFDemo_StringUtils.substitute(System.Label.DFDemo_Object_Insufficient_Access_Privileges,
                        new String[]{checkType, objectName}));
                }else
                {
                    String errorFields = String.join(errorObjFieldList.get(objectName),',');
                    objectErrorMap.put(objectName, DFDemo_StringUtils.substitute(System.Label.DFDemo_Field_Insufficient_Access_Privileges,
                         new String[]{checkType, errorFields, objectName}));
                }
            }
        }
    }


    public static void checkIfFieldIsAccessible(String objectName,Schema.SObjectType objectType, String fieldName,boolean generateErrorMap){
         if(!getFieldDescribe(objectType, fieldName).isAccessible()){
             if(errorObjFieldList.get(objectName) == null) errorObjFieldList.put(objectName,new List<String>());
                        errorObjFieldList.get(objectName).add(fieldName);
         }
         if(generateErrorMap) generateErrorMap(objectName,DFDemo_READ);
    }

    public static void checkIfFieldIsCreateable(String objectName,Schema.SObjectType objectType, String fieldName,boolean generateErrorMap){
         if(!getFieldDescribe(objectType, fieldName).isCreateable()){
             if(errorObjFieldList.get(objectName) == null) errorObjFieldList.put(objectName,new List<String>());
                        errorObjFieldList.get(objectName).add(fieldName);
         }
         if(generateErrorMap) generateErrorMap(objectName,DFDemo_INSERT);
    }

    public static void checkIfFieldIsUpdateable(String objectName,Schema.SObjectType objectType, String fieldName,boolean generateErrorMap){
         if(!getFieldDescribe(objectType, fieldName).isUpdateable()){
             if(errorObjFieldList.get(objectName) == null) errorObjFieldList.put(objectName,new List<String>());
                        errorObjFieldList.get(objectName).add(fieldName);
         }
         if(generateErrorMap) generateErrorMap(objectName,DFDemo_UPDATE);
    }

    public static void checkIfObjectIsAccessible(String objectName, Schema.SObjectType objectType, boolean generateErrorMap){
        if (!objectType.getDescribe().isAccessible()){
            if(errorObjFieldList.get(objectName) == null) errorObjFieldList.put(objectName,new List<String>());
        }
        if(generateErrorMap) generateErrorMap(objectName,DFDemo_READ);
    }

    public static void checkIfObjectIsCreateable(String objectName, Schema.SObjectType objectType, boolean generateErrorMap){
        if(!objectType.getDescribe().isCreateable()){
            if(errorObjFieldList.get(objectName) == null) errorObjFieldList.put(objectName,new List<String>());
        }
        if(generateErrorMap) generateErrorMap(objectName,DFDemo_INSERT);
    }


    public static void checkIfObjectIsUpdateable(String objectName, Schema.SObjectType objectType, boolean generateErrorMap){
        if(!objectType.getDescribe().isUpdateable()){
            if(errorObjFieldList.get(objectName) == null) errorObjFieldList.put(objectName,new List<String>());
        }
        if(generateErrorMap) generateErrorMap(objectName,DFDemo_UPDATE);
    }

    public static void checkIfObjectIsDeletable(String objectName, Schema.SObjectType objectType, boolean generateErrorMap){
        if(!objectType.getDescribe().isDeletable()){
            if(errorObjFieldList.get(objectName) == null) errorObjFieldList.put(objectName,new List<String>());
        }
        if(generateErrorMap) generateErrorMap(objectName,DFDemo_DELETE);
    }


    public static void checkRead(Schema.SObjectType objectType, List<String> fieldNames){
        String objectName = objectType.getDescribe().getName();
        checkIfObjectIsAccessible(objectName, objectType, FALSE);
        if(!errorObjFieldList.containsKey(objectName)){
            for (String fieldName : fieldNames)
            {
                checkIfFieldIsAccessible(objectName, objectType, fieldName, FALSE);
            }
        }
        generateErrorMap(objectName, DFDemo_READ);
    }

    public static void checkCreate(Schema.SObjectType objectType, List<String> fieldNames){
        String objectName = objectType.getDescribe().getName();
        checkIfObjectIsCreateable(objectName, objectType, FALSE);
        if(!errorObjFieldList.containsKey(objectName)){
            for (String fieldName : fieldNames)
            {
                checkIfFieldIsCreateable(objectName, objectType, fieldName, FALSE);
            }
        }
        generateErrorMap(objectName, DFDemo_INSERT);
    }


    public static void checkUpdate(Schema.SObjectType objectType, List<String> fieldNames){
        String objectName = objectType.getDescribe().getName();
        checkIfObjectIsUpdateable(objectName, objectType, FALSE);
        if(!errorObjFieldList.containsKey(objectName)){
            for (String fieldName : fieldNames)
            {
                checkIfFieldIsUpdateable(objectName, objectType, fieldName, FALSE);
            }
        }
        generateErrorMap(objectName, DFDemo_UPDATE);
    }

    public static void checkDelete(Schema.SObjectType objectType, List<String> fieldNames)
    {
        String objectName = objectType.getDescribe().getName();
        checkIfObjectIsDeletable(objectName, objectType, FALSE);
        generateErrorMap(objectName, DFDemo_DELETE);
    }

    //convenience functions
    //Note that objectErrorMap.containsKey(sObject) is true if sObject had CRUD or FLS errors.
    //However, if sObject has a CRUD error, FLS won't even be checked.
    //In that case, errorObjFieldList will be an empty List<String>.
    //If CRUD was okay but there was an FLS error, errorObjFieldList will be populated

    //object has CRUD error?
    public static boolean hasObjectError(String objName) {
        return (DFDemo_SecurityUtils.objectErrorMap.containsKey(objName) && DFDemo_SecurityUtils.errorObjFieldList.get(objName).size() == 0);
    }

    //field has FLS error?
    public static boolean hasFieldError(String objName, String fieldName) {
        if (DFDemo_SecurityUtils.objectErrorMap.containsKey(objName)) {
           Set<string> errorFields = new Set<string>(DFDemo_SecurityUtils.errorObjFieldList.get(objName));
           return errorFields.contains(fieldName);
        }
        return false;
    }
}