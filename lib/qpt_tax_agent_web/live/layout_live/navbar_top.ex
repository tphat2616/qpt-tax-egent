defmodule QptTaxAgentWeb.LayoutLive.NavbarTop do
    use QptTaxAgentWeb, :live_component
  
    @impl true
    def handle_event("suggest", %{"q" => query}, socket) do
      {:noreply, assign(socket, search_changeset, query: query)}
    end
  
    @impl true
    def handle_event("search", %{"q" => query}, socket) do
      case search_changeset() do
        %{^query => vsn} ->
          {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}
  
        _ ->
          {:noreply,
           socket
           |> put_flash(:error, "No dependencies found matching \"#{query}\"")
           |> assign(results: %{}, query: query)}
      end
    end
  
    defp search_changeset() do
        nil
    end
    
end