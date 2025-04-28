module EVRPNLLib

import Base: show

export Data, Node, nn, nc, ns, loadEVRPNL, loadELRPNL
export getTime, getTimeBySOC, findPieceByTime
export getSOC, getSOCByTime, findPieceBySOC
export Solution, Route, Machine
export addNode!, addStation!, addRoute!
export validateSolution, writeSolution

const data_path = joinpath(pkgdir(EVRPNLLib), "data")
const EPS = 1e-5

using LinearAlgebra
using EzXML
using ZipFile

include("Charge.jl")
include("Data.jl")
include("Util.jl")
include("Loader.jl")
include("Machine.jl")
include("Solution.jl")
include("Writter.jl")
include("Validator.jl")

end
