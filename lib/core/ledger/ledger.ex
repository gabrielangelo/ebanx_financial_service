defmodule Core.Ledger do
  @moduledoc false

  alias Core.Operations.CashIn.SupportedOperations, as: CashInSupportedOperations
  alias Core.Operations.CashOut.SupportedOperations, as: CashOutSupportedOperations

  def execute(account, %{"type" => type} = operation) do
    cond do
      type in CashInSupportedOperations.valid_operations() ->
        do_in(account, operation)

      type in CashOutSupportedOperations.valid_operations() ->
        do_out(account, operation)

      true ->
        {:error, :invalid_operation_type}
    end
  end

  defp do_in(_, %{"amount" => amount}) when amount < 0,
    do: {:error, :amount_cannot_be_negative}

  defp do_in(account, operation) do
    %{account | "balance" => account["balance"] + operation["amount"]}
  end

  defp do_out(account, operation) do
    operation_amount = operation["amount"]

    if has_funds?(account, operation_amount) do
      {:ok, %{account | "balance" => account["balance"] - operation_amount}}
    else
      {:error, :insuficient_funds}
    end
  end

  defp has_funds?(%{"balance" => balance}, amount) when amount <= balance, do: true
  defp has_funds?(_, _), do: false
end
