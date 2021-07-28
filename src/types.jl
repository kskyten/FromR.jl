# From https://github.com/JuliaInterop/RCall.jl/blob/master/src/types.jl

abstract type Sxp end # SEXPREC
const SxpPtrInfo = UInt32 # sxpinfo_struct

"R Sxp header: a pointer to this is used for unknown types."
struct SxpHead <: Sxp # SEXPREC_HEADER
    info::SxpPtrInfo
    attrib::Ptr{Cvoid}
    gc_next::Ptr{Cvoid}
    gc_prev::Ptr{Cvoid}
end
const UnknownSxp = SxpHead

abstract type VectorSxp <: Sxp end
abstract type VectorAtomicSxp <: VectorSxp end
abstract type VectorNumericSxp <: VectorAtomicSxp end
abstract type VectorListSxp <: VectorSxp end
abstract type PairListSxp <: Sxp end
abstract type FunctionSxp <: Sxp end


"R NULL value"
struct NilSxp <: PairListSxp   # type tag 0
    head::SxpHead
end

"R pairs (cons) list cell"
struct ListSxp <: PairListSxp  # type tag 2
    head::SxpHead
    car
    cdr
    tag
end

"R function closure"
struct ClosSxp <: FunctionSxp  # type tag 3
    head::SxpHead
    formals::Ptr{ListSxp}
    body
    env
end

"R environment"
struct EnvSxp <: Sxp  # type tag 4
    head::SxpHead
    frame
    enclos
    hashtab
end

"R promise"
struct PromSxp <: Sxp  # type tag 5
    head::SxpHead
    value
    expr
    env
end

"R function call"
struct LangSxp <: PairListSxp  # type tag 6
    head::SxpHead
    car
    cdr
    tag
end

"R special function"
struct SpecialSxp <: FunctionSxp  # type tag 7
    head::SxpHead
end

"R built-in function"
struct BuiltinSxp <: FunctionSxp  # type tag 8
    head::SxpHead
end

"R character string"
struct CharSxp <: VectorAtomicSxp     # type tag 9
    head::SxpHead
    length::Int
    truelength::Int
end

"R symbol"
struct SymSxp <: Sxp   # type tag 1
    head::SxpHead
    name::Ptr{CharSxp}
    value
    internal
end

"R logical vector"
struct LglSxp <: VectorNumericSxp     # type tag 10
    head::SxpHead
    length::Int
    truelength::Int
end

"R integer vector"
struct IntSxp <: VectorNumericSxp     # type tag 13
    head::SxpHead
    length::Int
    truelength::Int
end

"R real vector"
struct RealSxp <: VectorNumericSxp    # type tag 14
    head::SxpHead
    length::Int
    truelength::Int
end

"R complex vector"
struct CplxSxp <: VectorNumericSxp    # type tag 15
    head::SxpHead
    length::Int
    truelength::Int
end

"R vector of character strings"
struct StrSxp <: VectorListSxp     # type tag 16
    head::SxpHead
    length::Int
    truelength::Int
end

"R dot-dot-dot object"
struct DotSxp <: Sxp     # type tag 17
    head::SxpHead
end

"R \"any\" object"
struct AnySxp <: Sxp     # type tag 18
    head::SxpHead
end

"R list (i.e. Array{Any,1})"
struct VecSxp <: VectorListSxp     # type tag 19
    head::SxpHead
    length::Int
    truelength::Int
end

"R expression vector"
struct ExprSxp <: VectorListSxp    # type tag 20
    head::SxpHead
    length::Int
    truelength::Int
end

"R byte code"
struct BcodeSxp <: Sxp   # type tag 21
    head::SxpHead
end

"R external pointer"
struct ExtPtrSxp <: Sxp  # type tag 22
    head::SxpHead
    ptr::Ptr{Cvoid}
    prot::Ptr{Cvoid}
    tag
end

"R weak reference"
struct WeakRefSxp <: Sxp  # type tag 23
    head::SxpHead
end

"R byte vector"
struct RawSxp <: VectorAtomicSxp      # type tag 24
    head::SxpHead
    length::Int
    truelength::Int
end

"R S4 object"
struct S4Sxp <: Sxp      # type tag 25
    head::SxpHead
end
