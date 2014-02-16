defmodule ConfitTest do
  use ExUnit.Case

  test "get" do
    assert :ok == Confit.load("test/good.conf")
    assert :world == Confit.get(:hello)
  end

  test "get sub key" do
    assert :ok == Confit.load("test/good.conf")
    assert 42 == Confit.get(:app1, :key1)
  end

  test "reload" do
    File.write("test/temp.conf", "[a: 42]")
    assert :ok == Confit.load("test/temp.conf")
    assert 42 == Confit.get(:a)
    File.write("test/temp.conf", "[a: 41]")
    assert :ok == Confit.load("test/temp.conf")
    assert 41 == Confit.get(:a)
    File.rm("test/temp.conf")
  end

  test "syntax error" do
    assert { :error, { 5, 'syntax error before: ', ['key2'] } } == Confit.load("test/bad1.conf")
  end

  test "unsafe conf" do
    assert { :error, :unsafe_conf } == Confit.load("test/bad2.conf")
  end

  test "bad conf" do
    assert { :error, :bad_conf } == Confit.load("test/bad3.conf")
  end
end
