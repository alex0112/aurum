defmodule Aurum.Coinbase.ClientTest do
  alias Aurum.Coinbase.Client, as: Client
  alias Tesla


  describe "new/6" do
  end

  describe "middleware/0" do

    test "correctly inserts the base url" do
      base_url        = "https://api.example.com/v2"
      middleware_list = middleware("", "", "", base_url)

      assert {Tesla.Middleware.BaseUrl, base_url} in middleware_list
    end

  end

  describe "headers/6" do
    
    test "generates headers given the key, timestamp, and a signature function" do
      key_fun       = fn -> "<key>" end
      timestamp_fun = fn -> "<timestamp>" end
      sign_fun      = fn _secret, _timestamp, _method, _path, _body -> "<signature>" end
      method        = "GET"
      path          = "/api"
      body          = ""

      assert Client.headers(method, path, body) ==
	[
	  {"CB-ACCESS-KEY",       key_fun.()},
	  {"CB-ACCESS-SIGN",      signature_fun.()},
	  {"CB-ACCESS-TIMESTAMP", timestamp_fun()}
	]
    end

  end

end
