struct Node
    id::Int64
    type::Symbol
    coordinates::Vector{Float64}
    cs_type::Symbol
    service_time::Float64

    function Node()
        return new(0, :nothing, [], :nothing, 0.0)
    end

    function Node(id::Int64, type::Symbol, coordinates::Vector{Float64}, cs_type::Symbol)
        return new(id, type, coordinates, cs_type, 0.0)
    end

    function Node(node::Node, service_time::Float64)
        return new(node.id, node.type, node.coordinates, node.cs_type, service_time)
    end
end

struct Vehicle
    id::Int64
    max_travel_time::Float64
    speed_factor::Float64
    consumption_rate::Float64
    battery_capacity::Float64
    functions::Vector{Function}
end

struct Best
    value::Float64
    fleet::Int64
    time::Float64
end

struct Data
    name::String
    nodes::Vector{Node}
    vehicle::Vehicle

    depot::Node
    customers::Vector{Node}
    stations::Vector{Node}

    distances::Matrix{Float64}

    best::Best
end

function Base.show(io::IO, data::Data)
    print(io, "EVRPNL $(data.name)")
    if data.best.value != Inf
        print(io, " [BKS = $(data.best.value), v = $(data.best.fleet)]")
    end
end
