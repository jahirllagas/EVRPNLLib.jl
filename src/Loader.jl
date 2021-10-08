function readEVRPNL(instance::String)
    doc = readxml("Instances/" * instance * ".xml")
    primates = root(doc)

    service = Float64[]
    consumption_rate = 0.0
    battery_capacity = 0.0
    cs_type = String[]
    cs_types = String[]
    battery_level = Float64[]
    charging_time = Float64[]
    departure_node = 0
    arrival_node = 0
    max_travel_time = 0.0
    speed_factor = 0.0
    coordX = Float64[]
    coordY = Float64[]

    for level_1 in eachelement(primates)
        for level_2 in eachelement(level_1)
            for level_3 in eachelement(level_2)
                if nodename(level_3) == "departure_node"
                    departure_node = parse(Float64, nodecontent(level_3))
                end
                if nodename(level_3) == "arrival_node"
                    arrival_node = parse(Float64, nodecontent(level_3))
                end
                if nodename(level_3) == "max_travel_time"
                    max_travel_time = parse(Float64, nodecontent(level_3))
                end
                if nodename(level_3) == "speed_factor"
                    speed_factor = parse(Float64, nodecontent(level_3))
                end
                if nodename(level_3) == "service_time"
                    push!(service, parse(Float64, nodecontent(level_3)))
                end
                for level_4 in eachelement(level_3)
                    if nodename(level_4) == "cx"
                        push!(coordX, parse(Float64, nodecontent(level_4)))
                    end
                    if nodename(level_4) == "cy"
                        push!(coordY, parse(Float64, nodecontent(level_4)))
                    end
                    if nodename(level_4) == "consumption_rate"
                        consumption_rate = parse(Float64, nodecontent(level_4))
                    end
                    if nodename(level_4) == "battery_capacity"
                        battery_capacity = parse(Float64, nodecontent(level_4))
                    end
                    
                    for level_5 in eachelement(level_4)
                        if nodename(level_5) == "cs_type"
                            push!(cs_type, nodecontent(level_5))
                        end
                        if nodename(level_5) == "function"
                            push!(cs_types, level_5["cs_type"])
                        end
                        for level_6 in eachelement(level_5)
                            for level_7 in eachelement(level_6)
                                if nodename(level_7) == "battery_level"
                                    push!(battery_level, parse(Float64, nodecontent(level_7)))
                                end
                                if nodename(level_7) == "charging_time"
                                    push!(charging_time, parse(Float64, nodecontent(level_7)))
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    matrix_dist = getMatrixDist(coordX, coordY)
    return 0
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
