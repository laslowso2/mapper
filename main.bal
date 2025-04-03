import ballerina/http;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /convert on httpDefaultListener {
    resource function get greeting() returns error|json|http:InternalServerError {
        do {
            return "Hello, Greetings!";
        } on fail error err {
            // handle error
            return error("Not implemented", err);
        }
    }

    resource function post mrf(@http:Payload json input) returns error|string {
        do {

 json mrf = <json>input;
        //r4:Bundle fhirBundle = check fhirParser:parse(mrf).ensureType();    


        //MRFBase|error parsedJson = input.cloneWithType(MRFBase);

        //if mrf is MRFBase {
        string csvData = "Billing Code, Billing Type, Provider NPI, Billed Charge, Allowed Amount, Billing Class, TIN Value\n"; // CSV Header

            // Iterate over OutOfNetwork records
            foreach var billingCode in mrf.out_of_network {
                string billingCodeValue = billingCode.billing_code;
                string billingType = billingCode.billing_code_type;

                // Iterate over allowed amounts
                foreach var allowedAmount in billingCode.allowed_amounts {
                    string tinValue = allowedAmount.tin.value;
                    string billingClass = allowedAmount.billing_class;

                    // Iterate over payments
                    foreach var payment in allowedAmount.payments {
                        decimal allowedAmt = payment.allowed_amount;

                        // Iterate over providers
                        foreach var provider in payment.providers {
                            string npis = provider.npi.join(","); // Join multiple NPIs with a comma
                            csvData += string `${billingCodeValue}, ${billingType}, ${npis}, ${provider.billed_charge}, ${allowedAmt}, ${billingClass}, ${tinValue}\n`;
                        }
                    }
                }
                
            }

            return csvData; // Return CSV as response
       // } else {
       //     return error("Invalid JSON format. Expected MRFBase structure.");
       // }
        } on fail error err {
            // handle error
            return error("Not implemented", err);
        }
    }
}
