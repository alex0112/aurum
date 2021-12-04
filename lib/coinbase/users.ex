defmodule Aurum.Coinbase.User do

  alias Aurum.Coinbase, as: Coinbase

  defstruct [
    :id,
    :name,
    :username,
    :profile_location,
    :profile_bio,
    :profile_url,
    :avatar_url,
    :resource,
    :resource_path,
    :time_zone,
    :native_currency,
    :bitcoin_unit,
    :country,
    :created_at,
    :email
  ]

  alias __MODULE__, as: User
  alias Poison, as: Poison

  @spec fetch() :: %User{}
  def fetch do
    Coinbase.get("/v2/user")
  end

end
