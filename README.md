# StochasticCashFlow
A stochastic multi-stakeholders discounted cashflow for cash flow analysis and projects evaluation


Main ideas at this point:

## Objective of the package:

Enable a cash flow based analysis of an hyphotetical investment, considering at the same time several "point of views" (called "subjects" in the package: e.g. the investment owner, the local neighbourhood, the society as a whole...), where some costs (or benefit) entries are stochastics and depends on complex interrelations between different random variables. The user of the package must be able to specify this complex relations between random variables and the effect on the cashflow entries.
The package must be able to adapt to different specific investment typologies, where the metric of interest can be different (NPV, IRR, but also more specific ones like, e.g. Soil Expected Values for land-based investments).

## Overview of the package 

The package separates the concept of _state_ variables to those of _cf entries_ (see later). The user either defines its own state variables and cf entries and their logic, or uses pre-made library-provided ones for specific investment typologies. The same for the metric to observe out of the cash flow, this can be user-defined or available in a library of metrics.
The package employs a MonteCarlo approach where it returns a distribution (or eventually some statistics) of the specific metric desired, for any specific _subject_ specified in the model.
Higher level functions can then be used to look for the parameter of the definitions of the state variable or cf entries that maximize (or minimize) the desired statistic, trasforming these parameters in control variables.

## Overview of the implementation

Each cash flow model is defined by some cf-specific parameters (number of MC iteractions, number of time periods,...) and two sets of, respectively, _state_ definitions and _cf items_ definitions.

State definitions are structs that subtypes StateV, while cfitems subtype CFRecord.

StateV are state variables that can be deterministic of stochastic, and whose concrete state at time t may depend on their own and previously defined states at times [1,t]. They do not directly bear a CF entry however.

CF _entries_ are the final CF values (costs of benefits). They depends on specific istances of state variables, and they can be eventually themselves employ a random component, but cf entries can't depend on other CF entries. Conversely, they have the "subject" property attached to them to specify to whom they belong (investment owner, local users, society as a whole....).

Example of state variables for forest investments (plantations): "Storm", with parameters damages and relative average times of return, and "Timber quantity" with parameters those of a logistic function and that depends on the "Storm" variable.

Example of CF entris for forest investments: "Timber sale", with parameters the means and standard deviations of the prices for different quality of the timber and associated agent the forest owner, or "Ecosystem services" with different entries associated to the "Society" agent. 
Once specific instances of state variables and cf entries are created, these are added to the CF object together with a registry of their realization across time periods.

The logic that defines the realization of the state is in `realize!(cf,t,s::StateV)`. Similarly, the registry of the cf entries is populated with `realize!(cf,t,cfe::CFEntry)`.

This two functions are run in a loop, first for the state variables in a loop for each state variable (in the order defined in the CF object) and time period and then for the CF entries. 

Once specific realizations of state variables and cf entries are created, these are added to the CF object. This happen for each Monte Carlo iteration, so that at the end we obtain a set of stochastic cashflows.

Finally these multi-realized CFs can be processed with some metric functions to return a distribution of the desired metric or a particular statistic of it.

Finally, the CF realization/metric can be used in a higher level function in order to providse an "optimization" function, where the user specific the statistic to maximize and the parameters of the state definitions to change (e.g. final harvesting period, the minimum share damage of a forest in order to lead replanting instead of continue,...). In this way, any "parameter" of the CF model can be turned on as an endogenous variable.
