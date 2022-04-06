use Mix.Config

config :ebanx_financial_service, EbanxFinancialWeb.Endpoint, port: 4000

import_config "#{Mix.env()}.exs"
