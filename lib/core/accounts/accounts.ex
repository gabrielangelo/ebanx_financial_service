defmodule Core.Accounts do
  @moduledoc false
  @fixed_account %{balance: 20, id: 100}

  @spec get_account_by_id(account :: map) :: {:ok, map()} | {:error, atom()}
  def get_account_by_id(100), do: {:ok, @fixed_account}
  def get_account_by_id(_), do: {:error, :account_doesnt_exists}
end
