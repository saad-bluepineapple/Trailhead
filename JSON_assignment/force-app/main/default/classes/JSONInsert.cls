public class JSONInsert {
    
    public static TestContact1__c test(Map<String, Object> userObject){
        TestContact1__c contact = new TestContact1__c();
        System.debug('in JSONInsert');
       
        System.debug('length:' + userObject.size());
        
        for(String key: userObject.keySet() ){
            String key1 ='contact.'+ key + '__c';
            
            //if the value for that key is null, append "" so that it is considered as a string.
            if(userObject.get(key) == null){
                String value = '"' +userObject.get(key)+'"';
                System.debug('value:'+value);
                userObject.put(key,value);
            }
            
            //if the value of the key is a boolean,
            //change the data type to boolean while inserting the record.
            else if(userObject.get(key) == true || userObject.get(key) == false ){
                 contact.put(key1,(Boolean)userObject.get(key));
            }  
            	
            //if the value of the key is a userId/ registrationMemberId,
            //change the data type to Integer while inserting the record.
            else if(key == 'userId' || key == 'registrationMemberId'){
            	contact.put(key1,(Integer)userObject.get(key));
            }
			
            else if(key == 'firstName'){
                key1 = 'Name';
            	contact.put(key1,(String)userObject.get(key));
            }
            
            //if the value of the key is a other thant the above ones,
            //insert the record.
            else{
                contact.put(key1,(String)userObject.get(key));
            }
        }
                
        //1.
        try{
            insert contact;
            System.debug('record Inserted');
        }catch(Exception e){
            System.debug('error:'+ e);
        }
        
        return contact;
        
    

}
}
    
    /*1. for(String key: userObject.keySet() ){
            
            contact.userId__c = (Integer)userObject.get('userId');
            contact.onboardingStage__c = (String)userObject.get('onboardingStage');
            contact.registrationMemberId__c = (Integer)userObject.get('registrationMemberId');
            contact.Name = (String)userObject.get('firstName');
            contact.familyName__c = (String)userObject.get('familyName');
            contact.gender__c = (String)userObject.get('gender');
            contact.address__c= (String)userObject.get('address');
            contact.email__c = (String)userObject.get('email');
           // System.debug(key + '->' + userObject.get(key));
        }     
        */