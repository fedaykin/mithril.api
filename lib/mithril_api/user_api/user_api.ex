defmodule Mithril.Web.UserAPI do
  @moduledoc """
  The boundary for the UserAPI system.
  """

  use Mithril.Search

  import Ecto.{Query, Changeset}, warn: false
  alias Mithril.Repo

  alias Mithril.Web.UserAPI.User

  def list_users(params) do
    User
    |> filter_by_email(params)
    |> search(params, 50)
  end

  defp filter_by_email(query, %{"email" => email}) when is_binary(email) do
    where(query, [r], r.email == ^email)
  end
  defp filter_by_email(query, _), do: query

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> user_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> user_changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    user_changeset(user, %{})
  end

  defp user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :settings])
    |> validate_required([:email, :password])
  end
end
