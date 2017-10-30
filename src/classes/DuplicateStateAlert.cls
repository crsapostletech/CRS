/*************************************************************************************************************
Created by: Apostletech team
Purpose: When a new record is being created or update with duplicate need to alert with error message
Class calling from a ResetOwnerAssignment trigger to alert 
*************************************************************************************************************/

public class DuplicateStateAlert{

    public static void duplicateAlert(List<Owner_Territory__c> territoryRecords){
        
        List<String> statecodes = new List<String>();
        for(Owner_Territory__c ot : territoryRecords){
            if(ot.States__c <> null && ot.States__c <> ''){
                 
                 List<String> states = ot.States__c.split(';');
                 Set<String> stateTerritorycodes = new Set<String>();
                 stateTerritorycodes.addAll(states);
                 for(String S : stateTerritorycodes){
                     statecodes.add('\''+S+'\'');
                 } 
            }
        }
        
        String queryString = 'select id, States__c, Owner_Assignment__c from Owner_Territory__c where States__c includes(';
            for(String stateValue :statecodes){
                queryString += stateValue + ',';
            }    
            queryString = queryString.removeEnd(',') +')';
            List<Owner_Territory__c> aList = new List<Owner_Territory__c>();
            if(!statecodes.isEmpty()){
                aList = (List<Owner_Territory__c>)Database.query(queryString);
            }
            
            
            String errorMessage = '';
            for(Owner_Territory__c ot : territoryRecords){
                for(Owner_Territory__c o : aList){
                    
                    List<String> states = o.States__c.split(';');
                    Set<String> stateTerritorycodes = new Set<String>();
                    stateTerritorycodes.addAll(states);
                    System.debug('****oldState****'+stateTerritorycodes);
                    
                    List<String> newstates = ot.States__c.split(';');
                    Set<String> stateTercodes = new Set<String>();
                    stateTercodes.addAll(newstates);                    
                    
                    System.debug('****new State****'+stateTercodes);
                    for(String s : stateTercodes){
                        System.debug(stateTerritorycodes+'***Hello***'+s + '///////// '+stateTerritorycodes.contains(s));
                        if(ot.id <> o.id && ot.Owner_Assignment__c == o.Owner_Assignment__c && stateTerritorycodes.contains(s) ){
                             System.debug('****Hello****');
                              //errorMessage = errorMessage + +s+' \n ';
                              ot.addError('Duplicate State Assigned to another Owner Territory', false);
                        }
                    }
                }
               
            }
            
    }
}