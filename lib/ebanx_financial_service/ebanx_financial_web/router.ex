defmodule EbanxFinancialService.EbanxFinancialWeb.OperationsRouter do
  @moduledoc false

  alias EbanxFinancialService.Core.{
    Ledger,
    Operations
  }

  alias EbanxFinancialService.EbanxFinancialWeb.EventView
  import Plug.Conn.Query, only: [decode: 1]

  use Plug.Router
  plug(:match)
  plug(:dispatch)

  post "/event" do
    conn.body_params
    |> Operations.execute()
    |> case do
      {:ok, data} -> send_resp(conn, 201, Poison.encode!(EventView.render(data)))
      {:not_found, _} -> send_resp(conn, 404, "0")
    end
  end

  get "/balance/" do
    conn.query_string
    |> decode()
    |> Map.get("account_id")
    |> Ledger.balance()
    |> case do
      {:ok, balance} -> send_resp(conn, 200, Integer.to_string(balance))
      {:not_found, _} -> send_resp(conn, 404, "0")
    end
  end

  post "/reset" do
    supervisor = EbanxFinancialService.Application.get_supervisor_name()

    with :ok <- Supervisor.terminate_child(supervisor, ConCache),
         {:ok, _} <- Supervisor.restart_child(supervisor, ConCache) do
      send_resp(conn, 200, "OK")
    end
  end

  match _ do
    send_resp(conn, 404, "Requested page not found!")
  end
end
