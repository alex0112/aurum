defmodule AurumTest.Coinbase.SignTest do
  use ExUnit.Case
  doctest Aurum.Coinbase.Sign

  alias Aurum.Coinbase.Sign

  describe "sign/5" do

    test "produces the correct hash with the test data" do
	secret_fun = fn -> "bar" end
	timestamp  = 1636971273
	method     = "GET"
	path       = "/zork"
	body       = "{'quux': 'zyzx'}"
	
	signature = Sign.sign(method, path, body, timestamp, secret_fun)

	assert signature == "6aed30a898d9c87ef9f652d81e49464c65ff9406801e7edd238febe959f58dca"
    end

    test "produces the correct signature length with the test data" do
	secret_fun = fn -> "bar" end
	timestamp  = 1636971273
	method     = "GET"
	path       = "/zork"
	body       = "{'quux': 'zyzx'}"
	
	signature = Sign.sign(method, path, body, timestamp, secret_fun)
	
	assert byte_size(signature) == 64
    end

  end

  describe "generate_message/4" do
    test "creates a message correctly when no body is present" do
      assert Sign.generate_message("foo", "bar", "baz") == "foobarbaz"
    end
  
    test "correctly generates a message when a body is present" do
      assert Sign.generate_message("foo", "bar", "baz", "bang") == "foobarbazbang"
    end
  end

end
