import ballerina/http;
import ballerina/io;

public type Client client object {

    public string apiKey;
    public http:Client accuClient;

    public function __init(string apiKey) {
        self.accuClient = new ("http://dataservice.accuweather.com");
        self.apiKey = apiKey;
    }

    public remote function getDailyWeather(string zip) returns WeatherResponse | error {
        string requestPath = io:sprintf("/forecasts/v1/daily/1day/%s?apikey=%s", zip, self.apiKey);
        var response = self.accuClient->get(requestPath);
        if (response is http:Response) {
            var weatherData = <@untainted>response.getJsonPayload();
            // if (payload is json) {
            //     return payload;
            // } else {
            //     return error("Failed to retreive json payload", err = payload);
            // }
            if (weatherData is json) {
                json[] daily = <json[]>weatherData.DailyForecasts;
                WeatherResponse weather = {
                    dayWeather: daily[0].Day.IconPhrase.toString(),
                    nightWeather: daily[0].Night.IconPhrase.toString(),
                    minTemp: daily[0].Temperature.Minimum.Value.toString(),
                    maxTemp: daily[0].Temperature.Maximum.Value.toString()
                };
                return weather;
            } else {
                return error("Error while casting weather data to json");
            }
        } else {
            return error("Failed to call the accuweather endpoint", err = response);
        }
    }
};

