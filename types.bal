
type Providers record {|
    decimal billed_charge;
    string[] npi;
|};

type Payments record {|
    decimal allowed_amount;
    Providers[] providers;
|};

type Tin record {|
    string 'type;
    string value;
|};

type AllowedAmounts record {|
    Tin tin;
    string billing_class;
    Payments[] payments;
    string[] service_code?;
|};


type OutOfNetwork record {|
   string name;
    string billing_code_type;
    string billing_code_type_version;
    string billing_code;
    string description;
    AllowedAmounts[] allowed_amounts;
|};

type MRFBase record {|
    string reporting_entity_name;
    string reporting_entity_type;
    string last_updated_on;
    string version;
    OutOfNetwork[] out_of_network;
|};

type Output record {|
    string BillingCode;
    string BillingType;
    string ProviderNPI;
    string BilledCharge;
    string AllowedAmount;
    string billingCodeValue;
    string billingType;
    string npis;
    string billed_charge;
    string allowedAmt;
|};
