# SHT3x

Elixir driver for the SHT3x (SHT30, SHT31, SHT35) series temperature and humidity sensors from Sensirion.

## Usage

```elixir
{:ok, pid} = ElixirALE.I2C.start_link("i2c-1", 0x44)
[{:ok, temp}, {:ok, humidity}] = SHT3x.single_shot(pid, :high, true)
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sht3x` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sht3x, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/sht3x](https://hexdocs.pm/sht3x).


## TODO

* increase test + typespec coverage/correctness
* more docs