using EVRPNLLib
using Documenter

DocMeta.setdocmeta!(EVRPNLLib, :DocTestSetup, :(using EVRPNLLib); recursive=true)

makedocs(;
    modules=[EVRPNLLib],
    authors="Blah",
    repo="https://github.com/jahirllagas/EVRPNLLib.jl/blob/{commit}{path}#{line}",
    sitename="EVRPNLLib.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jahirllagas.github.io/EVRPNLLib.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jahirllagas/EVRPNLLib.jl",
)
