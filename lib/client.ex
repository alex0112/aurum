defmodule Client do
  
  require Poison
  require HTTPotion
  require Request
    
  defstruct api_key: "", api_secret: ""

  def new(api_key, api_secret) do
    %Client{api_key: api_key, api_secret: api_secret}
  end

  def server_time do
    response = Poison.decode! HTTPotion.get("https://api.coinbase.com/v2/time").body
    response["data"]["epoch"]
  end
  
end

