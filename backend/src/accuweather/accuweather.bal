import ballerina/http;
import ballerina/io;

public type Client client object {

    public string apiKey;
    public http:Client accuClient;

    public function __init(public string apiKey) {
        self.accuClient = new("http://dataservice.accuweather.com");
        self.apiKey = apiKey;
    }

    public remote function getDailyWeather(public string zip) returns json|error {
        string requestPath = io:sprintf("/forecasts/v1/daily/1day/%s?apikey=%s", zip, self.apiKey);
        var response = self.accuClient->get(requestPath);
        if (response is http:Response) {
            var payload = <@untainted> response.getJsonPayload();
            if (payload is json) {
                return payload;
            } else {
                return error("Failed to retreive json payload", err = payload);
            }
        } else {
            return error("Failed to call the accuweather endpoint", err = response);
        }
    }
};

