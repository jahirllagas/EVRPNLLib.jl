struct RouteNode
    node::Node
    charged_energy::Float64
    waiting_time::Float64
end

const Route = Vector{RouteNode}

struct Solution
    data::Data
    solver::String
    optimal::Bool

    routes::Vector{Route}

    machine::Machine
    cputime::Int64

    function Solution(data::Data, solver::String, optimal::Bool, cputime::Int64)
        return new(data, solver, optimal, Route[], Machine(), cputime)
    end
end

function addRoute!(solution::Solution, route::Route)
    push!(solution.routes, route)
end

function addNode!(route::Route, node::Node)
    push!(route, RouteNode(node, 0.0, 0.0))
end
    
function addStation!(route::Route, station::Node, charged_energy::Float64, waiting_time::Float64 = 0.0)
    push!(route, RouteNode(station, charged_energy, waiting_time))
end
