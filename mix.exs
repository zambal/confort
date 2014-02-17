defmodule Confort.Mixfile do
  use Mix.Project

  def project do
    [ app: :confort,
      version: "0.0.1" ]
  end

  def application do
    [mod: { Confort, [] }]
  end
end
