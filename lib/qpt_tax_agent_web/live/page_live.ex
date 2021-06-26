defmodule QptTaxAgentWeb.PageLive do
  alias QptTaxAgentWeb.PageLive.Navigator
  use QptTaxAgentWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    socket = socket |> fetch_locale(session)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, uri, socket) do
    {:noreply, Navigator.handle_navigation(params, uri, fetch_locale(socket, params))}
  end

  @impl true
  def handle_info({:update_assigns, payload}, socket) do
    {:noreply, assign(socket, payload)}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    if not QptTaxAgentWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end

  def get_assigns_for_mainpage(assigns) do
    assigns
    |> Map.put(:id, assigns[:root_route][:id])
    |> trim_assigns()
  end

  defp trim_assigns(assigns) do
    Map.drop(assigns, [
      :socket,
      :route_stack,
      :root_route
    ])
  end

  defp fetch_locale(socket, session) do
    locale = Map.get(session, "locale", Gettext.get_locale())
    Gettext.put_locale(locale)

    assign(socket, :locale, locale)
  end
end
