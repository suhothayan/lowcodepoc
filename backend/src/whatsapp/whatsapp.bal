import wso2/twilio;

type Whatsapp record {
    string accountSId;
    string authToken;
    string sandboxNumber;
    string destinationNumber;
    string msg;
};

public function whatsApp(map<string> config) returns error|json {
    twilio:TwilioConfiguration twilioConfig = {
    accountSId: <string>config["accountSID"],
    authToken: <string>config["authToken"],
    xAuthyKey: ""
};
    twilio:Client twilioClient = new(twilioConfig);
    var whatsAppResponse = twilioClient->sendWhatsAppMessage(<string>config["fromNumber"], 
                            <string>config["toNumber"], <string>config["msg"]);
    if (whatsAppResponse is error) {
        return error("Error while pushing the whatsapp message");
    } else {
        return "";
    }
}
