defmodule AppPrototype.ChannelCase do
  @moduledoc """
  This module defines the test case to be used by
  channel tests.

  Such tests rely on `Phoenix.ChannelTest` and also
  imports other functionality to make it easier
  to build and query models.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      use Phoenix.ChannelTest

      alias AppPrototype.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]


      # The default endpoint for testing
      @endpoint AppPrototype.Endpoint
    end
  end

  setup(tags) do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(AppPrototype.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(AppPrototype.Repo, {:shared, self()})
    end

    :ok
  end
end
