shell:
	@iex -S mix

run:
	@mix run --no-halt

deps:
	@mix deps.get

coveralls:
	@mix coveralls

setup:
	@mix do deps.get, code_review
	@MIX_ENV=test mix test_ci

run_tests: 
	@mix test_ci

build_container:
	@docker-compose build --no-cache
	@docker-compose up

init:
	@docker-compose -f docker-compose.yaml up