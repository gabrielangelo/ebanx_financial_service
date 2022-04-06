defmodule EbanxFinancialWeb.CashOutController do
  alias Core.Operations.CashOut

  def create(_conn, params), do: CashOut.create(params)
end
