defmodule EbanxFinancialService.Core.Accounts do
  @moduledoc false
  alias EbanxFinancialService.ConCacheRepo
  @table "accounts"

  @spec get_account_by_id(integer) :: {:not_found, String.t()} | {:ok, map}
  def get_account_by_id(id), do: ConCacheRepo.get_by_id(@table, id)

  def update_account(id, account), do: ConCacheRepo.update_with_row_lock(@table, id, account)

  def create_account(account), do: ConCacheRepo.create(@table, account)

  def get_or_create(id, account) do
    id
    |> get_account_by_id()
    |> case do
      {:not_found, _} ->
        create_account(%{account | "balance" => 0})

      {:ok, _} = result ->
        result
    end
  end
end
