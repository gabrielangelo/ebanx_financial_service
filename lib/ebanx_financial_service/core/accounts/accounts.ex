defmodule Core.Accounts do
  @moduledoc false
  alias EbanxFinancialService.ConCacheRepo
  @table "accounts"

  @spec get_account_by_id(integer) :: {:not_found, String.t()} | {:ok, map}
  def get_account_by_id(id), do: ConCacheRepo.get_by_id(@table, id)

  def update_account(id, data), do: ConCacheRepo.update_with_row_lock(@table, id, data)

  def create_account(data), do: ConCacheRepo.create(@table, data)

  def get_or_create(id, data) do
    id
    |> get_account_by_id()
    |> case do
      {:not_found, _} -> create_account(data)
      account -> account
    end
  end
end
