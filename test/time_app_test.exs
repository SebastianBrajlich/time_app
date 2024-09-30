defmodule TimeAppTest do
  use ExUnit.Case
  doctest TimeApp

  test "greets the world" do
    assert TimeApp.hello() == :world
  end
end
