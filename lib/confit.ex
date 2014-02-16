defmodule Confit do
  use Application.Behaviour

  @server Confit.Server

  def start(_type, _args) do
    Confit.Supervisor.start_link
  end

  def get(key) do
    :gen_server.call(@server, { :get, key })
  end

  def get(key, sub_key) do
    :gen_server.call(@server, { :get, key, sub_key })
  end

  def reload() do
    :gen_server.call(@server, :reload)
  end

  def load(path) do
    :gen_server.call(@server, { :load, path })
  end

end
