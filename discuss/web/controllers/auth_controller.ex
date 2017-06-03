defmodule Discuss.Authcontroller do
  use Discuss.Web, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do

  end
end
