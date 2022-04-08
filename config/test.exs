import Config

config :ebanx_financial_service, EbanxFinancialService.ConCacheRepo,
  repo_name: :con_cache_repo_test

config :logger, :console,
  format: "$metadata[$level] $message\n",
  metadata: [:error]

# Configures all loggers, not just the console,
# as the console isn't used in tests when capture_log is active.
Logger.configure(level: :info)
