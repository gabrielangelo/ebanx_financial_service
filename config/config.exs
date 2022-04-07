use Mix.Config

config :ebanx_financial_service, EbanxFinancialService.EbanxFinancialWeb.Endpoint, port: 4000
config :ebanx_financial_service, EbanxFinancialService.ConCacheRepo, repo_name: :con_cache_repo

import_config "#{Mix.env()}.exs"
