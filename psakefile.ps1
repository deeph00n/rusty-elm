task default -depends Build-Frontend, Build-Server, Run

task Build-Frontend {
    Push-Location ".\sandbox-client"
    elm make "src/Main.elm" --output "../sandbox-server/wwwroot/index.html"
    if ($lastexitcode -ne 0) { throw "Failed to build frontend" }
    Pop-Location
}

task Build-Server {
    Push-Location ".\sandbox-server"
    cargo build
    if ($lastexitcode -ne 0) { throw "Failed to build server" }
    Pop-Location
}

task Run {
    Push-Location ".\sandbox-server"
    Start-Process  "http://127.0.0.1:8080/"
    cargo run
    Pop-Location
}

task Elm {
    Push-Location ".\sandbox-client"
    Start-Process  "http://localhost:8000/"
    elm reactor
    Pop-Location
}