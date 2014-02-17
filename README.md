

# Confort

Confort is a small Elixir library for working with configuration
files.

It expects a configuration file to contain a single Keyword list
that it loads at application startup. For example:

```elixir
    [ global: "some_value",
      my_app1: [ key1: 42,
                 key2: :hello ],
      my_app2: [ key1: 10,
                 key2: :world ] ]
```

Confort only alllows data and no executable code in configuration files.

## How to use

Put it as a dependency in your project and start it by including it
to the applications configuration. At startup, Confort looks for a
`:conf_path` keyword in your project's Mix file and tries to load
the file it specifies.

Example:

```elixir
    defmodule MyApp.Mixfile do
      use Mix.Project

      def project do
        [ app: :myapp,
          conf_path: "priv/myapp.conf",
          deps: deps ]
      end

      def application do
        [  mod: { MyApp, [] },
           applications: [:confort] ]
      end

      def deps do
        [ { :confort, github: "zambal/confort" } ]
      end
```

Confort provides two function for getting values from a
configuration file: `Confort.get/1` and `Confort.get/2`.
The first accepts a key and the second accepts a key and a sub-key.
If your project will be used as a dependency in other projects,
it is advised to use `Confort.get/2`, where key is your project's name
and sub-key the actual key for your application. This way multiple
applications can use Confort without the risk of having name clashes.

Confort also supports reloading a configuration file with `Confort.reload/0`,
or loading one dynamically with `Confort.load/1`. However, for normal use cases
it is not advised to use these functions and let Confort just load the
configuration file specified with `:conf_path` at startup.
