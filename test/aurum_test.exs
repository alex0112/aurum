defmodule AurumTest do
  use ExUnit.Case
  doctest Aurum

  setup_all do
    ##[ client: Client.new(ENV['COINBASE_KEY'], ENV['COINBASE_SECRET']) ] ## TODO: Implement
    [ client: nil ]
  end
  
  describe "new" do
    test "raises an error without symbol", context do
      assert_raise ArgumentError, Aurum.new(context[:client])
    end

    test "raises an error without a client" do
      assert_raise ArgumentError, Aurum.new(:BTC)
    end

    test "does not raise an error when provided with a client and symbol", context do
      assert Aurum.new(context[:client], :BTC)
    end
  end
end
