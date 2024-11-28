function getDistances(nodes::Vector{Node})
    distances = zeros(Float64, length(nodes), length(nodes))
    for node1 in nodes
        for node2 in nodes
            distances[node1.id, node2.id] = norm(node1.coordinates - node2.coordinates)
        end
    end
    return distances
end

function loadBounds(name::String)
    file_name = joinpath(data_path, "bks.txt")
    values = split(read(file_name, String))

    index = findfirst(isequal(name), values)
    if index !== nothing
        return parse(Float64, values[index + 1]), parse(Int64, values[index + 2]), parse(Int64, values[index + 3])
    else
        return Inf, -1, typemax(Int64)
    end
end

digitToInt(digit::Char)::Int64 = Int64(digit) - Int64('0')

function createGenerator(name::String, num_nodes::Int64)::MersenneTwister
    lastDigit = digitToInt(name[end])
    digit3 = digitToInt(name[3])
    seed = lastDigit + digit3 + num_nodes - 1
    return MersenneTwister(seed)
end
