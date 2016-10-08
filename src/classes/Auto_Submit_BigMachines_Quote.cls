global class Auto_Submit_BigMachines_Quote implements Database.batchable<sObject> {
  
  public String query = 'SELECT Id,Name,LX_Auto_Approve__c,Bid_Price_Change_flag__c,BigMachines__Status__c FROM BigMachines__Quote__c WHERE LX_Auto_Approve__c=true AND Bid_Price_Change_flag__c = true AND (BigMachines__Status__c = \'Pending\' OR BigMachines__Status__c = \'Revision Pending\')';
   
  global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
   
    List<String> lstQuoteId;
    List<Approval.ProcessSubmitRequest> reqList = new List<Approval.ProcessSubmitRequest>();
    
    for(sObject s : scope){
        
        BigMachines__Quote__c bmQuote = (BigMachines__Quote__c)s;
       
        Approval.ProcessSubmitRequest reqObj = new Approval.ProcessSubmitRequest();
        reqObj.setObjectId(bmQuote.Id);
        reqList.add(reqObj);
        
     }
     
     List<Approval.ProcessResult> result = Approval.process(reqList);
     
   }

   global void finish(Database.BatchableContext BC){
   
   }


}
