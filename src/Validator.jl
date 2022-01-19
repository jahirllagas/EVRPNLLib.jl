function validateSolution(solution::Solution)
    data = solution.data

    visited = falses(length(data.nodes))
    total_time = 0.0
    feasible = true
    for r in 1:length(solution.routes)
        route = solution.routes[r]
        battery = data.vehicle.battery_capacity
        time = 0.0
        for n in 2:length(route)
            node = route[n].node
            
            if node.type == :customer && visited[node.id]
                println("Node already visited: $node.")
                feasible = false
            end
            visited[node.id] = true

            last = route[n - 1].node
            dist = data.distances[node.id, last.id]
            time += dist / data.vehicle.speed_factor
            battery -= dist * data.vehicle.consumption_rate

            if battery < 1e-5
                println("Battery underflow on route $r, pos $n, node $(node.id).")
                feasible = false
            end

            if node.type == :station
                #TODO: calulcate battery recharge.
            end
        end
    
        if time > data.vehicle.max_travel_time
            println("Route $r exceeds maximum travel time ($time > $(data.vehicle.max_travel_time)).")
            feasible = false
        end

        total_time += time
    end

    for node in data.nodes
        if node.type == :customer && !visited[node.id]
            println("Node not visited: $(node.id).")
            feasible = false
        end
    end

    println("Total time = $total_time (" * (feasible ? "feasible" : "infeasible") * ")")
end
