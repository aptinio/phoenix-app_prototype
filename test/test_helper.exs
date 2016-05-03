{:ok, _} = Application.ensure_all_started(:hound)
ExUnit.start(max_cases: 2)
Ecto.Adapters.SQL.Sandbox.mode(AppPrototype.Repo, :manual)
