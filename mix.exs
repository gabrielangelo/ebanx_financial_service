defmodule EbanxFinancialService.MixProject do
  use Mix.Project

  def project do
    [
      app: :ebanx_financial_service,
      aliases: aliases(),
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def aliases do
    [
      test_ci: [
        "test",
        "coveralls"
      ],
      code_review: [
        "dialyzer",
        "credo --strict"
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :plug_cowboy, :con_cache],
      mod: {EbanxFinancialService.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 5.0"},
      {:con_cache, "~> 0.13"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.12.3", only: :test}
    ]
  end
end
