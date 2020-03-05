import ballerina/http;
import ballerina/log;
import ballerina/io;
// import ballerina/io;

service lowcode on new http:Listener(9090) {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/codegen"
    }
    resource function codegen(http:Caller caller, http:Request req) {
        json| error tree = req.getJsonPayload();
        if tree is json {
            ()|error codegenResult = generateCode(tree);
            if (codegenResult is error) {
                log:printError("Error while generating code", err = codegenResult );
            }
        } else {
            log:printError("Error while receiving the json payload");
        }
        var result = caller->respond("Hello, World!");

        if (result is error) {
            log:printError("Error sending response", result);
        }
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/schema/{connectorName}"
    }
    resource function schema(http:Caller caller, http:Request req, string connectorName) {
        json responseJson;
        io:println(connectorName);
        if (connectorName == "Accuweather") {
            responseJson = {
                inputs: [
                    {"type": "input", label: "ZIP code", id: "zip"},
                    {"type": "input", label: "API key", id: "apiKey"}
                ],
                defaultOutputVariable: "accuweatherResult"
            };
        } else if (connectorName == "DataMapper") {
            responseJson = {
                inputs: [
                    {"type": "textarea", label: "Mapping", "default": "", id:"mapping",
                        info: "Use `${...}` to map the variables in the mapping"
                    }
                ],
                defaultOutputVariable: "dataMapperResult"
            };
        } else if (connectorName == "Twillio") {
            responseJson = {
                inputs: [
                    {"type": "input", label: "From Number", id: "fromNumber"},
                    {"type": "input", label: "To Number", id: "toNumber"},
                    {"type": "input", label: "Account SID", id: "accountSID"},
                    {"type": "input", label: "Auth Token", id: "twillioResult"}
                ],
                defaultOutputVariable: "accuweatherResult"
            };
        } else {
            responseJson = "";
        }
        var result = caller->respond(responseJson);
        if (result is error) {
            log:printError("Error sending response", result);
        }
    }
}
