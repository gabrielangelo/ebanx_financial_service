defmodule EbanxFinancialService.EbanxFinancialWeb.EventView do
  alias EbanxFinancialService.Core.Operations.{
    CashIn,
    CashOut
  }

  @cash_out_valid_operations CashOut.SupportedOperations.valid_operations()
  @cash_in_valid_operations CashIn.SupportedOperations.valid_operations()

  def render({:ok, %{"type" => type} = event_data}) when type in @cash_in_valid_operations do
    debited_account = event_data["debited_account"]

    {:ok,
     %{"destination" => %{"id" => debited_account["id"], "balance" => debited_account["balance"]}}}
  end

  def render({:ok, %{"type" => type} = event_data}) when type in @cash_out_valid_operations do
    debited_account = event_data["debited_account"]

    {:ok,
     %{"origin" => %{"id" => debited_account["id"], "balance" => debited_account["balance"]}}}
  end
end
