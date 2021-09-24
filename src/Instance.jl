struct Client
    id              ::Int64
    service          ::Float64
end

struct Charging
    type            ::Symbol
    lb              ::Float64
    lu              ::Float64
    slope           ::Float64
end

struct Station
    id              ::Int64
    type            ::Symbol
    piecewices      ::Vector{Charging}
end

struct Data
    clients         ::Vector{Client}
    stations        ::Vector{Client}
    matrix          ::Matrix{Station}
    departure       ::Int64
    arrival         ::Int64
    max_time        ::Float64
    speed           ::Float64
    consumption_rate::Float64
    bat_capacity    ::Float64

    function Data(demands::Vecto{Float64}, matrix::Matrix{Station}, departure::Int64, arrival::Int64, traveltime::Float64, speed::Float64)
        
        return new(matrix, departure, arrival, traveltime, speed)
    end
end    

mutable struct Route
    clients         ::Vector{Client}
    travel_time     ::Float64
    cost            ::Float64
    distances       ::Vector{Float64}
end


mutable struct Solution
    routes          ::Vector{Route}
    totalcost       ::Float64
    nveh            ::Int64
end