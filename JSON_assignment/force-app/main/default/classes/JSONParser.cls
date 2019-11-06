public class JSONParser {
    
    public static string jsonString = '{    "success": true,    "error": null,    "data": {        "userInfoRecords": [          {"userId":55, "firstName": "Saad", "familyName":"Ahmed","registrationMemberId":123333,"onboardingStage":"COMPLETED"},  {                "userId": 93,                "onboardingStage": "COMPLETED",                "registrationMemberId": 150214,                "firstName": "John",                "familyName": "Doe",                "email": "saad.ahmed@testmail.com",                "address": "Unit 52  Askern Industrial Estate Moss Road Doncaster South Yorkshire DN6 0DD United Kingdom",                "gender": "M",                "dateOfBirth": "1982-10-10",                "tfnVerificationStatus":true,                "investmentStrategy": "BALANCED",                "investmentStrategyChangeInProgress": true,                "roundupActive": false,                "roundupAmountCap": null,                "topupActive": null,                "topupAmount": null,                "isInsuranceOpted": true,                "claimTaxBack": null,                "directDebitPermission": null,                "productDisclosureReadStatements": true,                "productDisclosureTfnUsePermission": true,                "productDisclosureCanSendEmails": true,                "beneficiary1": null,                "beneficiary2": null,                "beneficiary3": null,                "beneficiary4": null,                "beneficiary5": null,                "createdOn": "2019-10-22T06:30:27.989Z",                "lastModifiedOn": "2019-10-22T06:31:58.364Z"            }, {                "userId": 99,                "onboardingStage": "COMPLETED",                "registrationMemberId": 150217,                "firstName": "Jane",                "familyName": "Smith",                "email": "test@99.com",                "address": "Unit 54  Askern Industrial Estate Moss Road Doncaster South Yorkshire DN6 0DD United Kingdom",                "gender": "F",                "dateOfBirth": "1987-11-11",                "tfnVerificationStatus": true,                "investmentStrategy": "BALANCED",                "investmentStrategyChangeInProgress": true,                "roundupActive": false,                "roundupAmountCap": null,                "topupActive": null,                "topupAmount": null,                "isInsuranceOpted": true,                "claimTaxBack": null,                "directDebitPermission": null,                "productDisclosureReadStatements": true,                "productDisclosureTfnUsePermission": true,                "productDisclosureCanSendEmails": true,                "beneficiary1": null,                "beneficiary2": null,                "beneficiary3": null,                "beneficiary4": null,                "beneficiary5": null,                "createdOn": "2019-10-22T06:30:27.989Z",                "lastModifiedOn": "2019-10-22T06:31:58.364Z"            }        ]    }   }';
    public static void parseResponse() {
         
        //List object to preform bulk DML.
        List<Contact> contactList = new List<Contact>(); 
        
        //deserializing the input string	
        Map<String, Object> mapObject = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        
        //fetching the data part.   
        Map<String, Object> dataMap = (Map<String, Object>)mapObject.get('data');
        
        //fetching the userInfoRecord part in List format.
        List<Object> dataList = (List<Object>)dataMap.get('userInfoRecords');
        
        
        for(Object key: dataList){
            
            //new contact object to insert the data into.
            Contact con = new Contact();
            
            //converting the key in the dataList in Map's key-value pair. 
            Map<String, Object> data = (Map<String, Object>)key;
            
            for(String x : data.keySet()){ 

                    //traverse the keys and insert them in their respective fields.
                    
                    //append '__c' in the required fields except (key != 'dateOfBirth' || key != 'firstName' || key != 'email').
                    if((x != 'dateOfBirth') || (x != 'firstName') || (x == 'email')){
                        
                        //if the 
                        if(x == 'userId' || x == 'registrationMemberId'){
                            con.put(x+'__c',(Integer)data.get(x));
                        }
                        
                        //
                        else if(x == 'lastModifiedOn' || x == 'createdOn'){
                            Datetime dt = DateTime.parse((String)data.get(x));
                            String myDtString = dt.format();
                            con.put(x+'__c',myDtString);
                        }
                        else if(x == 'email'){
                            con.put('Email',data.get(x));
                        }
                        else if(x == 'dateOfBirth'){
                            Date dt = date.valueOf((String)data.get(x));
							//String formattedDate = dt.format('DD-MM-YYYY');

                            con.put('Birthdate',dt);//date.parse((String)data.get(x)));
                        }
                        
                        //
                        else{
                            con.put(x+'__c',data.get(x));
                        }
            		}
                    else{
                        if(x == 'firstName'){
                            con.put('Name',data.get(x));
                        }
                        
                        
                    }

                //adding the data into the contactList Object.
               	contactList.add(con);
        	}
		}
        
        try{
        	upsert contactList;
            System.debug(contactList.size() +' Records inserted successfully!');
        }catch(Exception e){
            System.debug('Err: '+ e);
        }
        
	}
}