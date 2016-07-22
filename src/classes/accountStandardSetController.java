public class accountStandardSetController {

   public ApexPages.StandardSetController acctSetController {get;set;}

    public accountStandardSetController(ApexPages.StandardSetController controller) {

       acctSetController = controller;
       acctSetController.setPageSize(2000); 
    }
    
    public Integer getPageNumber(){
      
      Integer num;
      
      num = acctSetController.getPageNumber(); 
      
      return num;
      
    }
    
    public Integer getTotalPageNumber(){
    
      Integer num;
      
      num = acctSetController.getResultSize()/acctSetController.getPageSize(); 
      
      return num;
    
    }

}