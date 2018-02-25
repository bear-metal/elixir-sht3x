defmodule SHT3xTest do
  use ExUnit.Case, async: true
  doctest SHT3x

  defmodule MockI2C do
    use GenServer

    def start_link(args) do
      GenServer.start_link(__MODULE__, args, name: __MODULE__)
    end

    def init(args) do
      {:ok, args}
    end

    def handle_call({:wrrd, <<0x2C, 0x06>>, 6}, from, ["i2c-1", 0x44] = state) do
      data = <<107, 164, 246, 115, 79, 132>>
      {:reply, data, state}
    end
  end

  setup do
    {:ok, i2c} = start_supervised(MockI2C.child_spec(["i2c-1", 0x44]))
    %{i2c: i2c}
  end

  test "single_shot", context do
    [{:ok, temp}, {:ok, humidity}] = SHT3x.single_shot(context[:i2c], :high, true)
    assert temp == 28.58358129243915
    assert humidity == 45.04310673685817
  end

  test "calc_crc" do
    0x92 = SHT3x.calc_crc(0xBEEF)
    246 = SHT3x.calc_crc(27556)
  end
end
