
defmodule Echo.CLI do

  @version Mix.Project.config[:version]

  def main(args) do
    args |> parse_args |> process
  end

  def process([]) do
    print_usage_error "There is no required options\n"
  end

  def process(options) do
    cond do
      Keyword.has_key?(options, :version) ->
        print_version()
      Keyword.has_key?(options, :help) ->
        print_usage()
      Keyword.has_key?(options, :name) ->
        Echo.start options
      true ->
        print_usage_error "Invalid options: #{inspect options}\n"
    end
  end

  def parse_args(args) do
    strict = [
      name: :string,
      cookie: :string,
      version: :boolean,
      help: :boolean,
      debug: :boolean
    ]
    aliases = [
      n: :name,
      c: :cookie,
      v: :version,
      h: :help,
      d: :debug
    ]
    {switches, argv} = OptionParser.parse!(args, strict: strict, aliases: aliases)

    arguments = case argv do
      [remote] ->
        [remote: String.to_atom(remote)]
      _ ->
        []
    end

    switches = Keyword.update(switches, :cookie, :popa, &(String.to_atom(&1)))

    [switches | arguments] |> List.flatten
  end

  defp print_usage_error(message) do
    IO.puts message
    print_usage()
    exit {:shutdown, 1}
  end

  defp print_usage do
    IO.puts "Echo #{@version}"
    IO.puts "Usage:"
    IO.puts "  echo --cookie <cookie> --name <name>"
  end

  defp print_version do
    IO.puts @version
  end
end
