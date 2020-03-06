import ballerina/io;
import lowCode/accuweather;
import lowCode/datamapper;
import lowCode/twilio;


public function main() returns error? {
    accuweather:Client accuweatherClient = new (apiKey = "8dbh68Zg2J6WxAK37Cy2jVJTSMdnyAmV");
    json accuweatherResult = check accuweatherClient->getDailyWeather(zip = "80000");

    json dataMapperResult = <json>datamapper:datamapper({mapping: string `Today is ${<string>accuweatherResult.dayWeather} and the night is ${<string>accuweatherResult.nightWeather}. Today's maximum temprature is ${<string>accuweatherResult.maxTemp}F and the minimum temprature is ${<string>accuweatherResult.minTemp}F. Have a great day!! ~this is ur Ballerina weather bot`});
    
    twilio:Client twilioClient = new ({
        accountSId: "ACb2e9f049adcb98c7c31b913f8be70733",
        authToken: "34b2e025b2db33da04cc53ead8ce09bf",
        xAuthyKey: ""
    });
    var twilioResult = twilioClient->sendWhatsAppMessage("+14155238886", "+94773898282", "test");
    if (twilioResult is twilio:WhatsAppResponse) {
        io:println(twilioResult);
    } else {
        io:print(twilioResult);
    }
}
