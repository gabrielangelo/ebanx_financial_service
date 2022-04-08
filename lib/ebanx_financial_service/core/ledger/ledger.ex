defmodule EbanxFinancialService.Core.Ledger do
  @moduledoc false
  require Logger

  alias EbanxFinancialService.Core.Accounts

  alias EbanxFinancialService.Core.Operations.CashIn.SupportedOperations,
    as: CashInSupportedOperations

  alias EbanxFinancialService.Core.Operations.CashOut.SupportedOperations,
    as: CashOutSupportedOperations

  @spec execute_operation(map(), map) :: {:error, any} | {:ok, map}
  def execute_operation(account, %{"type" => type} = operation) do
    cond do
      type in CashInSupportedOperations.valid_operations() ->
        do_in(account, operation)

      type in CashOutSupportedOperations.valid_operations() ->
        do_out(account, operation)

      true ->
        {:error, "invalid_operation_type"}
    end
  end

  @spec balance(integer()) :: {:not_found, integer()} | {:ok, integer()}
  def balance(account_id) do
    account_id
    |> Accounts.get_account_by_id()
    |> case do
      {:ok, account} -> {:ok, account["balance"]}
      _ -> {:not_found, 0}
    end
  end

  defp do_in(_, %{"amount" => amount} = operation) when amount < 0 do
    Logger.error("error during cash in ledger operation", inspect(operation))
    {:error, "amount_cannot_be_negative"}
  end

  defp do_in(account, operation) do
    Logger.info("performing cash in ledger operation")
    increased_account = %{account | "balance" => account["balance"] + operation["amount"]}
    update_account(account, increased_account)
  end

  defp do_out(account, operation) do
    Logger.info("performing cash out ledger operation")

    operation_amount = operation["amount"]

    Logger.info("checking funds")

    if has_funds?(account, operation_amount) do
      Logger.info("account has funds")

      debited_account = %{account | "balance" => account["balance"] - operation_amount}
      update_account(account, debited_account)
    else
      Logger.error("account hasn't funds")

      {:error, "insuficient_funds"}
    end
  end

  defp update_account(account, data) do
    case Accounts.update_account(account["id"], data) do
      {:error, _} = error ->
        Logger.error("error during account update", inspect(error))
        error

      :ok ->
        Logger.info("account updated")
        {:ok, data}
    end
  end

  defp has_funds?(%{"balance" => balance}, amount) when amount <= balance, do: true
  defp has_funds?(_, _), do: false
end
