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
      {:ok, _} = response ->
        response
        |> EventView.render()
        |> handle_response(conn, response_code: 201)

      response ->
        handle_response(response, conn)
    end
  end

  get "/balance/" do
    decode(conn.query_string)
    |> Map.get("account_id")
    |> Ledger.balance()
    |> handle_response(conn)
  end

  post "/reset" do
    supervisor = EbanxFinancialService.Application.get_supervisor_name()

    with :ok <- Supervisor.terminate_child(supervisor, ConCache),
         {:ok, _} <- Supervisor.restart_child(supervisor, ConCache) do
      handle_response({:ok, ""}, conn)
    end
  end

  defp handle_response(response, conn, opts \\ []) do
    response_code = Keyword.get(opts, :response_code)

    %{code: code, message: message} =
      case mount_message(response) do
        {:ok, message} ->
          %{code: response_code || 200, message: message}

        {:not_found, message} ->
          %{code: response_code || 404, message: message}

          # {:error, message} ->
          #   %{code: response_code || 400, message: message}
      end

    send_resp(conn, code, message)
  end

  defp mount_message({status, data}) when is_map(data), do: {status, Poison.encode!(data)}
  defp mount_message({status, data}) when is_integer(data), do: {status, Integer.to_string(data)}

  defp mount_message(response), do: response

  match _ do
    send_resp(conn, 404, "Requested page not found!")
  end
end
