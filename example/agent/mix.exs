defmodule SNNAgent.MixProject do
  use Mix.Project

  def project do
    [
      app: :agent,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SNNAgent.Application, []}
    ]
  end

  defp deps do
    [
      {:glowworm, path: "../.."}
    ]
  end
end
