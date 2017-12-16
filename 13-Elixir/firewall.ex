defmodule Firewall do

  def getLayers do
    getLayers([])
  end

  def getLayers(layers) do
    input = IO.gets("")

    case input do
      :eof ->
        layers
      _ ->
        trimmed = String.trim_trailing(input)
        values = Enum.map(String.split(trimmed, ": "), &String.to_integer/1)
        last = Enum.count(layers) -1
        this = Enum.at(values,0)
        if this > (last + 1) do
          newLayers = Enum.concat(layers, Enum.map(
            (last+1)..(this-1),
            fn _ -> 0 end))
              complete = Enum.concat(newLayers, [Enum.at(values,1)])
              getLayers(Enum.to_list(complete))
        else
          complete = Enum.concat(layers, [Enum.at(values,1)])
          getLayers(Enum.to_list(complete))
        end
    end
  end

  def severity(layers, wait) do
    last = Enum.count(layers) - 1

    case List.last(layers) do
      nil ->
        0
      0 ->
        severity(Enum.take(layers, last), wait)
      x ->
        danger = if Integer.mod(last + wait, (2*x)-2) == 0 do
          x * last
        else
          0
        end
        danger + severity(Enum.take(layers, last), wait)
    end
  end

  def severity(layers) do
    severity(layers,0)
  end

  def caught(layer, wait) do
    Integer.mod(wait, (2*layer)-2) == 0
  end

  def sneak(layers, wait) do
    case severity(layers,wait) do
      0 ->
        if caught(Enum.at(layers,0), wait) do
          sneak(layers, wait + 1)
        else
          wait
        end
      _ ->
        sneak(layers, wait + 1)
    end
  end

  def sneak(layers) do
    sneak(layers,0)
  end

end

layers = Firewall.getLayers()

IO.puts(Firewall.severity(layers))

IO.puts(Firewall.sneak(layers))
