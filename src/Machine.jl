struct Machine
    cpu::Float64
    cores::Int64
    ram::Float64
    language::String
    os::String

    function Machine()
        info = split(string(Sys.cpu_info()[1]))
        cpu = ""
        for i in eachindex(info)
            if info[i] == "GHz"
                cpu = parse(Float64, info[i - 1])
                break
            elseif endswith(info[i], "GHz\",")
                cpu = parse(Float64, replace(info[i], "GHz\"," => ""))
            elseif info[i] == "MHz"
                cpu = parse(Float64, info[i - 1]) / 1000.0
                break
            end
        end

        if cpu == ""
            @warn "CPU frequency not found. Ask the developers in GitHub."
            cpu = 0.0
        end

        cores = Sys.CPU_THREADS
        ram = Sys.total_memory() / 2^30
        language = "Julia " * string(VERSION)
        if Sys.islinux()
            os = split(readchomp(`lsb_release -d`), '\t')[2]
        elseif Sys.iswindows()
            os = "Windows " * string(Sys.windows_version())
        else
            @warn "OS not supported. Ask the developers in GitHub."
        end

        return new(cpu, cores, ram, language, os)
    end
end
