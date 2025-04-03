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
            if input is json {
                // Check if the input JSON is empty
                if input.toString().trim() == "{}" {
                    return error("Input JSON is empty");
                }
            }
           
        MRFBase parsedJson =check input.cloneWithType();

        if parsedJson is MRFBase {
        string csvData = "TIN Value, Provider NPI, Billing Class, Billing Code, Billing Type, Billed Charge, Allowed Amount, Description, Name      \n"; // CSV Header

            // Iterate over OutOfNetwork records
            foreach var oon in parsedJson.out_of_network {
                string billingCodeValue = oon.billing_code;
                string billingType = oon.billing_code_type;

                // Iterate over allowed amounts
                foreach var allowedAmount in oon.allowed_amounts {
                    string tinValue = allowedAmount.tin.value;
                    string billingClass = allowedAmount.billing_class;

                    // Iterate over payments
                    foreach var payment in allowedAmount.payments {
                        decimal allowedAmt = payment.allowed_amount;

                        // Iterate over providers
                        foreach var provider in payment.providers {
                            string npis = provider.npi.toString(); // Join multiple NPIs with a comma
                            csvData += string `${tinValue}, ${npis}, ${billingClass}, ${billingCodeValue}, ${billingType}, ${provider.billed_charge}, ${allowedAmt}, ${oon.description}, ${oon.name}    ` + "\n";
                        }
                    }
                }
                
            }
            return csvData; // Return CSV as response
        }
        } on fail error err {
            // handle error
            return error("Not implemented", err);
        }
    }
}
