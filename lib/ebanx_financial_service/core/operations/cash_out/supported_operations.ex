defmodule EbanxFinancialService.Core.Operations.CashOut.SupportedOperations do
  @moduledoc false
  @valid_types ~w<transfer withdraw>

  def valid_operations, do: @valid_types
end
