public class ManageOrgController {

  public String selectedOrg {get;set;}
  public String selectedCustObject {get;set;}
  public static String orgconnectionStatus {get;set;}
  public static String ACCESS_TOKEN ;
  public static String EndURL;

  public ManageOrgController(){
     orgconnectionStatus='Not-Connected'; 
   }
   
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
  /*
  public String ReturnAccessToken(){
    
    string clientId = '3MVG9Y6d_Btp4xp7fR8ZuNc5hFIn8OGf3oTSilSM1AS5FF5uee9eKpDN4wlzK3skCi1MqDtzhgS3gXEkqxSbi';
    string clientSecret = '786299176795951784';
    
    string username = 'singhamar01@gmail.com';
    string password = 'amar_1991478';
    
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
    return resp1.access_token;

   }*/
   
   public String getConnectionStatus(){
        System.debug('selected OrgName:: '+selectedOrg);
        return orgconnectionStatus;
    }
    
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
   
}