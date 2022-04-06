defmodule EbanxFinancialWeb.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  @content_type "application/json"

  get "/reset" do
    conn
    |> put_resp_content_type(@content_type)
    |> send_resp(200, "")
  end

  match _ do
    send_resp(conn, 404, "Requested page not found!")
  end
end
