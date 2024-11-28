# EVRPNLLib.jl

<!-- [![Build Status](https://github.com/jahirllagas/EVRPNLLib.jl/workflows/CI/badge.svg)](https://github.com/jahirllagas/EVRPNLLib.jl/actions)
[![Coverage](https://codecov.io/gh/jahirllagas/EVRPNLLib.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/jahirllagas/EVRPNLLib.jl) -->
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

This package reads `.xml` data files in `e-vrp-nl` format for Electric Vehicle Problem with Nonlinear Charging Function (EVRPNL) instances and returns `EVRPNLData` type:

```julia
struct EVRPNLData
    name      ::String          # Instance name
    nodes     ::Vector{Node}    # Nodes (depot, customers and stations)
    vehicle   ::Vehicle         # Vehicle data

    depot     ::Node            # Depot
    customers ::Vector{Node}    # Customers
    stations  ::Vector{Node}    # Stations

    distances ::Matrix{Float64} # Distance matrix

    best      ::Best            # BKS info
end
```

where `Node`:

```julia
struct Node
    id           ::Int64                 # Sequential identifier
    type         ::Symbol                # Type (:depot, :customer, :station)
    coordinates  ::Vector{Float64}       # 2D coordinates
    cs_type      ::Symbol                # Station type (:nothing, :slow, :normal, :fast)
    service_time ::Float64               # Service time
    base_node    ::Vector{Node, Nothing} # Original node if this one is a replica
    replicas     ::Vector{Node}          # Replicas generated using this node
end
```

where `Vechile`:

```julia
struct Vehicle
    max_travel_time  ::Float64                # Maximum travel time
    speed_factor     ::Float64                # Speed factor (km/h)
    consumption_rate ::Float64                # Battery's energy consumption rate (wh/km)
    battery_capacity ::Float64                # Vehicle's total battery capacity (wh)
    functions        ::Dict{Symbol, Function} # Recharging functions (cs_type as index)
end
```

where `Function`:

```julia
struct Function
    cs_type ::Symbol        # Station type (:slow, :normal, :fast)
    pieces  ::Vector{Piece} # Function's pieces
end
```

where `Piece`:

```julia
struct Piece
    battery_level ::Float64 # Battery level (wh)
    charging_time ::Float64 # Charging time (h)
end
```

where `Best`:

```julia
struct Best
    value::Float64 # Best value
    fleet::Int64   # Fleet used
end
```

To install:

```julia
] add https://github.com/jahirllagas/EVRPNLLib.jl
```

For example, to load instance `tc0c10s2ct1.xml`:

```julia
data = loadEVRPNL(:tc0c10s2ct1)
```

See the [full list](https://github.com/jahirllagas/EVRPNLLib.jl/tree/master/data).

If you want to generate new stations from existing customers (useful for ELRPNL), pass as first argument, and if you want to replicate the stations (useful for MIP models), pass as second argument.

```julia
data = loadEVRPNL(:tc0c10s2ct1, 3, 2)
```

This will create new stations from three existing customers, and replicate all stations two times.

Related links:

- [EVRP instances on the Vehicle Routing Problem Repository webpage](http://www.vrp-rep.org/datasets/item/2016-0020.html)
- [EVRP DIMACS Implementation Challenge webpage](http://dimacs.rutgers.edu/programs/challenge/vrp/evrp/)
