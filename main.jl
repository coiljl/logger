@require "github.com/jkroso/AnsiColor.jl@update-syntax" colorize
@require "github.com/coiljl/server@8c07bfe" Request verb

logger(next) = req -> logger(next, req)
logger(next, req::Request) = begin
  println(" ⤏ $(colorize(:default, verb(req), mode="bold")) $(colorize(:white, string(req.uri)))")
  LoggedResponse(next, req)
end

immutable LoggedResponse
  next::Any
  req::Request
end

Base.write(io::IO, r::LoggedResponse) = begin
  start = time_ns()
  res = r.next(r.req)
  bytes = write(io, res)
  time = time_ns() - start
  print(" ⤎ $(colorize(:default, verb(r.req), mode="bold")) ")
  print("$(colorize(:white, string(r.req.uri))) ")
  print("$(colorize(color[floor(res.status / 100)], string(res.status))) ")
  print(humantime(time), " ")
  println(humanbytes(bytes))
  bytes
end

const color = Dict(5 => :red,
                   4 => :yellow,
                   3 => :cyan,
                   2 => :green,
                   1 => :green)

const units = [:B, :kB, :MB, :GB, :TB, :PB, :EB, :ZB, :YB]

humanbytes(n::Integer) = begin
  n == 0 && return "0B"
  exp = min(floor(log(n) / log(1000)), length(units))
  return "$(tidynumber(n / 1000 ^ exp))$(units[Int(exp) + 1])"
end

humantime(ns::Integer) = begin
  ns > 1e9 && return tidynumber(ns / 1e9) * "s"
  ns > 1e6 && return tidynumber(ns / 1e6) * "ms"
  ns > 1e3 && return tidynumber(ns / 1e3) * "μs"
  return "$(ns)ns"
end

tidynumber(n::Real) = sprint(print_shortest, round(n, 1))
