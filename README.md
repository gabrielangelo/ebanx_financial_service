
  
  
  

# Ebanx Financial Service
A micro REST api written in elixir using only plug & cowboy


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


## External suit test
[address suit test](https://ipkiss.pragmazero.com/test?url=http%3A%2F%2Ffa52-2804-29b8-517d-2d8-3bed-407b-d8b1-b666.ngrok.io&script=--%0D%0A%23+Reset+state+before+starting+tests%0D%0A%0D%0APOST+%2Freset%0D%0A%0D%0A200+OK%0D%0A%0D%0A%0D%0A--%0D%0A%23+Get+balance+for+non-existing+account%0D%0A%0D%0AGET+%2Fbalance%3Faccount_id%3D1234%0D%0A%0D%0A404+0%0D%0A%0D%0A%0D%0A--%0D%0A%23+Create+account+with+initial+balance%0D%0A%0D%0APOST+%2Fevent+%7B%22type%22%3A%22deposit%22%2C+%22destination%22%3A%22100%22%2C+%22amount%22%3A10%7D%0D%0A%0D%0A201+%7B%22destination%22%3A+%7B%22id%22%3A%22100%22%2C+%22balance%22%3A10%7D%7D%0D%0A%0D%0A%0D%0A--%0D%0A%23+Deposit+into+existing+account%0D%0A%0D%0APOST+%2Fevent+%7B%22type%22%3A%22deposit%22%2C+%22destination%22%3A%22100%22%2C+%22amount%22%3A10%7D%0D%0A%0D%0A201+%7B%22destination%22%3A+%7B%22id%22%3A%22100%22%2C+%22balance%22%3A20%7D%7D%0D%0A%0D%0A%0D%0A--%0D%0A%23+Get+balance+for+existing+account%0D%0A%0D%0AGET+%2Fbalance%3Faccount_id%3D100%0D%0A%0D%0A200+20%0D%0A%0D%0A--%0D%0A%23+Withdraw+from+non-existing+account%0D%0A%0D%0APOST+%2Fevent+%7B%22type%22%3A%22withdraw%22%2C+%22origin%22%3A%22200%22%2C+%22amount%22%3A10%7D%0D%0A%0D%0A404+0%0D%0A%0D%0A--%0D%0A%23+Withdraw+from+existing+account%0D%0A%0D%0APOST+%2Fevent+%7B%22type%22%3A%22withdraw%22%2C+%22origin%22%3A%22100%22%2C+%22amount%22%3A5%7D%0D%0A%0D%0A201+%7B%22origin%22%3A+%7B%22id%22%3A%22100%22%2C+%22balance%22%3A15%7D%7D%0D%0A%0D%0A--%0D%0A%23+Transfer+from+existing+account%0D%0A%0D%0APOST+%2Fevent+%7B%22type%22%3A%22transfer%22%2C+%22origin%22%3A%22100%22%2C+%22amount%22%3A15%2C+%22destination%22%3A%22300%22%7D%0D%0A%0D%0A201+%7B%22origin%22%3A+%7B%22id%22%3A%22100%22%2C+%22balance%22%3A0%7D%2C+%22destination%22%3A+%7B%22id%22%3A%22300%22%2C+%22balance%22%3A15%7D%7D%0D%0A%0D%0A--%0D%0A%23+Transfer+from+non-existing+account%0D%0A%0D%0APOST+%2Fevent+%7B%22type%22%3A%22transfer%22%2C+%22origin%22%3A%22200%22%2C+%22amount%22%3A15%2C+%22destination%22%3A%22300%22%7D%0D%0A%0D%0A404+0%0D%0A%0D%0A)
