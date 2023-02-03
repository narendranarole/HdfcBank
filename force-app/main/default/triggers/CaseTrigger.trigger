trigger CaseTrigger on Case (after insert,after update) {
    
    String profileName = [select id, Name from Profile where Id = : UserInfo.getProfileId()].Name;
    
    if(profileName == 'System Administrator'){
        
        if(trigger.isInsert && trigger.isAfter){
            CaseTriggerHandler.creatNonconforanceRecord(trigger.new,null);
        }
        
        if(trigger.isUpdate && trigger.isAfter){
            CaseTriggerHandler.creatNonconforanceRecord(trigger.new, trigger.oldMap);
        }
        
    }
}