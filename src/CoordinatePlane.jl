
function getMatrixDist(cx::Vector{Float64}, cy::Vector{Float64})

    matrix = zeros(Float64, length(cx), length(cx))
    for i in 1:length(cx)
        for j in 1:length(cx)
            x = [cx[i], cy[i]]
            y = [cx[j], cy[j]]
            matrix[i, j] = sqrt(sum((x - y) .^ 2))
        end
    end
    return matrix
end