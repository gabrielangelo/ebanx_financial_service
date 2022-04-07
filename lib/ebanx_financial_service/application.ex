defmodule EbanxFinancialService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: EbanxFinancialService.Supervisor]
    Supervisor.start_link(childrens(), opts)
  end

  defp childrens do
    [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: EbanxFinancialService.EbanxFinancialWeb.Endpoint,
        options: [port: http_port()]
      ),
      {ConCache, [name: repo_name(), ttl_check_interval: false]}
    ]
  end

  defp http_port do
    :ebanx_financial_service
    |> Application.fetch_env!(EbanxFinancialService.EbanxFinancialWeb.Endpoint)
    |> Keyword.fetch!(:port)
  end

  defp repo_name do
    :ebanx_financial_service
    |> Application.fetch_env!(EbanxFinancialService.Repo)
    |> Keyword.get(:repo_name)
  end
end
