shell:
	@iex -S mix

run:
	@mix run --no-halt

deps:
	@mix deps.get

coveralls:
	@mix coveralls

setup:
	@mix do code_review, test_cli
	
build_container:
	@docker-compose build --no-cache
	@docker-compose up

init:
	@docker-compose -f docker-compose.yaml up