function loadEVRPNL(instance::Symbol)
    file_name = joinpath(data_path, string(instance) * ".zip")
    if !isfile(file_name)
        println("File $(string(instance)) not found!")
        return nothing
    end
    file = ZipFile.Reader(file_name)
    raw = read(file.files[1], String)
    doc = parsexml(raw)
    # doc = readxml(file_name)

    name = ""
    nodes = Node[]
    fleet = Vehicle[]

    root_tag = root(doc)
    for tag1 in eachelement(root_tag)
        if nodename(tag1) == "fleet"
            fleet = loadVehicle(tag1)
        elseif nodename(tag1) == "requests"
            loadRequests(tag1, nodes)
        else
            for tag2 in eachelement(tag1)
                if nodename(tag1) == "info"
                    if nodename(tag2) == "name"
                        name = nodecontent(tag2)
                    end
                elseif nodename(tag1) == "network"
                    if nodename(tag2) == "nodes"
                        nodes = loadNodes(tag2)
                    end
                end
            end
        end
    end

    depot = nodes[findfirst(x -> x.type == :depot, nodes)]
    customers = [ node for node in nodes if node.type == :customer ]
    stations = [ node for node in nodes if node.type == :station ]
    distances = getDistances(nodes)

    best = Best(loadBounds(name)...)

    return Data(name, nodes, fleet, depot, customers, stations, distances, best)
end

function loadNodes(nodes_tag)
    nodes = Node[]

    for node_tag in eachelement(nodes_tag)
        id = parse(Int64, node_tag["id"]) + 1

        type = :nothing
        type_id = parse(Int64, node_tag["type"])
        if (type_id == 0) type = :depot
        elseif (type_id == 1) type = :customer
        elseif (type_id == 2) type = :station
        end
        
        coordinates = [ 0.0, 0.0 ]
        cs_type = :nothing
        for param_tag in eachelement(node_tag)
            if nodename(param_tag) == "cx"
                coordinates[1] = parse(Float64, nodecontent(param_tag))
            elseif nodename(param_tag) == "cy"
                coordinates[2] = parse(Float64, nodecontent(param_tag))
            elseif nodename(param_tag) == "custom"
                for param_tag2 in eachelement(param_tag)
                    if nodename(param_tag2) == "cs_type"
                        cs_type_name = nodecontent(param_tag2)
                        if (cs_type_name == "slow") cs_type = :slow
                        elseif (cs_type_name == "normal") cs_type = :normal
                        elseif (cs_type_name == "fast") cs_type = :fast
                        end
                    end
                end
            end
        end
        push!(nodes, Node(id, type, coordinates, cs_type))
    end

    return nodes
end

function loadVehicle(vehicle_tag)
    vehicle = nothing

    for vehicle_tag in eachelement(vehicle_tag)
        id = parse(Int64, vehicle_tag["type"]) + 1
        max_travel_time = speed_factor = 0.0
        consumption_rate = battery_capacity = 0.0
        functions = Function[]
        for param_tag in eachelement(vehicle_tag)
            if nodename(param_tag) == "max_travel_time"
                max_travel_time = parse(Float64, nodecontent(param_tag))
            elseif nodename(param_tag) == "speed_factor"
                speed_factor = parse(Float64, nodecontent(param_tag))
            elseif nodename(param_tag) == "custom"
                for param_tag2 in eachelement(param_tag)
                    if nodename(param_tag2) == "consumption_rate"
                        consumption_rate = parse(Float64, nodecontent(param_tag2))
                    elseif nodename(param_tag2) == "battery_capacity"
                        battery_capacity = parse(Float64, nodecontent(param_tag2))
                    elseif nodename(param_tag2) == "charging_functions"
                        functions = loadFunctions(param_tag2)
                    end
                end
            end
        end
        vehicle = Vehicle(id, max_travel_time, speed_factor, consumption_rate, battery_capacity, functions)
    end

    return vehicle
end

function loadFunctions(functions_tag)
    functions = Function[]

    for function_tag in eachelement(functions_tag)
        pieces = Piece[]

        cs_type = :nothing
        cs_type_name = function_tag["cs_type"]
        if (cs_type_name == "slow") cs_type = :slow
        elseif (cs_type_name == "normal") cs_type = :normal
        elseif (cs_type_name == "fast") cs_type = :fast
        end

        for piece_tag in eachelement(function_tag)
            battery_level = charging_time = 0.0
            for param_tag in eachelement(piece_tag)
                if nodename(param_tag) == "battery_level"
                    battery_level = parse(Float64, nodecontent(param_tag))
                elseif nodename(param_tag) == "charging_time"
                    charging_time = parse(Float64, nodecontent(param_tag))
                end
            end
            push!(pieces, Piece(battery_level, charging_time))
        end

        push!(functions, Function(cs_type, pieces))
    end

    return functions
end

function loadRequests(requests_tag, nodes::Vector{Node})
    for request_tag in eachelement(requests_tag)
        node = parse(Int64, request_tag["node"]) + 1
        for service_time_tag in eachelement(request_tag)
            if nodename(service_time_tag) == "service_time"
                nodes[node] = Node(nodes[node], parse(Float64, nodecontent(service_time_tag)))
            end
        end
    end
end
