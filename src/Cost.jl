function penalizedCost(data::Data, route::Route, ωq::Float64, ωd::Float64)
    return  route.cost + ωq * max(0, route.cost - data.max_time) + ωd * max(0, route.energy - data.bat_capacity)
end