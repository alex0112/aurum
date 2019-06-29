defmodule AurumTest do
  use ExUnit.Case, async: true
  doctest Aurum
  
  describe "new" do
    test "raises an error without a symbol" do
      assert_raise ArgumentError, Aurum.new(symbol: nil, client: "")
    end

    test "raises an error without a client" do
      assert_raise ArgumentError, Aurum.new(symbol: "", client: nil)
    end

    test "does not raise an error when provided with a client and symbol" do
      assert Aurum.new(symbol: "", client: "")
    end
  end
end
