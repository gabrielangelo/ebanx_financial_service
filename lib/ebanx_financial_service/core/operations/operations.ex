defmodule Core.Operations do
  @moduledoc false

  alias Core.Operations.{CashIn, CashOut}
  alias Core.Operations.CashIn.SupportedOperations, as: CashInSupportedOperations
  alias Core.Operations.CashOut.SupportedOperations, as: CashOutSupportedOperations

  @cash_in_valid_operations CashInSupportedOperations.valid_operations()
  @cash_out_valid_operations CashOutSupportedOperations.valid_operations()

  @spec execute(map) ::
          {:error, String.t()}
          | {:not_found, String.t()}
          | {:ok, map}
  def execute(%{type: type} = operation) when type in @cash_in_valid_operations,
    do: CashIn.create(operation)

  def execute(%{type: type} = operation) when type in @cash_out_valid_operations,
    do: CashOut.create(operation)
end
