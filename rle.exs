defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t) :: String.t
  def encode(string) do
    _encode(string)
  end

  defp _encode(""), do: ""
  defp _encode("", last_char, inc, acc) do
    cond do
      inc == 1 -> acc <> <<last_char>>
      true -> acc <> to_string(inc) <> <<last_char>>
    end
  end

  defp _encode(<<h::utf8, t::binary>>) do
    _encode(t, h, 1, "")
  end

  defp _encode(<<h::utf8, t::binary>>, last_char, inc, acc) do
      cond do
        last_char == h -> _encode(t, h, inc + 1, acc)
        last_char !== h and inc == 1 -> _encode(t, h, 1, acc <> <<last_char>>)
        true -> _encode(t, h, 1, acc <> to_string(inc) <> <<last_char>>)
      end
  end

  @spec decode(String.t) :: String.t
  def decode(string) do
    _decode(string, "", "")
  end

  defp _decode(""), do: ""
  defp _decode("", _, acc), do: acc
  defp _decode(<<h::utf8, t::binary>>, inc, acc) when h in ?0..?9, do: _decode(t, inc <> <<h>>, acc)
  defp _decode(<<h::utf8, t::binary>>, "", acc), do: _decode(t, "", acc <> <<h>>)
  defp _decode(<<h::utf8, t::binary>>, inc, acc), do: _decode(t, "", acc <> String.duplicate(<<h>>, String.to_integer(inc)))

end
