defmodule Client do

  require Poison
  require HTTPotion

  def server_time do
    response = Poison.decode! HTTPotion.get("https://api.coinbase.com/v2/time").body
    response["data"]["epoch"]
  end
  
end
