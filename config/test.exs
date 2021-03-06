use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :app_prototype, AppPrototype.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :app_prototype, AppPrototype.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "app_prototype_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :app_prototype, sql_sandbox: true

config :comeonin, :bcrypt_log_rounds, 4
