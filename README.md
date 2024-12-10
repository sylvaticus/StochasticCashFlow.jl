# StochasticCashFlow
A stochastic multi-stakeholders discounted cashflow for CB analysis and project evaluations


Main ideas at this point:

Each cashflow is defined by some parameters (MC interactions, n time periods,...) and two sets of state_deifinitions and cfitem definitions

State definitions are instances of user provided structs that subs StateV, while cfitems are the same for user provided classes that are child of CFRecord (borth both a library for specific kind of investments are provided).

StateV are state variables that can be deterministic of stochastic, and whose state at time t may depend on their own and previously defined StateV at times [1,t]. They do not directly bear a CF entry however.


CF entries are separate registries that depends on states (at any times) and define specific levels for each agent, so for example the CFEntrys "Mgm cost" and "Timber sale" assign cost and profit to the forest owner, while the entries in "ES System" define values for the "society" agent. This function can also be stochastic, but CF entries depends only on state variabels, not on other CF entries.

The user defines the  StateV end CFRecord  structs (their definition) and the specific instantiate!(cf,t,s::StateV) and instantiate!(cf,cfe::CFRecord).

On each MC attempt this instantiation functions are called, in the states_def order and then time by time, so that the states are fully defined. Subsequently the CF entries are instantiated.



