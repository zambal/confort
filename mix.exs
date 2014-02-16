defmodule Confit.Mixfile do
  use Mix.Project

  def project do
    [ app: :confit,
      version: "0.0.1" ]
  end

  def application do
    [mod: { Confit, [] }]
  end
end
