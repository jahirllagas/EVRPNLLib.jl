using EVRPNLLib

data = loadEVRPNL(:tc1c320s38ct2)
println(data)

solution = Solution(data, "EletricJulia", false, 100)
for r in 1:3
    route = Route()
    addNode!(route, data.nodes[1])
    for i in 1:10
        node = rand(data.nodes)
        if node.type != :station
            addNode!(route, node)
        else
            addStation!(route, node, rand(1:0.1:1000), rand(1:0.1:1000))
        end
    end
    addNode!(route, data.nodes[1])
    addRoute!(solution, route)
end
println(solution)

writeSolution(solution, data.name * ".xml")
validateSolution(solution)
