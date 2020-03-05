import ballerina/io;

type Node record {|
    json|error id;
    json|error name;
    json|error data;
|};

public function generateCode (json tree) returns ()|error {
    string balFile = IMPORTS;
    balFile = balFile.concat(MAIN_FUNC_START);
    json|error nodes = tree.Nodes;
    if (nodes is json) {
        map<json>|error nodeMap = map<json>.constructFrom(nodes);
        if nodeMap is map<json> {
            // populating the recods array
            Node[] nodeArray = [];
            nodeMap.forEach(function (json value) {
                Node node = {
                    id: value.id,
                    name: value.name,
                    data: value.data
                };
                json|error formData = value.data;
                if (node.name is json && formData is json) {
                    if (node.name == "Accuweather") {
                        io:StringReader sr = new(formData.toString(), encoding = "UTF-8");
                        json|error j = sr.readJson();
                        if j is json {
                            balFile = balFile.concat(buildAccuweatherNode(<json>j));
                        }
                    } else if (node.name == "Data mapper") {
                        io:StringReader sr = new(formData.toString(), encoding = "UTF-8");
                        json|error j = sr.readJson();
                        if j is json {
                            balFile = balFile.concat(buildDatamapperNode(<map<json>>j));
                        }
                    } else if (node.name == "Twilio") {
                        io:StringReader sr = new(formData.toString(), encoding = "UTF-8");
                        json|error j = sr.readJson();
                        if j is json {
                            balFile = balFile.concat(buildTwilioNode(<map<json>>j));
                        }
                    }
                }
                nodeArray.push(node);
            });
        } else {
            return error("Error while retrieving the node map data", err= nodeMap);
        }
    } else {
        return error("Error while retrieving the nodes data", err= nodes);
    }
    balFile = balFile.concat(MAIN_FUNC_END);
    io:println(balFile);
    return ();
}

public function buildAccuweatherNode (json data) returns string {
    return string `accuweather:Client accuweatherClient= new({ apiKey: \"${<string>data.apiKey}\"}); \njson ${<string>data.defaultOutputVariable} = <json> accuweatherClient->weatherToday(zip= \"${<string>data.zip}\");\n`;
}

public function buildDatamapperNode (json data) returns string {
    // io:println(data.mapping);
    return string `json ${<string>data.defaultOutputVariable} = <json> datamapper:datamapper({mapping: ${<string>data.mapping}});\n`;
}

public function buildTwilioNode (map<json> data) returns string {
    // io:println();
    // json|error token = data.authToken;
    // if(token is error){
    //     io:println(token.detail());
    // } 

    // io:println(token);
    // return "";
    return string `twilio:Client twilioClient = new({ accountSId: \"${<string>data.accountSID}\",\nauthToken: \"${<string>data.authToken}\",\nxAuthyKey: ""\n});\nvar ${<string>data.defaultOutputVariable} = twilioClient->sendWhatsAppMessage(\n\"${<string>data.fromNumber}\",\n\"${<string>data.toNumber}\",\n<string>${<string>data.mapping});\n`;
}

// public function generateStatment (json tree) {
//     string statemnt = string `${JSON_KEYWORD}${WHITE_SPACE}${resultVar}${ASSIGNMENT_SYMBOL}${OPEN_CAST_SYMBOL}
//                             ${JSON_KEYWORD}${CLOSE_CAST_SYMBOL}${importPackage}${COLON}${connectorName}${OPEN_PARAM}
//                             ${OPEN_MAP_SYMBOL}${keyValuePairs}${CLOSE_MAP_SYMBOL}${CLOSE_PARAM}`; 
// }
