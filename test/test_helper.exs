ExUnit.start

Mix.Task.run "ecto.create", ~w(-r AppPrototype.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r AppPrototype.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(AppPrototype.Repo)

