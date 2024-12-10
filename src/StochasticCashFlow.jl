module StochasticCashFlow
export compute_irr

using Dates


greet() = print("Hello World!")




mutable struct CFRecord
    time
    amount
    subject
    title
    notes
    df
end


mutable struct CF
    records
    def_uncert
    #def_df #function

end






function compute_npv(r,times,values)
    npv = 0.0
    for (v,t) in zip(values,times)
        npv += v/(1+r)^t
    end
    return npv
end

"""
adjust_periodic_rate(periodic_rate,periodicity,compounding=true)

Adjust a periodic rate (e.g. monthly) to a different periodity, considering compounding or not.

If the target periodicity is yearly this function returns, starting from a sub-year rate, the effective or nominal rate depending if compounding is considered or not.
See: https://global.oup.com/us/companion.websites/9780199339273/student/interactive/formulas/nominal/
"""
adjust_periodic_rate(periodic_rate,periodicity,compounding=true) = compounding ? (1+periodic_rate)^periodicity - 1 : periodic_rate * periodicity

"""
Compute the Internal Rate of Return of an investment given its flowcash

Conerning the periodicity, specific 1 for yearly payments, 12 for montly payments and so on.
"""
function compute_irr(times,values;epsilon=0.01,r_start=0.05, deltar_start = 0.02, maxiter=1000, r_lb=0.0, r_up=10000, periodicity=1, periodicity_compound=true )
    # First checcking with lower/upper rate bounds..
    if compute_npv(r_lb,times,values) < 0.0
        @warn "Negative irr even at the lower rate bound. Returning lower bound."
        return(adjust_periodic_rate(r_lb,periodicity,periodicity_compound))
    elseif compute_npv(r_up,times,values) > 0.0
        @warn "Positive irr even at the upper rate bound. Returning upper bound."
        return(adjust_periodic_rate(r_up,periodicity,periodicity_compound))
    end
    r_l   = r_start
    npv_l = compute_npv(r_l,times,values)
    #println("- lagged: $r_l \t  $npv_l")
    r     = (npv_l ) > 0 ? r_l +  deltar_start :  r_l -  deltar_start
    for it in 1:maxiter
        #println("*** n iteration: $it")
        npv   = compute_npv(r,times,values)
        #println("- current: $r \t  $npv")
        if abs(npv) < epsilon
            println("*** N iterations: $it")
            return adjust_periodic_rate(r,periodicity,periodicity_compound)
        end
        rnew     = r - npv * (r - r_l) / (npv - npv_l)
        r_l      = copy(r)
        r        = copy(rnew)
        npv_l    = copy(npv)
    end
    println("*** No convergence at maxiter $maxiter reached. Returning current irr")
    return adjust_periodic_rate(r,periodicity,periodicity_compound)
end


end # module StochasticCashFlow
