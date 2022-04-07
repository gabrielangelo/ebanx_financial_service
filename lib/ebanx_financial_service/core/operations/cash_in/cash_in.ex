defmodule Core.Operations.CashIn do
  @moduledoc false

  alias Core.Accounts
  alias Core.Ledger
  alias Core.Operations.CashIn.SupportedOperations

  @spec create(map) ::
          {:error, String.t()}
          | {:not_found, String.t()}
          | {:ok, map()}
  def create(%{"type" => operation_type, "destination" => destination_account_id} = operation) do
    with true <- operation_type in SupportedOperations.valid_operations(),
         {:ok, account} <-
           Accounts.get_or_create(destination_account_id, mount_account(operation)),
         {:ok, account_debited} <- Ledger.execute_operation(account, operation) do
      {:ok, Map.put(operation, "debited_account", account_debited)}
    else
      {:error, _} = error -> error
      {:not_found, _} = error -> error
      false -> {:error, "invalid_operation_type"}
    end
  end

  defp mount_account(operation) do
    %{
      "id" => operation["destination"],
      "balance" => operation["amount"]
    }
  end
end
