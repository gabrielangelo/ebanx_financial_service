defmodule Core.Accounts do
  @moduledoc false

  alias EbanxFinancialService.Repo

  @spec get_account_by_id(account :: map) :: {:ok, map()} | {:not_found, String.t()}
  def get_account_by_id(100), do: {:ok, @fixed_account}
  def get_account_by_id(_), do: {:not_found, "account doesnt exists"}

end
