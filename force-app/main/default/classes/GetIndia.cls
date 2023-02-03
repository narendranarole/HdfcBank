global class GetIndia {

    global static void getData(){
        HTTPRequest request = new HTTPRequest();
        request.setEndpoint('callout:PanIndiaNameCred/services/apexrest/v1/getAccountDetails'); //callout:NamedCredentials+Path
        request.setMethod('GET');
        
        Http http = new Http();
        HTTPResponse response = http.send(request);
        
        System.debug('Response = '+response.getBody());
        
        List<Object> jsonResponse = (List<Object>) JSON.deserializeUntyped(response.getBody());
       
        for(Object objO : jsonResponse){
            System.debug('Record = '+objO);	
        }

    }
}