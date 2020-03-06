type DataMapper record {
    string msg;
};

public function datamapper(map<string> config) returns string|error {
    if (config.length() == 0) {
        return error("Received data mapper is empty");
    }
    json jsonMsg = {mapping:<string>config["mapping"]};
    string res= jsonMsg.mapping.toString();
    return res;
}
