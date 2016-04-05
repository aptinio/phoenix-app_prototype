defmodule AppPrototype.AcceptanceCase do
  use ExUnit.CaseTemplate
  use Hound.Helpers

  using do
    quote do
      use Hound.Helpers

      import Ecto.Model
      import Ecto.Query, only: [from: 2, last: 2]
      import AppPrototype.Router.Helpers
      import AppPrototype.AcceptanceCase

      alias AppPrototype.Repo

      @endpoint AppPrototype.Endpoint
    end
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(AppPrototype.Repo)
    Hound.start_session
    navigate_to(Phoenix.Ecto.SQL.Sandbox.path_for(AppPrototype.Repo, self()))
    :ok
  end
end
