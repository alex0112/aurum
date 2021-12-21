defmodule Aurum.Coinbase.ClientTest do
  use ExUnit.Case
  doctest Aurum.Coinbase.Client

  alias Aurum.Coinbase.Client, as: Client
  alias Tesla

  describe "new/6" do
    test "generates a new client with the correct middleware" do
      middleware_fun = fn _method, _path, _body -> [{:middleware, :here}] end
      client         = Client.new("method", "/path", "body", middleware_fun)

      assert client.pre == [{:middleware, :call, [:here]}] ## {ModuleName, :call, [:options]} is how Tesla represents this
    end
  end

  describe "middleware/5" do

    test "correctly inserts the base url" do
      base_url        = "https://api.example.com/v2"
      headers_fun     = fn _method, _path, _body -> "<headers>" end
      middleware_list = Client.middleware("", "", "", base_url, headers_fun)

      assert ({Tesla.Middleware.BaseUrl, base_url} in middleware_list)
    end

    test "correctly inserts the headers" do
      base_url        = "https://api.example.com/v2"
      headers_fun     = fn _method, _path, _body -> "<headers>" end
      middleware_list = Client.middleware("", "", "", base_url, headers_fun)

      assert {Tesla.Middleware.Headers, headers_fun.(nil, nil, nil)} in middleware_list
    end
end

  describe "headers/6" do
    
    test "generates headers given the key, timestamp, and a signature function" do
      key_fun       = fn -> "<key>" end
      timestamp_fun = fn -> "<timestamp>" end
      sign_fun      = fn _method, _path, _body, _timestamp -> "<signature>" end
      method        = "GET"
      path          = "/api"
      body          = ""

      assert Client.headers(method, path, body, key_fun, sign_fun, timestamp_fun) ==
	[
	  {"CB-ACCESS-KEY",       key_fun.()},
	  {"CB-ACCESS-SIGN",      sign_fun.(nil, nil, nil, nil)},
	  {"CB-ACCESS-TIMESTAMP", timestamp_fun.()}
	]
    end
  end

  describe "unwrap_response/1" do
    
    test "unwraps a successful response and returns the body" do
      success = {:ok, %{body: "<body>"}}

      assert Client.unwrap_response(success) == {:ok, "<body>"}
    end

    test "unwraps an unsuccessful response" do
      failure = {:error, "<error message>"}
      
      assert Client.unwrap_response(failure) == {:error, "<error message>"}
    end

    test "correctly handles an unknown error" do
      unknown = :nope
      
      assert Client.unwrap_response(unknown) == {:error, :nope}
    end
  end

  describe "get/1" do
  end

  describe "delete/1" do
  end

  describe "post/2" do
  end

  describe "put/2" do
  end

  describe "patch/2" do
  end

end
