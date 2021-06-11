defmodule QptTaxAgentWeb.Router do
  use QptTaxAgentWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {QptTaxAgentWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", QptTaxAgentWeb do
    pipe_through(:browser)

    live("/", PageLive, :home_index)
    live("/gioi-thieu", PageLive, :gioi_thieu)
    live("/dich-vu", PageLive, :dich_vu)
    live("/tin-tuc", PageLive, :tin_tuc)
    live("/tuyen-dung", PageLive, :tuyen_dung)
    live("/lien-he", PageLive, :lien_he)
  end

  # Other scopes may use custom stacks.
  # scope "/api", QptTaxAgentWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: QptTaxAgentWeb.Telemetry)
    end
  end
end
