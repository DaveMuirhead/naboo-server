defmodule Naboo.MixProject do
  use Mix.Project

  def project do
    [
      app: :naboo,
      version: "0.1.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Naboo.Application, []},
      extra_applications: [
        :eventstore,
        :guardian,
        :os_mon,
#        :ueberauth_auth0
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Phoenix core
      {:phoenix, "~> 1.4.17"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},

      # Monitoring
      {:phoenix_live_dashboard, "~> 0.2.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},

      # Persistence / CQRS+ES
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:commanded, "~> 1.0.1"},
      {:commanded_eventstore_adapter, "~> 1.0"},
      {:commanded_ecto_projections, "~> 1.0"},
      {:eventstore, "~> 1.0.2"},
      {:exconstructor, "~> 1.1"},
      {:vex, "~> 0.8"},

      # Security
      {:bcrypt_elixir, "~> 1.0"},
      {:comeonin, "~> 4.0"},
      {:guardian, "~> 2.0"},
      {:cors_plug, "~> 2.0"},

      # Email
      {:bamboo, "~> 1.4"},
      {:bamboo_smtp, "~> 2.1.0"},

      # File Upload
      {:arc, "~> 0.11.0"},

      # Utilities
      {:elixir_uuid, "~> 1.2"},
      {:poison, "~> 3.1"},

      # Testing
      {:ex_machina, "~> 2.4", only: :test},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "event_store.init": ["event_store.drop", "event_store.create", "event_store.init"],
      "ecto.init": ["ecto.drop", "ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      reset: ["event_store.init", "ecto.init"],
      test: ["reset", "test"]
    ]
  end

end
