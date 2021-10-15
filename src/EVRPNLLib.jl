module EVRPNLLib

import Base: show

export Data, loadEVRPNL

const data_path = joinpath(pkgdir(EVRPNLLib), "data")

using LinearAlgebra
using EzXML
using ZipFile

include("Data.jl")
include("Util.jl")
include("Loader.jl")

end
