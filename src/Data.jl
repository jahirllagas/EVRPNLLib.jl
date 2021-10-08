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

struct Piece
    battery_level::Float64
    charging_time::Float64
end

struct Function
    cs_type::Symbol
    pieces::Vector{Piece}
end

struct Vehicle
    id::Int64
    max_travel_time::Float64
    speed_factor::Float64
    consumption_rate::Float64
    battery_capacity::Float64
    functions::Vector{Function}
end

struct Data
    name::String
    nodes::Vector{Node}
    vehicle::Vehicle

    depot::Node
    customers::Vector{Node}
    stations::Vector{Node}

    distances::Matrix{Float64}
end

function Base.show(io::IO, data::Data)
    print(io, "EVRPNL Data $(data.name)")
    print(io, " ($(length(data.customers)) customers, $(length(data.stations)) stations)")
end
