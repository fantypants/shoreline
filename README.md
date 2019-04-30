# Shoreline

# Constraints & Assumptions
- Globally unique, can it inherit the node id and still be classed as a uuid? 
- 100,000 req/sec implies that at any second we have 100,000 potential assigned id's
- 100,000 in 1 sec leaves 1000ms to assign seperating ids !== to assign via the timestamp alone
- Caller hasn't got an internal ref id?
- 100000/s on node 0001 ||  0001 100000
- Timestamp is 13 units leaving 7 units to fill the rest.


# Blanks I've Filled in
- For the test suite to function as it would if the actual module was finished, I have created a few helper functions and liberties such as passing an empty stack list as a 'vm based stack'
- The stack would be a fast Key Value DB (not postgres)
- The global ID is made up of these parts: [10 - Timestamp in Seconds][4 - Node ID][6 - Host ID]
- Time stamp: I have created a helper function to translate the epoch time into seconds, as in 1 second i can have absoutely max 100,000 requests which gives me a 10 digit stamp
- Node ID: I have included the node ID, however, this could be switched out or even modified based on a state management i.e you could have several node ids similar but as slaves (	the global id would have to be not a 64 bit unsigned int)
- Host ID: this is where we know it can be 0 or 100000, as we know per second we can have 100,000 we know we can generate only 100,000 of these keys. simple incrementation is used 	in this case, genrally I've used binary to do a similar system.
- After the New ID has been produced we then validate the guid and check (this is performed through a example test 'stack') but ideally this will be your eLevelDB or similar KV  		store.
- If the id is truly unique then it will be returned, if not it will re generate based on the last element in the stack, if that fails at all and the error is returned i have  		simply screen printed for tolerance options further down the track


# Example GUID
 15566007190001000000 = 1556600719 | 0001 | 000000
 1556600719 ~> Timestamp(Seconds)
 0001 ~> Node ID
 000000 ~-> Host Id generated
 

 # I have started with IO TDD and while building the helper functions, there is a little bit more you can do to make it robust i.e have the id's collected via a genstage and cleared when necessary, can even use the same system to handle the master slave fault tolerance for the nodes. A KV store such as eLeveldB would be ideal in this situation with helper functions removing, updating and inserting the new id's based from the genstage event manager

 # ```mix test```
