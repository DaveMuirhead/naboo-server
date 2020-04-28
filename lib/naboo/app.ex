defmodule Naboo.App do
  use Commanded.Application,
      otp_app: :naboo,
      event_store: [
        adapter: Commanded.EventStore.Adapters.EventStore,
        event_store: Naboo.EventStore
      ]
end

