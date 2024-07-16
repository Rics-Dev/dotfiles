# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
#let is_mac: bool = (sys | get host.long_os_version | str downcase | str contains "macos")

    $env.PATH = ($env.PATH
        | append /usr/local/bin
        | append /usr/local/sbin
        | append $"($env.HOME)/go/bin"
        | append $"($env.HOME)/.cargo/bin"
        | append $"($env.HOME)/.local/bin"
        | append $"($env.HOME)/bin"
        | append $"($env.HOME)/.bun/bin"
        | append $"($env.HOME)/.turso" 
        | append ($env.PATH | split row (char esep))
    )

