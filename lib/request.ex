defmodule Request do
  defstruct method: "", path: "", body: "", timestamp: nil, key: nil, secret: nil, signature: nil

  require HTTPotion
  require Poison
  
  def new(method, path, body, key, secret, server_time) do
    if !(Enum.member? [:GET, :POST, :PUT, :PATCH, :DELETE], method), do: raise ArgumentError, message: "Unrecognized HTTP method #{method}"

    base_url      = "api.coinbase.com/v2"
    full_path     = base_url <> path
    request       = %Request{
        method: method,
        path: full_path,
        body: body,
        key: key,
        secret: secret,
        timestamp: server_time,
        signature: nil,
    }

    Request.sign(request)
  end

  def sign(request) do
    pre_hash =
      Integer.to_string(request.timestamp) <>
      Atom.to_string(request.method) <>
      request.path <>
      request.body

    signature =
      :crypto.hmac(:sha256, request.secret, pre_hash) |>
      Base.encode64

    %Request{
      method: request.method,
      path: request.path,
      key: request.key,
      secret: request.secret,
      timestamp: request.timestamp,
      signature: signature
    }
  end
  
  def send!(request) do
    payload = [
      body: request.body,
      follow_redirects: true,
      headers:
      [
        "CB-ACCESS-KEY": request.key,
        "CB-ACCESS-SIGN": request.signature,
        "CB-ACCESS-TIMESTAMP": request.timestamp,
        "Content-Type": "application/json",
      ]
    ]
    case request.method do
      :GET ->
        HTTPotion.get request.path, payload
      :POST ->
        HTTPotion.post request.path, payload
      :PUT ->
        HTTPotion.put request.path, payload
      :PATCH ->
        HTTPotion.patch request.path, payload
      :DELETE ->
        HTTPotion.delete request.path, payload
      _ ->
        raise "Unrecognized HTTP verb '#{request.method}'"
    end
  end
  
  def server_time do
    response = Poison.decode! HTTPotion.get("https://api.coinbase.com/v2/time").body
    response["data"]["epoch"]
  end
end
