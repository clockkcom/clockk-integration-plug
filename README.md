# ClockkIntegrationPlug

Essential starting point when using Phoenix Framework to build a Clockk integration.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `clockk_integration_plug` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:clockk_integration_plug, "~> 0.1.0"}
  ]
end
```

If not available in Hex, use:

```elixir
def deps do
  [
    {:clockk_integration_plug, git: "https://github.com/liquidmedia/clockk_integration_plug"}
  ]
end
```

add the following to your `config.exs` file:

```elixir
config :clockk_integration_plug,
  client_secret: "your-clockk-client-secret"
```

add some plugs to your pipeline in `router.ex`:


```elixir
  pipeline :incoming_webhook do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug ClockkIntegrationPlug.ValidateHMAC
    # FixCSRF allows Plug's CSRF to work inside of iFrames. Include this plug if you want to
    # submit forms inside of your Clockk extensions.
    plug ClockkIntegrationPlug.FixCSRF
    # Remove iframe blocking headers when you are attempting to render inside of Clockk's UI
    plug ClockkIntegrationPlug.ShowInIFrame
    # Conveniece function to place the Clockk-provided resource inside of conn
    plug ClockkIntegrationPlug.ClockkResource
    plug :put_secure_browser_headers
  end

  scope "/", ClockkFreshBooksWeb do
    pipe_through :incoming_webhook

    post "/clockk-actions", ActionController, :handle_action
  end
```

The `ClockkIntegrationPlug.ClockkResource` plug will place the request's Clockk resource inside of `conn.private.clockk_resource` and the Integration Performed Actions for the current Clockk resource inside of `conn.private.integration_performed_actions`

```html
<h2>Select a Harvest project to link with <%= @conn.private.clockk_resource.name %></h2>
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/clockk_integration_plug](https://hexdocs.pm/clockk_integration_plug).

