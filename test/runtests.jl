using Test, Dates, StochasticCashFlow


mutable struct Tempets <: RV
    lambdas::Array{Float64,1}
    values::Array{Float64,1}
end

tempets = Tempets([300,100,50,[1.0,0.8,0.2]])



function instantiate!()
