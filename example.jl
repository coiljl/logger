@require "github.com/coiljl/static" static
@require "github.com/coiljl/server" serve Request
@require "." logger

const server = serve(logger(static(".")), 3000)
println("http://localhost:3000")
wait(server)
