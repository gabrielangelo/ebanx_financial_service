defmodule EbanxFinancialService.Core.Operations.CashOut do
  @moduledoc false

  alias EbanxFinancialService.Core.Accounts
  alias EbanxFinancialService.Core.Ledger
  alias EbanxFinancialService.Core.Operations.CashOut.SupportedOperations

  @spec create(map) ::
          {:error, String.t()}
          | {:not_found, String.t()}
          | {:ok, map()}
  def create(%{"type" => operation_type, "destination" => destination_account_id} = operation) do
    with true <- operation_type in SupportedOperations.valid_operations(),
         {:ok, account} <- Accounts.get_account_by_id(destination_account_id),
         {:ok, account_debited} <- Ledger.execute_operation(account, operation) do
      {:ok, Map.put(operation, "debited_account", account_debited)}
    else
      {:error, _} = error -> error
      {:not_found, _} = error -> error
      false -> {:error, "invalid_operation_type"}
    end
  end
end
