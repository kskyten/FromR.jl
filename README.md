# FromR

FromR is a R-to-Julia tranpiler. It is mainly intended for translating numerical code and wrapping R packages.

## Usage

FromR exports a single `transpile` method, which takes the desired format
as the first argument and the code to be transpiled as the second argument.
Additional options can be given as keyword arguments. Look at the tests to see
what is implemented.

``` julia
using FromR

transpile(Expr, "1 + 1")

transpile(String, "function(x, y){x + y}")

open("output.jl", "w") do f
    transpile(f,
    """
    myfun <- function (x){
        x + 1
    }
    """)
end
```
