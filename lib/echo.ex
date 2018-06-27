
defmodule Echo do

  def start(options) do
    node = String.to_atom(options[:name])
    case Node.start(node, :shortnames) do
      {:ok, _} ->
        Node.set_cookie options[:cookie]
      {:error, term} ->
        IO.puts "Error:\n#{inspect term}"
        exit {:shutdown, 1}
    end

    Process.register(self(), :echo_server)
    IO.puts "Started node #{options[:name]} with 'echo_server' process"

    if Keyword.has_key?(options, :debug) do
      loop_with_debug()
    else
      loop()
    end
  end

  defp loop() do
    receive do
      {from, to, message} ->
        send(to, {from, message})
      {pid, message} ->
        send(pid, {self(), message})
      wrror ->
        IO.puts "Wrror: #{inspect wrror}"
    end
    loop()
  end

  defp loop_with_debug() do
    receive do
      {from, to, message} ->
        IO.puts "Redirect from: #{inspect :erlang.node(from)} to: #{inspect :erlang.node(to)};\nmessage: #{inspect message}"
        send(to, {from, message})
      {pid, message} ->
        IO.puts "From: #{inspect pid}; message: #{inspect message}"
        send(pid, {self(), message})
      wrror ->
        IO.puts "Wrror: #{inspect wrror}"
    end
    loop_with_debug()
  end
end
