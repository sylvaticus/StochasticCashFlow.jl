using Test, Dates, StochasticCashFlow


@kwargs mutable struct Storms <: StateV
    lambdas::Array{Float64,1}
    values::Array{Float64,1}
end
storms = Storms([300,100,50,[1.0,0.8,0.2]])

@kwargs mutable struct Timber <: RV
    v0::Float64
    alpha::Float64
    maxv::Float64
    harv_shares::Array{Float64,1}
    harv_times::Array{Int64,1}
    threshold_start_again::Float64
end
timber = Timber(100,0.05,1000.0,[0.2,0.2,0.5,1.0],[10,30,50,100],0.7)

users = ["forest_owner", "society"]

@kwargs mutable struct TimberSale <: CFItem
    price_q1::Float64
    price_q2::Float64
end
timbersales(15,50)

mutable struct ESs <: CFItem
    biodiversity_value::Float64
    price2::Float64
end







cf = CF(
    nperiods = 1000
    iterations = 100
    states_def = [storms,timber],
    cfitems_defs::Vector{CFRecord}
    users_names::Vector{Symbol} = Symbol[]
    states_instances::Dictionary{Symbol,Array{Float64,2}}
    cfitems_instances::Dictionary{(Symbol,Symbol),Array{Float64}}
end


function instantiate!(cf,t,statev::Storm)
