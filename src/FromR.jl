module FromR
using RCall

export transpile

function parse(code)
    rcall(:parse; text=code)[1]
end

function Base.lastindex(obj::RObject{LangSxp})
    length(obj)
end

function Base.getindex(ptr::Ptr{LangSxp}, range::UnitRange{Int64})
    [ptr[i] for i in range]
end

const BINOPS = [
    :+, :*
]

function Lambda(args, block)
    return Expr(:->, Tuple(transpile(Expr, arg) for arg in args),
                Expr(:block, [transpile(Expr, b) for b in block[2:end]]...))
end

# function FunctionDef(name, args, body)
#     return Expr(:->, transpile(ctx, args), )
# end

function transpile(ctx, obj::RObject{LangSxp})
    head = rcopy(obj[1])
    args = obj[2:end]
    if head == Symbol("<-") || head == :(=)
        if args[2] == :function
            return FunctionDef(transpile(ctx, args[1]), names(args[2]), args[3])
        else
            return Expr(:(=), [transpile(Expr, arg) for arg in args]...)
        end
    # elseif head == :(=)
    #     return Expr(:(=), [transpile(Expr, arg) for arg in args]...)
    elseif head == :c
        return Expr(:vect, [transpile(Expr, arg) for arg in args]...)
    elseif head in BINOPS
        return Expr(:call, head, [transpile(Expr, arg) for arg in args]...)
    elseif head == :function
        funargs = names(args[2])
        return Lambda(funargs, args[3])
    end
end

# function transpile(ctx, obj::RObject{RCall.ListSxp})
#     rcopy(obj)
# end

function transpile(ctx, obj::RObject{RCall.SymSxp})
    rcopy(obj)
end

function transpile(ctx, obj::RObject{RCall.RealSxp})
    rcopy(obj)
end

function transpile(::Type{Expr}, code::String)
    transpile(Expr, parse(code))
end

end
