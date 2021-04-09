defmodule Request do
  defstruct(
    method: "",
    path: "",
    base: "",
    body: "",
    timestamp: nil,
    key: nil,
    secret: nil,
    signature: nil
  )

  require HTTPotion
  require Poison
  
  def new(method, path, body, key, secret, server_time) do
    if !(Enum.member? [:GET, :POST, :PUT, :PATCH, :DELETE], method), do: raise ArgumentError, message: "Unsupported HTTP method #{method}"
    base_url      = "https://api.coinbase.com/v2"
    request       =
      %Request{
        method:    method,
        path:      path,
        body:      body,
        base:      base_url,
        key:       key,
        secret:    secret,
        timestamp: server_time,
        signature: nil,
    }

    Request.sign(request)
  end

  def sign(request) do ## See https://docs.pro.coinbase.com/?ruby#signing-a-message
    pre_hash =
      Integer.to_string(request.timestamp) <>
      Atom.to_string(request.method)       <>
      "/v2/" <> request.path               <>
      request.body

    decoded_secret = request.secret |> Base.decode64! |> String.trim
    signature      = :crypto.hmac(:sha256, decoded_secret, pre_hash) |>
                                                       Base.encode64 |>
                                                       String.trim
    %Request{request | signature: signature}
  end
  
  def send!(request) do
    payload = [
      body:             request.body,
      follow_redirects: true,
      headers:
      [
        "CB-ACCESS-KEY": request.key,
        "CB-ACCESS-SIGN": request.signature,
        "CB-ACCESS-TIMESTAMP": request.timestamp,
        "CB-VERSION": "2019-07-11",
        "Content-Type": "application/json",
      ]
    ]

    case request.method do
      :GET ->
        HTTPotion.get request.base <> request.path, payload
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
