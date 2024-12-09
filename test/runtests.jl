using Test, Dates, StochasticDCF
import StochasticDCF: compute_npv, adjust_periodic_rate

payments = [
(-11000, Date(2022,01,19)),
(-1000, Date(2022,10,6)),
(-2000, Date(2023,6,26)),
(-800, Date(2023,9,22)),
(-1700, Date(2024,2,6)),
]
current_value = 18483.88 

t0     = payments[1][2]
days   = vcat([(Day(p[2] - t0)).value for p in payments], Day(today() - t0).value)
values = vcat([p[1] for p in payments],current_value)

irr = compute_irr(days,values,periodicity=12, periodicity_compound=false,r_start=0.002)
irr = compute_irr(days,values,periodicity=365, periodicity_compound=true,r_start=0.002)

times_days = [0,365,365*2]
times_year = [0,1,2]
values = [100,200,300]
rdaily = 0.1/365
ryear = adjust_periodic_rate(rdaily,12,false)

compute_npv(r,times,values)


days = [0,365/2,365]
values = [-1000,600,600]
years = days ./ 365
irr1 = compute_irr(years,values,periodicity=1, periodicity_compound=false,r_start=0.002)
irr2 = compute_irr(years,values,periodicity=1, periodicity_compound=true,r_start=0.002)
irr3 = compute_irr(days,values,periodicity=365, periodicity_compound=false,r_start=0.002)
irr4 = compute_irr(days,values,periodicity=365, periodicity_compound=true,r_start=0.002)

-1000+600/(1+irr1/2) + 600 / (1+irr1)
-1000+600/(1+irr3/2) + 600 / (1+irr3)
-100+60/(1+irr3/365)^(365/2)+ 60 / (1+irr3/365)^365
-100+60/(1+irr4/365)^(365/2)+ 60 / (1+irr4/365)^365

-100+60/(1+irr2/2)+60/(1+irr2/2)^2

days = [0,365/2,365]
values = [-100,60,60]

t1 = 0.27178
t1_d = 0.27178/365
-100+60/(1+t1/2) + 60 / (1+t1)

-100+60/(1+rnpv)^(365/2)+ 60 / (1+rnpv)^365


rnpv = 0.00067312
compute_npv(rnpv,days,values)

adjust_periodic_rate(rnpv,365,true)