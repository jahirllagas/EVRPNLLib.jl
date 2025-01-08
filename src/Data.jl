struct Node
    id::Int64
    type::Symbol
    coordinates::Vector{Float64}
    cs_type::Symbol
    service_time::Float64

    base_node::Union{Node, Nothing}
    replicas::Vector{Node}

    function Node(
        id::Int64 = 0,
        type::Symbol = :nothing,
        coordinates::Vector{Float64} = Float64[],
        cs_type::Symbol = :nothing,
        service_time::Float64 = 0.0,
        base_station::Union{Node, Nothing} = nothing,
        replicas::Vector{Node} = Node[]
    )
        return new(id, type, coordinates, cs_type, service_time, base_station, replicas)
    end

    function Node(node::Node, service_time::Float64)
        return new(node.id, node.type, node.coordinates, node.cs_type, service_time, node.base_node, node.replicas)
    end
end

function Base.show(io::IO, node::Node)
    print(io, "Node $(node.id): ($(node.type), $(node.cs_type), $(node.service_time), $(node.base_node !== nothing ? node.base_node.id : nothing))")
end

struct Vehicle
    id::Int64
    max_travel_time::Float64
    speed_factor::Float64
    consumption_rate::Float64
    battery_capacity::Float64
    functions::Dict{Symbol, Function}
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

    type::Symbol

    best::Best
end

function Base.show(io::IO, data::Data)
    print(io, "$(data.type) $(data.name)")
    if data.best.value != Inf
        print(io, " [BKS = $(data.best.value), v = $(data.best.fleet)]")
    end
end

nn(data::Data) = length(data.nodes)
nc(data::Data) = length(data.customers)
ns(data::Data) = length(data.stations)
