
  
  
  

# Authorizer

  

A CLI written in Elixir that authorizes transactions for a specific account after a

  

series of predefined rules.
  

  

## Features

  

  

1. Account creation

2. Get account balance

3. Account Deposit

5. Account withdraw

7. Transfer between accounts
  

  
## Setup

  

  

Local Setup

  

  

-  ```$ make setup```

  

  

#### Docker Compose

  

  

Assuming you already have Docker and Docker Compose installed, run the command below.

  

  

-  ```$ make build_container```

  

  

## Tests

  

  

Tests can be be executed:

  

  

Local:

  

  

-  ```$ mix test```

  

  

Docker:

  

-  ```$ docker-compose run app mix test```

  

  

## Execution

  

Local:

  

-  ``` $ make run```

  

  

Docker:

  

-  ``` $ docker-compose run app mix run --no-halt```
  
  

## External libs

- [Poison](https://github.com/devinus/poison) -> decode map to json to json
  

- [Credo](https://github.com/rrrene/credo) -> Code static code analysis;

- [plug_cowboy](https://github.com/elixir-plug/plug_cowboy) -> A Plug Adapter for the Erlang Cowboy web server.

- [Dialyzer](https://github.com/jeremyjh/dialyxir) -> Code static code analysis.
 
- [con_cache](https://github.com/sasa1977/con_cache) -> Concurrent Cache to hold state
