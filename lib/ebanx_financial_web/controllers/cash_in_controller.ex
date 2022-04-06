defmodule EbanxFinancialWeb.FinancialEventsController do
  @moduledoc false
  alias Core.Operations.CashIn

  def create(_conn, params), do: CashIn.create(params)
end
