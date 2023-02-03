public class CaseTriggerHandler {

    
    public static void creatNonconforanceRecord(List<Case> caseNewList, Map<Id,Case> caseOldMap){
       
        Set<Id> caseIdSet = new Set<Id>();
        List<SQX_Nonconformance__c> sqxNonConfList = new List<SQX_Nonconformance__c>();
         boolean createChildFlag =false;
        
        if(!caseNewList.isEmpty()){
            for(Case objCase : caseNewList){
                if(objCase.Type =='Problem')
                	caseIdSet.add(objCase.Id);
            }
        }
        
        Map<Id,Case> caseMap = new Map<Id,Case>();
        
        if(!caseIdSet.isEmpty()){
            for(Case objCase : [select id,Type, (select Id from Nonconformances__r) from Case where Id IN : caseIdSet]){
                caseMap.put(objCase.Id,objCase);
            }
        }
        
        if(!caseMap.isEmpty()){
            for(Case objCase : caseNewList){
                if(caseMap.containsKey(objCase.Id)){
                    if(caseMap.get(objCase.Id).Nonconformances__r.size() == 0){
                        SQX_Nonconformance__c objSQXNonConf = new SQX_Nonconformance__c();
                        objSQXNonConf.SQX_NC_Reference__c 	  = objCase.Id;
                        objSQXNonConf.Priority__c 		  	  = objCase.Priority;
                        objSQXNonConf.Title__c 			  	  = objCase.Subject;
                        objSQXNonConf.Description__c 	  	  = objCase.Description;
                        objSQXNonConf.QMS_Reference_Number__c = objCase.CaseNumber;
                        createChildFlag = true;
                        
                        sqxNonConfList.add(objSQXNonConf);    
                    }
                    if(caseOldMap!=null && caseMap.get(objCase.Id).Nonconformances__r.size()!=0){ //update
                        SQX_Nonconformance__c objSQXNonConf = new SQX_Nonconformance__c();
                        objSQXNonConf.Id	  = caseMap.get(objCase.Id).Nonconformances__r[0].Id;
                        objSQXNonConf.Priority__c 		  	  = objCase.Priority;
                        objSQXNonConf.Title__c 			  	  = objCase.Subject;
                        objSQXNonConf.Description__c 	  	  = objCase.Description;
                        objSQXNonConf.QMS_Reference_Number__c = objCase.CaseNumber;
                        
                        sqxNonConfList.add(objSQXNonConf);    
                    }
                    
                    
                }
            }
        }
        
        if(!sqxNonConfList.isEmpty()){
            if(caseOldMap == null || createChildFlag){//Insert
            	Database.insert(sqxNonConfList,false);
            }
            else{ //Update
                Database.update(sqxNonConfList,false);
            }
        }
        
        
    }
}