#!/bin/bash
pgstop.sh; docker volume rm naboo-server_data; pgstart.sh; mix do clean, compile, ecto.init

