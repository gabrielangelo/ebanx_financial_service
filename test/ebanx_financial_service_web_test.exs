defmodule EbanxFinancialService.EbanxFinancialWebTest do
  @moduledoc false
  use ExUnit.Case, async: true
  use Plug.Test

  alias EbanxFinancialService.ConCacheRepo, as: Repo
  alias EbanxFinancialService.Core.Accounts
  alias EbanxFinancialService.EbanxFinancialWeb.OperationsRouter, as: Router

  @opts Router.init([])

  setup do
    supervisor = EbanxFinancialService.Application.get_supervisor_name()
    Supervisor.terminate_child(supervisor, ConCache)
    Supervisor.restart_child(supervisor, ConCache)
    :ok
  end

  test "/reset route" do
    assert {:ok, %{"John" => "Doe", "id" => 550}} ==
             Repo.create("test_table", %{"John" => "Doe", "id" => 550})

    assert {:ok, %{"John" => "Doe", "id" => 550}} == Repo.get_by_id("test_table", 550)

    conn =
      :post
      |> conn("/reset")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == ""

    assert {:not_found, "resource with id 550 not found in table test_table"} ==
             Repo.get_by_id("test_table", 550)
  end

  test "Create account with initial balance" do
    conn =
      :post
      |> conn("/event", %{"type" => "deposit", "destination" => "100", "amount" => 10})
      |> put_req_header("accept", "application/json")
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert Poison.decode!(conn.resp_body) == %{"destination" => %{"balance" => 20, "id" => 100}}
  end

  test "Deposit into existing account" do
    Accounts.create_account(%{"id" => 150, "balance" => 50})

    conn =
      :post
      |> conn("/event", %{"type" => "deposit", "destination" => "150", "amount" => 10})
      |> put_req_header("accept", "application/json")
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert Poison.decode!(conn.resp_body) == %{"destination" => %{"balance" => 60, "id" => 150}}
  end

  test "Get balance for non-existing account" do
    conn =
      :get
      |> conn("/balance?account_id=100")
      |> put_req_header("accept", "application/json")
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "0"
  end

  test "Get balance for existing account" do
    Accounts.create_account(%{"id" => 400, "balance" => 50})

    conn =
      :get
      |> conn("/balance?account_id=400")
      |> put_req_header("accept", "application/json")
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "50"
  end

  test "Withdraw from non-existing account" do
    conn =
      :post
      |> conn("/event", %{"type" => "withdraw", "destination" => "100", "amount" => 10})
      |> put_req_header("accept", "application/json")
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "Withdraw from existing account" do
    Accounts.create_account(%{"id" => 150, "balance" => 50})
    conn =
      :post
      |> conn("/event", %{"type" => "withdraw", "origin" => "150", "amount" => 5})
      |> put_req_header("accept", "application/json")
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
    assert Poison.decode!(conn.resp_body) == %{"origin" => %{"id" => 150, "balance" => 45}}
  end

  test "Transfer from non-existing account" do
    conn =
      :post
      |> conn("/event", %{"type" => "withdraw", "origin" => "150", "amount" => 5})
      |> put_req_header("accept", "application/json")
      |> put_req_header("content-type", "application/json")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
