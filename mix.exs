defmodule EctoBitfield.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_bitfield,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 2.1", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp description do
    """
    A tool to use Bitfields with Ecto schemas
    """
  end

  defp package do
    [
      name: :ecto_bitfield,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Imran Ismail"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/imranismail/ecto_bitfield"}
    ]
  end
end
