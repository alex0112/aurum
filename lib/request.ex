defmodule Request do
  defstruct method: "", path: "", body: ""

  require HTTPotion
  
  def new(method, path, body) do
    if !(Enum.member? ["GET", "POST", "PUT", "PATCH", "DELETE"], method), do: raise ArgumentError
    %Request{method: method, path: path, body: body}
  end
  
  defp sign(request, secret, server_time) do
    pre_hash = Client.server_time <> request.method <> request.path <> request.body
    signature = :crypto.hmac(:sha256, secret, pre_hash) |> Base.encode16 |> String.downcase
  end
  
end
