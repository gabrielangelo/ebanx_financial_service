defmodule Core.Operations.CashIn.SupportedOperations do
  @moduledoc false

  @valid_types ~w<deposit>

  def valid_operations, do: @valid_types
end
