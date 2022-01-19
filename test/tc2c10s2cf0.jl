using EVRPNLLib

data = loadEVRPNL(:tc2c10s2cf0)
println(data)

solution = Solution(data, "MIP Montoya et al. (2016)", true, 300000)

route = Route()
addNode!(route, data.nodes[1])
addStation!(route, data.nodes[12], 10246.06854283780)
addNode!(route, data.nodes[7])
addNode!(route, data.nodes[6])
addNode!(route, data.nodes[8])
addStation!(route, data.nodes[13], 7408.0517850511815)
addNode!(route, data.nodes[1])
addRoute!(solution, route)

route = Route()
addNode!(route, data.nodes[1])
addNode!(route, data.nodes[2])
addNode!(route, data.nodes[3])
addNode!(route, data.nodes[4])
addNode!(route, data.nodes[5])
addStation!(route, data.nodes[13], 12979.5301381510)
addNode!(route, data.nodes[11])
addNode!(route, data.nodes[10])
addNode!(route, data.nodes[1])
addRoute!(solution, route)

route = Route()
addNode!(route, data.nodes[1])
addStation!(route, data.nodes[13], 4839.584878856890)
addNode!(route, data.nodes[9])
addStation!(route, data.nodes[13], 7408.0517850511815)
addNode!(route, data.nodes[1])
addRoute!(solution, route)

writeSolution(solution, data.name * ".xml")
validateSolution(solution)
