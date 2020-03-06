import lowCode/accuweather;
import lowCode/datamapper;
import lowCode/twilio;


public function main() returns error? {
    accuweather:Client accuweatherClient = new ("8dbh68Zg2J6WxAK37Cy2jVJTSMdnyAmV");
    accuweather:WeatherResponse accuweatherResult = check accuweatherClient->getDailyWeather("80000");

    string dataMapperResult = <string> datamapper:datamapper({mapping: string `Today is ${<string>accuweatherResult.dayWeather} and the night is ${<string>accuweatherResult.nightWeather}. Today's maximum temprature is ${<string>accuweatherResult.maxTemp}F and the minimum temprature is ${<string>accuweatherResult.minTemp}F. Have a great day!! ~this is ur Ballerina weather bot`});
    
    twilio:Client twilioClient = new ({
        accountSId: "ACb2e9f049adcb98c7c31b913f8be70733",
        authToken: "34b2e025b2db33da04cc53ead8ce09bf",
        xAuthyKey: ""
    });
    twilio:WhatsAppResponse twilioResult = check twilioClient->sendWhatsAppMessage("+14155238886", "+94773898282",dataMapperResult);
}
