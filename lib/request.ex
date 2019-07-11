defmodule Request do
  defstruct method: "", path: "", body: "", timestamp: nil, signature: nil

  require HTTPotion
  require Poison
  
  def new(method, path, body) do
    if !(Enum.member? [:GET, :POST, :PUT, :PATCH, :DELETE], method), do: raise ArgumentError
    request = %Request{method: method, path: path, body: body, timestamp: Request.server_time, signature: nil}
    signed_request = Request.sign!(request, "TODO: Get secret")
  end

  def sign!(request, secret) do
    pre_hash = Integer.to_string(request.timestamp) <> Atom.to_string(request.method) <> request.path <> request.body
    signature = :crypto.hmac(:sha256, secret, pre_hash) |> Base.encode16 |> String.downcase
    %Request{method: request.method, path: request.path, timestamp: request.timestamp, signature: signature}
  end
    
  def send!(request) do
    base_url = "https://api.coinbase.com"
    payload = [
      body: request.body,
      headers:
      [
        "CB-ACCESS-KEY": "TODO: get key",
        "CB-ACCESS-SIGN": request.signature,
        "CB-ACCESS-TIMESTAMP": request.timestamp,
        "Content-Type": "application/json",
      ]
    ]
    IO.puts base_url <> request.path
    case request.method do
        
      :GET ->
        HTTPotion.get base_url <> request.path, payload
      :POST ->
        HTTPotion.post base_url <> request.path, payload
      _ ->
        raise "Method not yet implemented"
    end
  end
  
  def server_time do
    response = Poison.decode! HTTPotion.get("https://api.coinbase.com/v2/time").body
    response["data"]["epoch"]
  end
end
