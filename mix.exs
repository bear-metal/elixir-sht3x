defmodule SHT3x.MixProject do
  use Mix.Project

  def project do
    [
      app: :sht3x,
      version: "0.1.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/bear-metal/elixir-sht3x"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_ale, "~> 1.0"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description() do
    "Elixir driver for the SHT3x (SHT30, SHT31, SHT35) series temperature and humidity sensors from Sensirion."
  end

  defp package() do
    [
      # These are the default files included in the package
      files: ["lib", "mix.exs", "README*", "LICENSE"],
      maintainers: ["Erkki Eilonen"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/bear-metal/elixir-sht3x"}
    ]
  end
end