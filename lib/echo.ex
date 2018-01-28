
defmodule Echo do

  def start(options) do
    node = String.to_atom(options[:name])
    case Node.start(node) do
      {:ok, _} ->
        Node.set_cookie options[:cookie]
      {:error, term} ->
        IO.puts "Error:\n#{inspect term}"
        exit {:shutdown, 1}
    end

    IO.puts "Welcome #{options[:name]}"

    Process.register(self(), :echo_server)
    loop()
  end

  defp loop() do
    receive do
      message -> process(message)
    end
    loop()
  end

  defp process ({pid, msg}) do
    IO.puts "From: #{inspect pid}; msg: #{inspect msg}"
    send(pid, {self(), msg})
  end

  defp process (_) do
    IO.puts "Wrror!"
  end
end
