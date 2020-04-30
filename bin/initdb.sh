#!/bin/bash
mix do deps.get, deps.compile, event_store.create, event_store.init, ecto.create, ecto.migrate
