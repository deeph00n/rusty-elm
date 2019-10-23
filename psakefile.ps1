task default -depends Build-Frontend, Build-Server, Run

task Build-Frontend {
    Push-Location ".\sandbox-client"
    elm make "src/Main.elm" --output "../sandbox-server/wwwroot/index.html"
    Pop-Location
}

task Build-Server {
    Push-Location ".\sandbox-server"
    cargo build
    Pop-Location
}

task Run {
    Push-Location ".\sandbox-server"
    cargo run
    Pop-Location
}

task Elm {
    Push-Location ".\sandbox-client"
    Start-Process  "http://localhost:8000/"
    elm reactor
    Pop-Location
}