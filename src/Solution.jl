struct RouteNode
    node::Node
    wait::Float64
    charge::Float64

    function RouteNode(node::Node)
        return new(node, 0.0, 0.0)
    end

    function RouteNode(node::Node, wait::Float64, charge::Float64)
        return new(node, wait, charge)
    end
end

struct Machine
    cpu::Float64
    cores::Int64
    ram::Float64
    language::String
    os::String

    function Machine()
        cpu = string(Sys.cpu_info()[1])
        range2 = findfirst("GHz", cpu)
        range1 = findlast(" ", cpu[1:range2.start])
        cpu = parse(Float64, cpu[(range1.stop + 1):(range2.start - 1)])

        cores = Sys.CPU_THREADS
        ram = Sys.total_memory() / 2^30
        language = "Julia " * string(VERSION)
        if Sys.islinux()
            os = split(readchomp(`lsb_release -d`), '\t')[2]
        elseif Sys.iswindows()
            os = "Windows " * string(Sys.windows_version())
        else
            error("OS not supported. Ask the developers in GitHub.")
        end

        return new(cpu, cores, ram, language, os)
    end
end

const Route = Vector{RouteNode}

struct Solution
    data::Data
    solver::String
    optimal::Bool

    routes::Vector{Route}

    machine::Machine
    cputime::Int64

    function Solution(data::Data, solver::String, optimal::Bool, routes::Vector{Route}, cputime::Int64)
        return new(data, solver, optimal, routes, Machine(), cputime)
    end
end
