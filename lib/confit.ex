defmodule Confit do
  @moduledoc """
  `Confit` works with files that define a `Keyword` list.

  At startup, `Confit` looks for a `:conf_path` keyword in your
  project's Mix file and tries to load the file it specifies,
  for example:

      def project do
        [ app: :myapp,
          conf_path: "priv/myapp.conf" ]
      end

  `Confit` provides two function for getting values from a
  configuration file: `Confit.get/1` and `Confit.get/2`.
  The first accepts a key and the second accepts a
  key and a sub-key. If your project will be used as a dependency
  in other projects, it is advised to use `Confit.get/2`, where
  key is your project's name and sub-key the actual key for your
  application. This way multiple applications can use `Confit`
  without the risk of having name clashes.

  `Confit` also supports reloading a configuration file with `Confit.reload/0`,
   or loading one dynamically with `Confit.load/1`. However, for normal use cases
   it is not advised to use these functions and let `Confit` just load the
   configuration file specified with `:conf_path` at startup.
  """

  use Application.Behaviour

  @server Confit.Server

  def start(_type, _args) do
    Confit.Supervisor.start_link
  end

  @doc """
  Accepts an atom as key and returns the associated value, if any.
  """
  @spec get(atom) :: any
  def get(key) do
    :gen_server.call(@server, { :get, key })
  end

  @doc """
  Accepts atoms as key and sub-key and returns the associated value, if any.

  Example:

  Given this configuration `[my_app: [key1: 42]]`:

      iex> Confit.get(:my_app, :key1)
      42
  """
  @spec get(atom, atom) :: any
  def get(key, sub_key) do
    :gen_server.call(@server, { :get, key, sub_key })
  end

  @doc """
  Reloads a previously loaded configuration file from disk.
  """
  @spec reload() :: :ok | { :error, any }
  def reload() do
    :gen_server.call(@server, :reload)
  end

  @doc """
  Loads the configuration file specified with `path` from disk.
  """
  @spec load(String.t) :: :ok | { :error, any }
  def load(path) do
    :gen_server.call(@server, { :load, path })
  end
end
