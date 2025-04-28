function getXML(solution::Solution)
    sol_tag = ElementNode("solution")

    sol_tag["instance"] = solution.data.name
    sol_tag["solver"] = solution.solver
    sol_tag["optimal"] = solution.optimal

    for (id, route) in enumerate(solution.routes)
        route_tag = ElementNode("route")
        route_tag["id"] = id - 1
        for node in route
            node_tag = nothing
            if node.node.type == :depot
                node_tag = ElementNode("depot")
            elseif node.node.type == :customer
                node_tag = ElementNode("customer")
            elseif node.node.type == :station
                node_tag = ElementNode("station")
                wait_tag = ElementNode("wait")
                wait_tag.content = node.waiting_time
                link!(node_tag, wait_tag)
                charge_tag = ElementNode("charge")
                charge_tag.content = node.charged_energy
                link!(node_tag, charge_tag)
            else
                @error "Unknown node type."
            end
            node_tag["id"] = node.node.id - 1
            link!(route_tag, node_tag)
        end
        link!(sol_tag, route_tag)
    end

    machine_tag = ElementNode("machine")
    
    cpu_tag = ElementNode("cpu")
    cpu_tag.content = solution.machine.cpu
    link!(machine_tag, cpu_tag)

    cores_tag = ElementNode("cores")
    cores_tag.content = solution.machine.cores
    link!(machine_tag, cores_tag)

    ram_tag = ElementNode("ram")
    ram_tag.content = solution.machine.ram
    link!(machine_tag, ram_tag)

    language_tag = ElementNode("language")
    language_tag.content = solution.machine.language
    link!(machine_tag, language_tag)

    os_tag = ElementNode("os")
    os_tag.content = solution.machine.os
    link!(machine_tag, os_tag)

    runtime_tag = ElementNode("runtime")
    link!(runtime_tag, machine_tag)

    cputime_tag = ElementNode("cputime")
    cputime_tag.content = solution.cputime
    link!(runtime_tag, cputime_tag)

    link!(sol_tag, runtime_tag)

    return sol_tag
end

function writeSolution(solution::Solution, file_name::String)
    xml = getXML(solution)

    doc = XMLDocument()
    setroot!(doc, xml)

    open(file_name, "w") do io
        prettyprint(io, doc)
    end
end
