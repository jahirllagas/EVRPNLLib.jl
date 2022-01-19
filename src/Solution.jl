struct RouteNode
    node::Node
    charge::Float64
    wait::Float64

    function RouteNode(node::Node)
        return new(node, 0.0, 0.0)
    end

    function RouteNode(node::Node, charge::Float64, wait::Float64 = 0.0)
        return new(node, charge, wait)
    end
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
    push!(route, RouteNode(node))
end
    
function addStation!(route::Route, station::Node, charge::Float64, wait::Float64 = 0.0)
    push!(route, RouteNode(station, charge, wait))
end
