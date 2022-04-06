defmodule EbanxFinancialWeb.Endpoint do
  use Plug.Router
  use Plug.Debugger
  use Plug.ErrorHandler

  alias Plug.Adapters.Cowboy2

  require Logger

  plug(Plug.Logger, log: :debug)
  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)
  plug(EbanxFinancialWeb.Router)

  def start_link(_opts) do
    with {:ok, [port: port] = config} <- config() do
      Logger.info("Starting server at http://localhost:#{port}/")
      Cowboy2.http(__MODULE__, [], config)
    end
  end

  @spec child_spec(any) :: %{
          id: EbanxFinancialWeb.Endpoint,
          start: {EbanxFinancialWeb.Endpoint, :start_link, [...]}
        }
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  match _ do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(302, redirect_body())
  end

  defp redirect_body do
    ~S(<html><body>You are being <a href=")
    |> Kernel.<>(~S(">redirected</a>.</body></html>))
  end

  defp config, do: Application.fetch_env(:ebanx_server, __MODULE__)

  def handle_errors(%{status: status} = conn, %{kind: _kind, reason: _reason, stack: _stack}),
    do: send_resp(conn, status, "Something went wrong")
end
