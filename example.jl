@require "github.com/jkroso/HTTP.jl/server" serve
@require "github.com/coiljl/static" static
@require "." logger

const server = serve(logger(static(".")), 3000)
println("http://localhost:3000")
wait(server)
