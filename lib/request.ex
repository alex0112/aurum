defmodule Request do
  defstruct method: "", path: "", body: "", timestamp: nil, signature: nil

  require HTTPotion
  require Poison
  
  def new(method, path, body) do
    if !(Enum.member? [:GET, :POST, :PUT, :PATCH, :DELETE], method), do: raise ArgumentError
    request = %Request{method: method, path: path, body: body, timestamp: Request.server_time, signature: nil}
    signed_request = Request.sign!(request, 'TODO: get secret from env')
  end

  defp sign!(request, secret) do
    pre_hash = request.timestamp <> request.method <> request.path <> request.body
    signature = :crypto.hmac(:sha256, secret, pre_hash) |> Base.encode16 |> String.downcase
    %Request{method: request.method, path: request.path, timestamp: request.timestamp, signature: signature}
  end
    
  def send!(request) do
    payload = [
      body: request.body,
      headers:
      [
        "CB-ACCESS-KEY": "TODO: get key from env",
        "CB-ACCESS-SIGN": String.new(request.signature),
        "CB-ACCESS-TIMESTAMP": request.timestamp,
        "Content-Type": "application/json",
      ]
    ]

    case request.method do
      :GET ->
        HTTPotion.get request.path, payload
      :POST ->
        HTTPotion.post request.path, payload
      _ ->
        raise "Method not yet implemented"
    end
  end
  
  defp server_time do
    response = Poison.decode! HTTPotion.get("https://api.coinbase.com/v2/time").body
    response["data"]["epoch"]
  end
end
