defmodule Core.Operations.CashIn do
  @moduledoc false

  alias Core.Accounts
  alias Core.CashIn.SupportedOperations
  alias Core.Ledger

  @spec create(map) ::
          false
          | {:error, :account_doesnt_exists | :insuficient_funds}
          | {:ok, map()}
          | map
  def create(%{"type" => operation_type, "destination" => destination_account_id} = operation) do
    with true <- operation_type in SupportedOperations.valid_operations(),
         {:ok, account} <- Accounts.get_account_by_id(destination_account_id),
         {:ok, account_debited} <- Ledger.execute(account, operation) do
      {:ok, account_debited, operation}
    else
      {:error, _} = error -> error
      false -> {:error, :invalid_operation_type}
    end
  end
end
