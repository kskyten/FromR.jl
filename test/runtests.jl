using FromR
using Test

@testset "FromR" begin
    for (input, expected) in [
        ("1 + 1", :(1 + 1)),
        ("x <- c(1, 2, 3)", :(x = [1., 2, 3])),
        ("x = c(1, 2, 3)", :(x = [1., 2, 3])),
        # ("function(x){x + 2}", :(x -> x + 2))
    ]
        @test transpile(Expr, input) == expected
    end
end
