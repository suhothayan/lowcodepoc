// import ballerina/io;
import lowCode/whatsapp;
import lowCode/accuweather;
import lowCode/datamapper;

public function main() {
    json accuweatherResult = <json>accuweather:accuweather({zip: "80000", apiKey: "8dbh68Zg2J6WxAK37Cy2jVJTSMdnyAmV"});
    json dataMapperResult = <json> datamapper:datamapper({mapping: string `Today is ${<string>accuweatherResult.dayWeather} and the night is ${<string>accuweatherResult.nightWeather}. Today's maximum temprature is ${<string>accuweatherResult.maxTemp}F and the minimum temprature is ${<string>accuweatherResult.minTemp}F. Have a great day!! ~this is ur Ballerina weather bot`});
    json twillioResult = <json>whatsapp:whatsApp({msg:<string>dataMapperResult.mapping,
        toNumber: "+94773898282", fromNumber: "+14155238886", accountSID: "ACb2e9f049adcb98c7c31b913f8be70733",
        authToken: "77fafc6fadcf31e09dde5a0557fee3f5"});
}
