/*************************************************************
** Name : CustomFieldRetrieveController
** Purpose: to fetch list of customField for selected Object
*************************************************************/
public without sharing class CustomFieldRetrieveController {
    
     public String selectedObject {get;set;}
     
     
     public List<String> fieldNames;
     public List<fieldNameWrapper> fieldNameWrap;
     public Map<String,String> fieldHelpTextMap {get;set;}
     
     Map<String, Schema.SObjectType> gd;
     public CustomFieldRetrieveController (){
        gd = Schema.getGlobalDescribe();//getting list of objects from schema
        System.debug('selectedObject$$'+selectedObject);
     }
     
    public List<SelectOption> getObjectList(){
        List<SelectOption> objectList = new List<SelectOption>();
        
        //iterating map to generate object list
        for(String objectName : gd.keyset()){
            Schema.DescribeSObjectResult describeSObjectResultObj = gd.get(objectName).getDescribe();
            if(describeSObjectResultObj.isCustom())
                objectList.add(new SelectOption(objectName,describeSObjectResultObj.getLabel()));
        }
        doSort(objectList,FieldToSort.Label);
        selectedObject = objectList[0].getValue();
        System.debug('objectList$$'+objectList[0].getValue());
        return objectList;
    }
    
        public enum FieldToSort {
        Label, Value
    }
    private void doSort(List<Selectoption> optionList,FieldToSort sortField) {        
        Map<String, Selectoption> mapping = new Map<String, Selectoption>();
        // Suffix to avoid duplicate values like same labels or values are in inbound list 
        Integer suffix = 1;
        for (Selectoption opt : optionList) {
            if (sortField == FieldToSort.Label) {
                mapping.put(    // Done this cryptic to save scriptlines, if this loop executes 10000 times
                                // it would every script statement would add 1, so 3 would lead to 30000.
                             (opt.getLabel() + suffix++), // Key using Label + Suffix Counter  
                             opt);   
            } else {
                mapping.put(    
                             (opt.getValue() + suffix++), // Key using Label + Suffix Counter  
                             opt);   
            }
        }
        
        List<String> sortKeys = new List<String>();
        sortKeys.addAll(mapping.keySet());
        sortKeys.sort();
        // clear the original collection to rebuilt it
        optionList.clear();
        
        for (String key : sortKeys) {
            optionList.add(mapping.get(key));
        }
    }
    
    public List<String> getFieldNames(){
        System.debug('selectedObject$$'+selectedObject);
        fieldNames = new List<String>();
        fieldNameWrap = new List<fieldNameWrapper>();
        fieldHelpTextMap = new Map<String,String>();
        Schema.DescribeSObjectResult describeSObjectResultObj = gd.get(selectedObject).getDescribe();
        Map<String, Schema.SObjectField> fieldMap = describeSObjectResultObj.fields.getMap();
        for(Schema.SObjectField Sfield : fieldMap.values()){
            if(Sfield.getDescribe().isCustom()){
                fieldNameWrapper tempObj = new fieldNameWrapper();
                tempObj.labelName = Sfield.getDescribe().getLabel();
                tempObj.apiName = Sfield.getDescribe().getName();
                tempObj.dataType = Sfield.getDescribe().getType();
                fieldNameWrap.add(tempObj);
                fieldNames.add(Sfield.getDescribe().getName());
                String helpText = (Sfield.getDescribe().getInlineHelpText() != null? Sfield.getDescribe().getInlineHelpText():'' );
                fieldHelpTextMap.put(Sfield.getDescribe().getName(),helpText);
            }
        }
        System.debug('test'+fieldNames);
        return fieldNames;         
    }
    
    public List<fieldNameWrapper> getFieldNameWrap(){
    System.debug('selectedObject$$'+selectedObject);
    fieldNames = new List<String>();
    fieldNameWrap = new List<fieldNameWrapper>();
    fieldHelpTextMap = new Map<String,String>();
    Schema.DescribeSObjectResult describeSObjectResultObj = gd.get(selectedObject).getDescribe();
    Map<String, Schema.SObjectField> fieldMap = describeSObjectResultObj.fields.getMap();
    for(Schema.SObjectField Sfield : fieldMap.values()){
        if(Sfield.getDescribe().isCustom()){
            fieldNameWrapper tempObj = new fieldNameWrapper();
            tempObj.labelName = Sfield.getDescribe().getLabel();
            tempObj.apiName = Sfield.getDescribe().getName();
            tempObj.dataType = Sfield.getDescribe().getType();
            fieldNameWrap.add(tempObj);
            fieldNames.add(Sfield.getDescribe().getName());
            String helpText = (Sfield.getDescribe().getInlineHelpText() != null? Sfield.getDescribe().getInlineHelpText():'' );
            fieldHelpTextMap.put(Sfield.getDescribe().getName(),helpText);
        }
    }
    System.debug('test'+fieldNames);
    return fieldNameWrap;         
    }
    
    public class fieldNameWrapper{
        public string labelName {get;set;}
        public string apiName {get;set;}
        public Schema.DisplayType dataType {get;set;}
    }

}
