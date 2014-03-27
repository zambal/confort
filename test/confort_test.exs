defmodule ConfortTest do
  use ExUnit.Case

  test "get" do
    assert :ok == Confort.load("test/good.conf")
    assert :world == Confort.get(:hello)
  end

  test "get sub key" do
    assert :ok == Confort.load("test/good.conf")
    assert 42 == Confort.get(:app1, :key1)
  end

  test "all" do
    assert :ok == Confort.load("test/good.conf")
    assert [hello: :world, app1: [key1: 42, key2: "value"]] == Confort.all()
  end

  test "reload" do
    File.write("test/temp.conf", "[a: 42]")
    assert :ok == Confort.load("test/temp.conf")
    assert 42 == Confort.get(:a)
    File.write("test/temp.conf", "[a: 41]")
    assert :ok == Confort.load("test/temp.conf")
    assert 41 == Confort.get(:a)
    File.rm("test/temp.conf")
  end

  test "syntax error" do
    assert { :error, { 5, 'syntax error before: ', ['key2'] } } == Confort.load("test/bad1.conf")
  end

  test "unsafe conf" do
    assert { :error, :unsafe_conf } == Confort.load("test/bad2.conf")
  end

  test "bad conf" do
    assert { :error, :bad_conf } == Confort.load("test/bad3.conf")
  end
end
