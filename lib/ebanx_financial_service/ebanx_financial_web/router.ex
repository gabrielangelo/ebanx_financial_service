defmodule EbanxFinancialService.EbanxFinancialWeb.OperationsRouter do
  @moduledoc false

  use Plug.Router
  alias EbanxFinancialService.Core.Operations
  alias EbanxFinancialService.Core.Ledger

  plug(:match)
  plug(:dispatch)

  post "/event" do
    conn.body_params
    |> Operations.execute()
    |> handle_response(conn)
  end

  get "/balance/" do
    conn.query_params
    |> Map.get(:account_id)
    |> Ledger.balance()
  end

  post "/reset" do
    supervisor = EbanxFinancialService.Application.get_supervisor_name()
    Supervisor.terminate_child(supervisor, ConCache)
  end

  defp handle_response(response, conn) do
    %{code: code, message: message} =
      case response do
        {:ok, message} -> %{code: 200, message: message}
        {:not_found, message} -> %{code: 404, message: message}
        {:error, message} -> %{code: 400, message: message}
      end

    send_resp(conn, code, message)
  end

  match _ do
    send_resp(conn, 404, "Requested page not found!")
  end
end
