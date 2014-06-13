defmodule Confort.Server do
  use GenServer
  import Record

  defrecordp :state, path: nil, conf: []

  def start_link() do
    :gen_server.start_link({ :local, __MODULE__ }, __MODULE__, [], [])
  end

  def init([]) do
    case Keyword.get(Mix.Project.config(), :conf_path) do
      nil ->
        { :ok, state() }
      path ->
        case load(path) do
          { :ok, conf } ->
            { :ok, state(path: path, conf: conf) }
          { :error, e } ->
            { :stop, { :error, e } }
        end
    end
  end

  def handle_call({ :get, key }, _from, state(conf: conf) = s) do
    { :reply, conf[key], s }
  end

  def handle_call({ :get, key, sub_key }, _from, state(conf: conf) = s) do
    { :reply, conf[key][sub_key], s }
  end

  def handle_call(:all, _from, state(conf: conf) = s) do
    { :reply, conf, s }
  end

  def handle_call(:reload, _from, state(path: path) = s) do
    case load(path) do
      { :ok, conf } ->
        { :reply, :ok, state(s, conf: conf) }
      error ->
        { :reply, error, s }
    end
  end

  def handle_call({ :load, path }, _from, s) do
    case load(path) do
      { :ok, conf } ->
        { :reply, :ok, state(path: path, conf: conf) }
      error ->
        { :reply, error, s }
    end
  end

 def load(path) do
   case File.read(path) do
     { :ok, bin } ->
       eval_conf_bin(bin)
     error ->
       error
   end
 end

 defp eval_conf_bin(bin) do
   case Code.string_to_quoted(bin) do
     { :ok, { :__block__, _, _ } } ->
       { :error, :bad_conf }
     { :ok, quoted } ->
       { conf, _bindings } = Code.eval_quoted(quoted)
       { :ok, conf }
     error ->
       error
   end
 end
end