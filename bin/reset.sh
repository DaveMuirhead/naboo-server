#!/bin/bash
pgstop.sh; docker volume rm naboo-server_data; pgstart.sh; mix do clean, compile, event_store.init, ecto.init

