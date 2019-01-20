Finite Element Methods solver for equation
```
-u'' + ku' = 5x + 10
```
with boundary conditions:<br>
u(0) = 5<br>
u'(1) = 3<br>

Parameters:
* k - given param
* n - number of elements

To run:
```
julia mes.jl <param k> <param n>
```
Or from REPL
```
ARGS = ["<param k", "<param n>"]
include("mes.jl")
```
