# Use an official Elixir runtime as a parent image
FROM elixir:latest

RUN apt-get update && \
    mix do local.hex --force, local.rebar --force

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# RUN cd assets && npm install
# Install hex package manager
RUN mix local.hex --force

# Compile the project
RUN mix do deps.get
RUN MIX_ENV=test mix test
RUN mix run --no-halt