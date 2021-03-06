import ballerina/io;

public type Node record {|
    json|error id;
    json|error name;
    json|error data;
|};

// public function generateCode (json tree) returns ()|error {
//     string balFile = IMPORTS;
//     balFile = balFile.concat(MAIN_FUNC_START);
//     json|error nodes = tree.Nodes;
//     if (nodes is json) {
//         map<json>|error nodeMap = map<json>.constructFrom(nodes);
//         if nodeMap is map<json> {
//             // populating the recods array
//             Node[] nodeArray = [];
//             nodeMap.forEach(function (json value) {
//                 Node node = {
//                     id: value.id,
//                     name: value.name,
//                     data: value.data
//                 };
//                 io:StringReader sr = new(value.data.toString(), encoding = "UTF-8");
//                 json|error jsonData = sr.readJson();
//                 if (node.name is json && jsonData is json) {
//                     if (node.name == "accuweather") {
//                         balFile = balFile.concat(buildAccuweatherNode(<json>jsonData));
//                     } else if (node.name == "datamapper") {
//                         balFile = balFile.concat(buildDatamapperNode(<map<json>>jsonData)); 
//                     } else if (node.name == "twilio") {
//                         balFile = balFile.concat(buildTwilioNode(<map<json>>jsonData));
//                     }
//                 }
//                 nodeArray.push(node);
//             });
//         } else {
//             return error("Error while retrieving the node map data", err= nodeMap);
//         }
//     } else {
//         return error("Error while retrieving the nodes data", err= nodes);
//     }
//     balFile = balFile.concat(MAIN_FUNC_END);
//     io:println(balFile);
//     return ();
// }

public function generateCode (json tree) returns ()|error {
    Node[]|error nodeAr = getNodes(tree);
    if (nodeAr is Node[]) {
        string importString = getImportString(nodeAr);
        io:print(importString);
        string|error mainFunc = generateMain(nodeAr);
        if mainFunc is string {
            io:println(mainFunc);
        } else{
            return error("Received node map in creating main function is not a json", err=nodeAr);
        }
    } else {
        return error ("Received node array is not a json", err=nodeAr);
    }
    return ();
}

public function getNodes (json tree) returns Node[]|error {
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
                nodeArray.push(node);
            });
            return nodeArray;
        } else {
            return error("Received node map is not a json", err=nodeMap);
        }
    } else {
        return error("Received nodes are not a json", err=nodes);
    }
}

public function getImportString (Node[] nodes) returns string {
    string importString = "";
    foreach var node in nodes {
        if (node.name.toString() != "Start") {
            // string name = node.name.toString().substring(0,1).toLowerAscii().concat(node.name.toString().substring(1,node.name.toString().length()));
            // io:println(name);
            importString = importString.concat(IMPORT_KEYWORD + WHITE_SPACE + MODULE_NAME + SLASH + node.name.toString() + SEMI_COLON + "\n");
        }
    }
    return importString;
}

public function generateMain (Node[] nodes) returns @tainted string| error {
    string mainFunc = "";
    mainFunc = mainFunc.concat(MAIN_FUNC_START);
    foreach var node in nodes {
        io:StringReader sr = new(node.data.toString(), encoding = "UTF-8");
        json|error jsonData = sr.readJson();
        if (node.name is json && jsonData is json) {
            if (node.name == "accuweather") {
                mainFunc = mainFunc.concat(buildAccuweatherNode(<json>jsonData));
            } else if (node.name == "datamapper") {
                mainFunc = mainFunc.concat(buildDatamapperNode(<map<json>>jsonData)); 
            } else if (node.name == "twilio") {
                mainFunc = mainFunc.concat(buildTwilioNode(<map<json>>jsonData));
            }
        } else {
            return error ("Received data is not a json", err=jsonData);
        }
    }
    mainFunc = mainFunc.concat(MAIN_FUNC_END);
    return mainFunc;
}

public function buildAccuweatherNode (json data) returns string {
    return string `accuweather:Client accuweatherClient= new(\"${<string>data.apiKey}\"); \naccuweather:WeatherResponse ${<string>data.defaultOutputVariable} = check accuweatherClient->getDailyWeather(\"${<string>data.zip}\");\n`;
}

public function buildDatamapperNode (json data) returns string {
    return string `string ${<string>data.defaultOutputVariable} = <string> datamapper:datamapper({mapping: ${<string>data.mapping}});\n`;
}

public function buildTwilioNode (map<json> data) returns string {
    return string `twilio:Client twilioClient = new({ accountSId: \"${<string>data.accountSID}\",\nauthToken: \"${<string>data.authToken}\",\nxAuthyKey: ""\n});\ntwilio:WhatsAppResponse ${<string>data.defaultOutputVariable} = check twilioClient->sendWhatsAppMessage(\n\"${<string>data.fromNumber}\",\n\"${<string>data.toNumber}\",\n<string>${<string>data.mapping});\n`;
}
