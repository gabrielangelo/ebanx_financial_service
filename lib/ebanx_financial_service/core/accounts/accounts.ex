defmodule EbanxFinancialService.Core.Accounts do
  @moduledoc false
  require Logger
  alias EbanxFinancialService.ConCacheRepo
  @table "accounts"

  @spec get_account_by_id(integer) :: {:not_found, String.t()} | {:ok, map}
  def get_account_by_id(id)do
    Logger.info("getting account by id: #{id}")
    ConCacheRepo.get_by_id(@table, id)
  end

  def update_account(id, account) do
    Logger.info("updating account #{id}")
    ConCacheRepo.update_with_row_lock(@table, id, account)
  end

  def create_account(account) do
    log_message = "creating account #{account["id"]}"
    Logger.info(log_message)
    ConCacheRepo.create(@table, account)
  end

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
