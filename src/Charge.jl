struct Piece
    battery_level::Float64
    charging_time::Float64
end

struct Function
    cs_type::Symbol
    pieces::Vector{Piece}
end

#TODO: #6 Code fast find piece.
function findPieceBySOC(func::Function, soc::Float64)::Int64
    if soc > -EPS
        last = 0.0
        for p in 2:length(func.pieces)
            if soc - last > -EPS && soc - func.pieces[p].battery_level < EPS
                return p
            end
            last = func.pieces[p].battery_level
        end
    end
    return 0
end

function findPieceByTime(func::Function, time::Float64)::Int64
    if time > -EPS
        last = 0.0
        for p in 2:length(func.pieces)
            if time - last > -EPS && time - func.pieces[p].charging_time < EPS
                return p
            end
            last = func.pieces[p].charging_time
        end
    end
    return 0
end

function getBattPieceSize(func::Function, p::Int64)::Float64
    return func.pieces[p].battery_level - func.pieces[p - 1].battery_level
end

function getTimePieceSize(func::Function, p::Int64)::Float64
    return func.pieces[p].charging_time - func.pieces[p - 1].charging_time
end

function getTimeBySOC(func::Function, soc::Float64)::Float64
    p = findPieceBySOC(func, soc)
    if p == 0 return Inf64 end
    return func.pieces[p - 1].charging_time + getTimePieceSize(func, p) * (soc - func.pieces[p - 1].battery_level) / getBattPieceSize(func, p)
end

function getSOCByTime(func::Function, time::Float64)::Float64
    p = findPieceByTime(func, time)
    if p == 0 return Inf64 end
    return func.pieces[p - 1].battery_level + getBattPieceSize(func, p) * (time - func.pieces[p - 1].charging_time) / getTimePieceSize(func, p)
end

function getSOC(func::Function, initial_soc::Float64, time::Float64)
    @error "Method not implemented!"
end

function getTime(func::Function, initial_soc::Float64, final_soc::Float64)::Float64
    return getTimeBySOC(func, final_soc) - getTimeBySOC(func, initial_soc)
end
