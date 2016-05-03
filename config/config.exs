# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :app_prototype, AppPrototype.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "93hsPx9ulGRAke/KX9RkU4xUraSIsxhEeD5Ptgu7Ii9XjYELFa6EYoWUXXygQhoI",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: AppPrototype.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

config :hound, driver: "chrome_driver"

config :ueberauth, Ueberauth,
  providers: [
    identity: {Ueberauth.Strategy.Identity, [
      callback_methods: ["POST"]
    ]}
  ]

config :guardian, Guardian,
  issuer: "AppPrototype",
  ttl: {30, :days},
  verify_issuer: true,
  secret_key: "hEx2L+DkIr125xxVRajGJA6rmjE2Tr71NOc0PL5/eyB/ayGr9GKy45R4aGneuh0B",
  serializer: AppPrototype.GuardianSerializer

config :app_prototype, ecto_repos: [AppPrototype.Repo]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
