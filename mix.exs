defmodule FnExpr.Mixfile do
  use Mix.Project

  @app :fn_expr
  @git_url "https://github.com/aforward/fn_expr"
  @home_url @git_url
  @version "0.2.1"

  @deps [
    {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
    {:ex_doc, "~> 0.18.2", only: [:dev, :test]},
    {:version_tasks, "~> 0.10"}
  ]

  @package [
    name: @app,
    files: ["lib", "mix.exs", "README*", "README*", "LICENSE*"],
    maintainers: ["Andrew Forward"],
    licenses: ["MIT"],
    links: %{"GitHub" => @git_url}
  ]

  # ------------------------------------------------------------

  def project do
    in_production = Mix.env() == :prod

    [
      app: @app,
      version: @version,
      elixir: "~> 1.6",
      name: "FnExpr",
      description:
        "The && operator (and invoke macro) for use with |> and anonymous functions / captures",
      package: @package,
      source_url: @git_url,
      homepage_url: @home_url,
      docs: [main: "FnExpr", extras: ["README.md"]],
      build_embedded: in_production,
      start_permanent: in_production,
      deps: @deps
    ]
  end

  def application do
    [
      # built-in apps that need starting
      extra_applications: [
        :logger
      ]
    ]
  end
end
