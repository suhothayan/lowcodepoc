function filteredJSON(json) {
    var shapes = json["shapes"]

    var nodes = {};
    var edges = {};

    for (var key of Object.keys(shapes)) {
        if (shapes[key].hasOwnProperty("id")) {
            if (shapes[key]["type"] == "connector") {
                //edges
                let edge = {
                    id: shapes[key]["id"],
                    source: shapes[key]["path"]["h"]["shapeId"],
                    target: shapes[key]["path"]["t"]["shapeId"]
                }
                edges[key]=edge;
            } else if (shapes[key]["type"] == "basic") {
                //nodes
                if (shapes[key].hasOwnProperty("texts")) {
                    let node = {
                        id: shapes[key]["id"],
                        name: shapes[key]["texts"]["identifier"]["content"][0]["text"],
                        type: shapes[key]["defId"],
                        data: {}
                    }
                    // nodes.push(node);
                    nodes[key]=node;
                } else {
                    let node = {
                        id: shapes[key]["id"],
                        name: shapes[key]["defId"],
                        type: shapes[key]["defId"],
                        data: {}
                    }
                    nodes[key]=node;
                }
            }
        }
    }

    var result = {
        "Nodes": nodes,
        "Edges": edges
    };

    console.log(JSON.stringify(result));
}


