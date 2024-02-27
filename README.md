# dockerexec - An erlexec fork designed for execution within Docker

[![build](https://github.com/s3cur3/dockerexec/actions/workflows/erlang.yml/badge.svg)](https://github.com/s3cur3/dockerexec/actions/workflows/erlang.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/dockerexec.svg)](https://hex.pm/packages/dockerexec)
[![Hex.pm](https://img.shields.io/hexpm/dt/dockerexec.svg)](https://hex.pm/packages/dockerexec)

This is a fork of [erlexec](https://github.com/saleyn/erlexec) designed to be used within Docker.
It has two primary philosophical differences from erlexec:

1. It allows execution as root without needing `sudo` (since many Docker configurations
   run the app as root, and may not even ship with the `/usr/bin/sudo` executable)
2. It removes the requirement for the `SHELL` environment variable to be set

While neither of these requirements are particularly burdensome for applications incorporating
erlexec directly into their package, they represent a bit of a non-starter for libraries
that want to depend on erlexec. Nobody wants to have to dig into their Docker configuration
to install a third-party library... they want to just add the dependency to their `mix.exs`
or `rebar.config` and be done with it.

## USAGE ##

### Erlang: import as a dependency ###

- Add dependency in `rebar.config`:
```erlang
{deps,
 [% ...
  {dockerexec, "~> 2.0"}
  ]}.
```

- Include in your `*.app.src`:
```erlang
{applications,
   [kernel,
    stdlib,
    % ...
    dockerexec
   ]}
```

### Elixir: import as a dependency ###

```elixir
defp deps do
  [
    # ...
    {:dockerexec, "~> 2.0"}
  ]
end
```
