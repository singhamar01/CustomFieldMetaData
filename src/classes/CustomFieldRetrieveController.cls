/*************************************************************
** Name : CustomFieldRetrieveController
** Purpose: to fetch list of customField for selected Object
** Change Description:
** Date 07/27/16  -- Added logic of ManageOrgController to remove this controller.
*************************************************************/
public without sharing class CustomFieldRetrieveController {
    
     public String selectedObject {get;set;}
     public String selectedOrg    {get;set;}
     public String mdataCount     {get;set;}
     
     //------------------------------------------//
      //public String selectedOrg {get;set;}
      public String selectedCustObject {get;set;}
      public String selectedMetadata {get;set;}
      public String orgconnectionStatus {get;set;}
      public String ACCESS_TOKEN ;
      public String EndURL;
      public String Instance_url;
     //------------------------------------------//
     
     public List<String> fieldNames;
     public List<fieldNameWrapper> fieldNameWrap;
     public Map<String,String> fieldHelpTextMap {get;set;}
     
     public Integer customFieldCount {
        get{
            if(fieldNameWrap != null){
                return fieldNameWrap.size();
            }
            else    
                return null;
        } private set;
    }
     
     Map<String, Schema.SObjectType> gd;
     public CustomFieldRetrieveController (){
        gd = Schema.getGlobalDescribe();//getting list of objects from schema
        System.debug('selectedObject$$'+selectedObject);
        orgconnectionStatus='Not-Connected';
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
    public String xlsHeader {
        get {
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
    
    public PageReference download(){
        return Page.CustomFieldDownload;
        //return null;
    }
    
    public void ConnectToOrg(){
        
        System.debug('selected OrgName:: '+selectedOrg);
        
        string clientId = '';
        string clientSecret = '';
        
        string username = '';
        string password = '';
        
        List<MyDeveloperOrgs__c> mydevOrgs = MyDeveloperOrgs__c.getall().values();
        System.debug('mydevOrgs'+mydevOrgs);
        for(MyDeveloperOrgs__c org :mydevOrgs){
            
          if(org.username__c==selectedOrg){
              clientId = org.clientId__c;
              clientSecret = org.clientSecret__c;
              username = org.username__c;
              password = org.password__c;
          }
        }
        
        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        HttpResponse res = h.send(req);
        System.debug('res::'+res.getBody());
        JSONReturnAccessToken resp1 = (JSONReturnAccessToken)JSON.deserialize(res.getbody(),JSONReturnAccessToken.class);
        System.debug('AccessToken:: '+resp1.access_token);
        System.debug('Instance_url :: '+resp1.instance_url);
        
        if(resp1.access_token!=null){
          orgconnectionStatus = 'Connected';
          ACCESS_TOKEN = resp1.access_token;
          Instance_url = resp1.instance_url;
          EndURL = resp1.instance_url+'/services/data/v37.0/tooling/query/?q=Select+DeveloperName+from+CustomObject';
        }else {
            orgconnectionStatus = 'Connection Error';
         } 
        
        
    }
    
    //---------------------------------------//
      public List<SelectOption> getMyOrgList(){
        List<SelectOption> orgList = new List<SelectOption>();
        //orgList.add(new SelectOption('orgURL1','singhamar01@gmail.com'));
        //orgList.add(new SelectOption('orgURL2','me_amar01@yahoo.com.docusign'));
        List<MyDeveloperOrgs__c> mydevOrgs = MyDeveloperOrgs__c.getall().values();
        for(MyDeveloperOrgs__c org :mydevOrgs){
            orgList.add(new SelectOption(org.username__c,org.username__c));
        }
        System.debug('orgList$$'+orgList);
        return orgList;
    }

   //--------------------------------------------------------//
     public String getConnectionStatus(){
        System.debug('selected OrgName:: '+selectedOrg);
        return orgconnectionStatus;
    }
   //--------------------------------------------------//
      public List<SelectOption> getCustomObjectList(){
       
       if(orgconnectionStatus=='Connected'){
           List<SelectOption> customObjectList = new List<SelectOption>();   
           
           HttpRequest req = new HttpRequest();
           req.setHeader('Content-type', 'application/json');
           req.setHeader('Authorization', 'Bearer ' + ACCESS_TOKEN);
           
           req.setEndpoint(EndURL); 
           req.setMethod('GET');
           Http http = new Http();
           HttpResponse res = http.send(req);
           System.debug('result CustomObject:: '+res.getBody());   

           JSONReturnCustomObject deserCustObj = (JSONReturnCustomObject)JSON.deserialize(res.getbody(),JSONReturnCustomObject.class);
           System.debug('entityTypeName:: '+deserCustObj.entityTypeName);
           System.debug('DeveloperName:: '+deserCustObj.records[0].DeveloperName);
           
           for(JSONReturnCustomObject.JSONRecords option : deserCustObj.records){
               customObjectList.add(new SelectOption(option.DeveloperName,option.DeveloperName));
           }
               
           System.debug('customObjectList:: '+customObjectList);
           
           return customObjectList;
      }else{
          return null;
      }
     
    }
    
     //---------------------------------------------//
     public List<SelectOption> getMetaDataList(){
        List<SelectOption> mdataList = new List<SelectOption>();
      
        mdataList.add(new SelectOption('ApexClass','Apex Classes'));
        mdataList.add(new SelectOption('Trigger','Trigger'));
        mdataList.add(new SelectOption('VisualforcePage','Visualforce Page'));
        mdataList.add(new SelectOption('VisualforceComponent','Visualforce Component'));
        mdataList.add(new SelectOption('CustomObject','Custom Object'));
        mdataList.add(new SelectOption('EmailTemplate','Email Template'));
        mdataList.add(new SelectOption('StaticResource','Static Resource'));
        mdataList.add(new SelectOption('WorkflowRule','Workflow Rule'));
        mdataList.add(new SelectOption('ValidationRule','Validation Rule'));
       
        System.debug('mdataList$$'+mdataList);
        return mdataList;
    }
 
   //---------------------------------------------//
     public void FetchSelectedMdata(){
         
       try{
           String tEndURL;
           if(selectedMetadata=='CustomObject'){
              tEndURL = Instance_url+'/services/data/v37.0/tooling/query/?q=Select+Id,DeveloperName+from+CustomObject'; 
           }
           else if(selectedMetadata=='ApexClass'){
              tEndURL = Instance_url+'/services/data/v37.0/tooling/query/?q=Select+Id,Name+from+ApexClass';
           }
           else if(selectedMetadata=='VisualforcePage'){
               tEndURL = Instance_url+'/services/data/v37.0/tooling/query/?q=Select+Id,Name+from+ApexPage';
           }
           else if(selectedMetadata=='VisualforceComponent'){
               tEndURL = Instance_url+'/services/data/v37.0/tooling/query/?q=Select+Id,Name+from+ApexComponent';
           }
           else if(selectedMetadata=='Trigger'){
               tEndURL = Instance_url+'/services/data/v37.0/tooling/query/?q=Select+Id,Name+from+ApexTrigger';
           }
           else if(selectedMetadata=='EmailTemplate'){
               tEndURL = Instance_url+'/services/data/v37.0/tooling/query/?q=Select+Id,Name+from+EmailTemplate';
           }
           else if(selectedMetadata=='StaticResource'){
               tEndURL = Instance_url+'/services/data/v37.0/tooling/query/?q=Select+Id,Name+from+StaticResource';
           }
           else if(selectedMetadata=='WorkflowRule'){
               tEndURL = Instance_url+'/services/data/v37.0/tooling/query/?q=Select+Id,Name+from+WorkflowRule';
           }
           else if(selectedMetadata=='ValidationRule'){
               tEndURL = Instance_url+'/services/data/v37.0/tooling/query/?q=Select+Id,ValidationName+from+ValidationRule';
           }
       
           System.debug('tEndURL:: '+tEndURL);
           
           HttpRequest req = new HttpRequest();
           req.setHeader('Content-type', 'application/json');
           req.setHeader('Authorization', 'Bearer ' + ACCESS_TOKEN);
           
           req.setEndpoint(tEndURL); 
           req.setMethod('GET');
           Http http = new Http();
           HttpResponse res = http.send(req);
           System.debug('result selectedMetadata:: '+res.getBody()); 
           
           JSONReturnMetadata deserializeMdata = (JSONReturnMetadata)JSON.deserialize(res.getbody(),JSONReturnMetadata.class);
           
           mdataCount = deserializeMdata.entityTypeName + ' - ' +  deserializeMdata.records.size();    
           System.debug('mdataCount'+mdataCount);
       
           
       }catch(Exception e){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Exception Occured while fetching metadata.'));
           system.debug('<--------Metadata Exception------->' + e.getmessage()); 
       }
         
    }   
    
    

}