function validateSolution(solution::Solution)
    data = solution.data

    visited = falses(length(data.nodes))
    total_time = 0.0
    feasible = true
    for r in 1:length(solution.routes)
        route = solution.routes[r]
        soc = data.vehicle.battery_capacity
        time = 0.0
        for n in 2:length(route)
            node = route[n].node
            waiting_time = route[n].waiting_time
            charged_energy = route[n].charged_energy
            
            if node.type == :customer && visited[node.id]
                println("Node already visited: $node.")
                feasible = false
            end
            visited[node.id] = true

            last = route[n - 1].node
            dist = data.distances[last.id, node.id]
            time += dist / data.vehicle.speed_factor + waiting_time#+ node.service_time
            soc -= dist * data.vehicle.consumption_rate

            if soc < -EPS
                println("Battery underflow on route $r, pos $n, node $(node.id).")
                feasible = false
            end

            if node.type == :station
                func = data.vehicle.functions[node.cs_type]
                time += getTime(func, soc, soc + charged_energy)
                soc += charged_energy

                if soc - data.vehicle.battery_capacity > EPS
                    println("Battery overflow on route $r, pos $n, station $(node.id).")
                    feasible = false
                end
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
