using EVRPNLLib

data = loadEVRPNL(:tc1c320s38ct2)
println(data)

routes = Route[]
for r in 1:3
    route = RouteNode[]
    push!(route, RouteNode(data.nodes[1]))
    for i in 1:10
        node = rand(data.nodes)
        if node.type != :station
            push!(route, RouteNode(node))
        else
            push!(route, RouteNode(node, rand(1:0.1:1000), rand(1:0.1:1000)))
        end
    end
    push!(route, RouteNode(data.nodes[1]))
    push!(routes, route)
end

sol = Solution(data, "EletricJulia", false, routes, 100)
println(sol)

writeSolution(sol, data.name * "-out.xml")
