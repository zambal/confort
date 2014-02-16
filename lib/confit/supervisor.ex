defmodule Confit.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Confit.Server, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
