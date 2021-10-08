module EVRPNLData

export Data, readEVRPNL

const data_path = joinpath(pkgdir(EVRPNLData), "data")

using EzXML

const EPS = 1e-7

include("Data.jl")
include("Loader.jl")

end
