import ballerina/io;
import ballerina/http;

public type Accuweather record {
    string apiKey;
    string stateCode;
};

public function accuweather(map<string> config) returns json|error {
    http:Client accuWeatherEP = new ("http://dataservice.accuweather.com");
    http:Response weatherResp = new;
    weatherResp = check accuWeatherEP->get(io:sprintf("/forecasts/v1/daily/1day/%s?apikey=%s", <string>config["zip"], 
                    <string>config["apiKey"]));
    json|error weatherData = weatherResp.getJsonPayload();
    if(weatherData is json){
        json[] daily = <json[]> weatherData.DailyForecasts;
        return <@untainted> { dayWeather:daily[0].Day.IconPhrase.toString(),
                    nightWeather:daily[0].Night.IconPhrase.toString(),
                    minTemp:daily[0].Temperature.Minimum.Value.toString(),
                    maxTemp:daily[0].Temperature.Maximum.Value.toString()
                };
    } else {
        return error("Error while casting weather data to json");
    }
}
