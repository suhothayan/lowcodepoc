import ballerina/io;

type Node record {|
    json|error id;
    json|error name;
    json|error data;
|};

public function generateCode (json tree) returns ()|error {
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
            io:println(nodeArray);
        } else {
            return error("Error while retrieving the node map data", err= nodeMap);
        }
    } else {
        return error("Error while retrieving the nodes data", err= nodes);
    }
    return ();
}

public function codegen (json tree) returns ()|error {
}
