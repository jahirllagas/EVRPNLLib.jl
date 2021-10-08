# using EVRPNLData
using EzXML

struct Node
    id::Int64
    type::Int64
    x::Float64
    y::Float64
    fast::Bool
    service_time::Float64

    function Node(id::Int64, type::Int64, x::Float64, y::Float64, fast::Bool)
        return new(id, type, x, y, fast, 0.0)
    end

    function Node(node::Node, service_time::Float64)
        return new(node.id, node.type, node.x, node.y, node.fast, service_time)
    end
end

struct Vehicle
    id::Int64
    dep_node::Int64
    arr_node::Int64
    max_travel_time::Float64
    speed_factor::Float64
end

struct Data
    name::String
    nodes::Vector{Node}
    fleet::Vector{Vehicle}
end

function readFleet(fleet_tag)
    fleet = Vehicle[]

    for vehicle_tag in eachelement(fleet_tag)
        id = parse(Int64, vehicle_tag["type"]) + 1
        departure_node = arrival_node = 0
        max_travel_time = speed_factor = 0.0
        for param_tag in eachelement(vehicle_tag)
            if nodename(param_tag) == "departure_node"
                departure_node = parse(Int64, nodecontent(param_tag)) + 1
            elseif nodename(param_tag) == "arrival_node"
                arrival_node = parse(Int64, nodecontent(param_tag)) + 1
            elseif nodename(param_tag) == "max_travel_time"
                max_travel_time = parse(Int64, nodecontent(param_tag))
            elseif nodename(param_tag) == "speed_factor"
                speed_factor = parse(Int64, nodecontent(param_tag))
            elseif nodename(param_tag) == "custom"
            end
        end
        push!(fleet, Vehicle(id, departure_node, arrival_node, max_travel_time, speed_factor))
    end

    return fleet
end

function readRequests(requests_tag, nodes::Vector{Node})
    for request_tag in eachelement(requests_tag)
        node = parse(Int64, request_tag["node"]) + 1
        for service_time_tag in eachelement(request_tag)
            if nodename(service_time_tag) == "service_time"
                nodes[node] = Node(nodes[node], parse(Float64, nodecontent(service_time_tag)))
            end
        end
    end
end

function readEVRPNL(instance::String)
    instance_file = joinpath("data", instance * ".xml")
    doc = readxml(instance_file)

    name = ""
    nodes = Node[]
    fleet = Vehicle[]

    root_tag = root(doc)
    for tag1 in eachelement(root_tag)
        if nodename(tag1) == "fleet"
            fleet = readFleet(tag1)
        elseif nodename(tag1) == "requests"
            readRequests(tag1, nodes)
        else
            for tag2 in eachelement(tag1)
                if nodename(tag1) == "info"
                    if nodename(tag2) == "name"
                        name = nodecontent(tag2)
                    end
                elseif nodename(tag1) == "network"
                    if nodename(tag2) == "nodes"
                        nodes = readNodes(tag2)
                    end
                end
            end
        end
    end

    return Data(name, nodes, fleet)
end

function readNodes(nodes_tag)
    nodes = Node[]

    for node_tag in eachelement(nodes_tag)
        id = parse(Int64, node_tag["id"]) + 1
        type = parse(Int64, node_tag["type"])
        x = y = 0.0
        fast = false
        for param_tag in eachelement(node_tag)
            if nodename(param_tag) == "cx"
                x = parse(Float64, nodecontent(param_tag))
            elseif nodename(param_tag) == "cy"
                y = parse(Float64, nodecontent(param_tag))
            elseif nodename(param_tag) == "custom"
                for param_tag2 in eachelement(param_tag)
                    if nodename(param_tag2) == "cs_type"
                        fast = nodecontent(param_tag2) == "fast"
                    end
                end
            end
        end
        push!(nodes, Node(id, type, x, y, fast))
    end

    return nodes
end

function getMatrixDist(cx::Vector{Float64}, cy::Vector{Float64})

    matrix = zeros(Float64, length(cx), length(cx))
    for i in 1:length(cx)
        for j in 1:length(cx)
            x = [cx[i], cy[i]]
            y = [cx[j], cy[j]]
            matrix[i, j] = sqrt(sum((x - y) .^ 2))
        end
    end
    return matrix
end

function main()
    instance = readEVRPNL("tc0c10s2ct1")
end

main()
