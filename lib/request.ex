defmodule Request do
  defstruct method: "", path: "", body: "", agent: nil

  require HTTPotion
  require Poison
  
  def new(method, path, body) do
    if !(Enum.member? ["GET", "POST", "PUT", "PATCH", "DELETE"], method), do: raise ArgumentError
    
    request = %Request{method: method, path: path, body: body}
    signed_request = Request.sign!(request, 'TODO: get secret from env', Request.server_time)
    
  end

  defp server_time do
    response = Poison.decode! HTTPotion.get("https://api.coinbase.com/v2/time").body
    response["data"]["epoch"]
  end

  
  defp sign!(request, secret, server_time) do
    pre_hash = server_time <> request.method <> request.path <> request.body
    signature = :crypto.hmac(:sha256, secret, pre_hash) |> Base.encode16 |> String.downcase
  end
  
end

