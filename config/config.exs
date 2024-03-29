# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :qpt_tax_agent,
  ecto_repos: [QptTaxAgent.Repo]

# Configures the endpoint
config :qpt_tax_agent, QptTaxAgentWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HUmz+vtIlTgvLomduqYsC0CGfmiV0KpJ7J1WZ6uGjkMHDMsfJeD2Do44kYb5LYAh",
  render_errors: [view: QptTaxAgentWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: QptTaxAgent.PubSub,
  live_view: [signing_salt: "AoQlBX8F"]

config :gettext, :default_locale, "vi"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
