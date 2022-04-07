defmodule Core.Accounts do
  @moduledoc false

  def get_account_by_id(id) do
  end

  def get_account_by_id(_), do: {:not_found, "account doesnt exists"}
end
