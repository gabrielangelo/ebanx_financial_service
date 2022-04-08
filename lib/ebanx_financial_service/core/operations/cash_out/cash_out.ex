defmodule EbanxFinancialService.Core.Operations.CashOut do
  @moduledoc false

  alias EbanxFinancialService.Core.Accounts
  alias EbanxFinancialService.Core.Ledger
  alias EbanxFinancialService.Core.Operations.CashOut.SupportedOperations

  @spec create(map) ::
          {:error, String.t()}
          | {:not_found, String.t()}
          | {:ok, map()}
  def create(operation) do
    case get_account_by_type(operation) do
      {:error, _} = error -> error
      {:ok, account} -> do_create(operation, account)
    end
  end

  defp do_create(operation, account) do
    with true <- operation["type"] in SupportedOperations.valid_operations(),
         {:ok, account} <- Accounts.get_account_by_id(account),
         {:ok, account_debited} <- Ledger.execute_operation(account, operation) do
      {:ok, Map.put(operation, "debited_account", account_debited)}
    else
      {:error, _} = error -> error
      {:not_found, _} = error -> error
      false -> {:error, "invalid_operation_type"}
    end
  end

  defp get_account_by_type(%{"origin" => origin_account, "destination" => _, "type" => type})
       when type == "transfer",
       do: {:ok, origin_account}

  defp get_account_by_type(%{"destination" => destination_account}),
    do: {:ok, destination_account}

  defp get_account_by_type(%{"origin" => origin_account_id}), do: {:ok, origin_account_id}

  defp get_account_by_type(_), do: {:error, "invalid_request_data"}
end
