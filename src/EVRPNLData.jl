module EVRPNLData

import Base: show

export Data, loadEVRPNL

const data_path = joinpath(pkgdir(EVRPNLData), "data")

using LinearAlgebra
using EzXML

include("Data.jl")
include("Util.jl")
include("Loader.jl")

end
