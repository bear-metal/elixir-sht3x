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

    def handle_call({:wrrd, <<0x2C, 0x06>>, 6}, _, ["i2c-1", 0x44] = state) do
      data = <<107, 164, 246, 115, 79, 132>>
      {:reply, data, state}
    end

    def handle_call({:wrrd, <<243, 45>>, 3}, _, ["i2c-1", 0x44] = state) do
      data = <<128, 16, 225>>
      {:reply, data, state}
    end
  end

  defmodule MockI2CFailedCRCTemp do
    use GenServer

    def start_link(args) do
      GenServer.start_link(__MODULE__, args, name: __MODULE__)
    end

    def init(args) do
      {:ok, args}
    end

    def handle_call({:wrrd, <<0x2C, 0x06>>, 6}, _, ["i2c-1", 0x44] = state) do
      data = <<107, 165, 246, 115, 79, 132>>
      {:reply, data, state}
    end
  end

  defmodule MockI2CFailedCRCHumidity do
    use GenServer

    def start_link(args) do
      GenServer.start_link(__MODULE__, args, name: __MODULE__)
    end

    def init(args) do
      {:ok, args}
    end

    def handle_call({:wrrd, <<0x2C, 0x06>>, 6}, _, ["i2c-1", 0x44] = state) do
      data = <<107, 164, 246, 115, 80, 132>>
      {:reply, data, state}
    end
  end

  setup do
    {:ok, i2c} = start_supervised(MockI2C.child_spec(["i2c-1", 0x44]))

    {:ok, i2c_failed_crc_temp} =
      start_supervised(MockI2CFailedCRCTemp.child_spec(["i2c-1", 0x44]))

    {:ok, i2c_failed_crc_humidity} =
      start_supervised(MockI2CFailedCRCHumidity.child_spec(["i2c-1", 0x44]))

    %{
      i2c: i2c,
      i2c_failed_crc_temp: i2c_failed_crc_temp,
      ic2_failed_crc_humidity: i2c_failed_crc_humidity
    }
  end

  test "single_shot_result", context do
    [{:ok, temp}, {:ok, humidity}] = SHT3x.single_shot_result(context[:i2c], :high, true)
    assert temp == 28.58358129243915
    assert humidity == 45.04310673685817
  end

  test "crc failed for temp", context do
    [{:error, :crc_failed}, {:ok, _}] =
      SHT3x.single_shot_result(context[:i2c_failed_crc_temp], :high, true)
  end

  test "crc failed for humidity", context do
    [{:ok, _}, {:error, :crc_failed}] =
      SHT3x.single_shot_result(context[:ic2_failed_crc_humidity], :high, true)
  end

  test "calc_crc" do
    0x92 = SHT3x.calc_crc(0xBEEF)
    246 = SHT3x.calc_crc(27556)
  end

  test "status_result", context do
    assert SHT3x.status_result(context[:i2c]) ==
             {:ok,
              %{
                alert: 1,
                checksum_status: 0,
                command_status: 0,
                heater_status: 0,
                humidity_alert: 0,
                reset_detected: 1,
                temp_alert: 0
              }}
  end
end
