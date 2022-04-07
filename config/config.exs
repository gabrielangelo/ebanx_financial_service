use Mix.Config

config :ebanx_financial_service, EbanxFinancialWeb.Endpoint, port: 4000
config :ebanx_financial_service, EbanxFinancialService.ConCache.Repo, repo_name: :con_cache_repo

import_config "#{Mix.env()}.exs"
