function getDistances(nodes::Vector{Node})
    distances = zeros(Float64, length(nodes), length(nodes))
    for node1 in nodes
        for node2 in nodes
            distances[node1.id, node2.id] = norm(node1.coordinates - node2.coordinates)
        end
    end
    return distances
end
