
defmodule Echo.Mixfile do
  use Mix.Project

  def project do
    [
      app: :echo,
      version: "0.1.0",
      start_permanent: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      escript: [main_module: Echo.CLI],
      deps: deps()
    ]
  end

  defp deps do
    [ ]
  end
end
