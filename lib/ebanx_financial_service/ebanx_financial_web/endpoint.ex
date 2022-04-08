defmodule EbanxFinancialService.EbanxFinancialWeb.Endpoint do
  use Plug.Router
  use Plug.Debugger
  use Plug.ErrorHandler

  alias Plug.Adapters.Cowboy2

  require Logger
  @content_type "application/json"

  plug(Plug.Logger, log: :debug)
  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: [@content_type],
    json_decoder: Poison
  )

  plug(:dispatch)
  forward("/", to: EbanxFinancialService.EbanxFinancialWeb.OperationsRouter)

  def start_link(_opts) do
    with {:ok, [port: port] = config} <- config() do
      Logger.info("Starting server at http://localhost:#{port}/")
      Cowboy2.http(__MODULE__, [], config)
    end
  end

  @spec child_spec(any) :: %{
          id: EbanxFinancialService.EbanxFinancialWeb.Endpoint,
          start: {EbanxFinancialService.EbanxFinancialWeb.Endpoint, :start_link, [...]}
        }
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  defp config, do: Application.fetch_env(:ebanx_server, __MODULE__)
end
