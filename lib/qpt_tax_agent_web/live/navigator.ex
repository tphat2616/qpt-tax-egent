defmodule QptTaxAgentWeb.PageLive.Navigator do
    alias QptTaxAgentWeb.PageRouter
    alias QptTaxAgentWeb.Router.Helpers, as: Routes
    alias Phoenix.LiveView
  
    def handle_navigation(params, uri, socket) do
      route =
        PageRouter.find_route(socket.assigns.live_action)
        |> Keyword.put(:uri, uri)
  
      socket =
        socket
        |> handle_stack(route, uri)
  
      root_route = PageRouter.find_root(route)
      parent_route = PageRouter.find_parent(route, root_route)
      previous_route = get_previous_route(socket, parent_route)
      return_to = get_return_uri(socket, previous_route)
  
      apply_params(socket, route, [params, uri, socket])
      |> push_stack(route, uri)
      |> LiveView.assign(
        route: Keyword.put(route, :return_to, return_to),
        page_title: route[:title],
        previous_route: previous_route,
        root_route: root_route
      )
    end
  
    def get_previous_route(socket, default \\ nil) do
      Enum.at(get_stack(socket), 0, default)
    end
  
    defp params_handleable?(route) when is_nil(route), do: false
  
    defp params_handleable?(route) do
      route[:component] && Keyword.has_key?(route[:component].__info__(:functions), :handle_params)
    end
  
    defp apply_params(_socket, {:noreply, returned_socket}), do: returned_socket
    defp apply_params(socket, _), do: socket
  
    defp apply_params(socket, route_or_module, args) do
      cond do
        not Keyword.keyword?(route_or_module) ->
          apply_params(socket, apply(route_or_module, :handle_params, args))
  
        params_handleable?(route_or_module) ->
          apply_params(socket, apply(route_or_module[:component], :handle_params, args))
  
        true ->
          socket
      end
    end
  
    defp handle_stack(socket, route, _uri) when is_nil(route), do: socket
  
    defp handle_stack(socket, route, uri) do
      cond do
        PageRouter.root_route?(route) ->
          clear_stack(socket)
  
        Keyword.get(route, :replace, false) === true ->
          socket
          |> pop_stack()
          |> pop_stack()
  
        get_uri_query(uri, "ignore") === "true" ->
          socket
          |> pop_stack()
  
        get_uri_query(uri, "replace") === "true" ->
          socket
          |> pop_stack()
          |> pop_stack()
  
        true ->
          socket
      end
    end
  
    defp clear_stack(socket), do: LiveView.assign(socket, route_stack: [])
  
    defp push_stack(socket, route, _uri) when is_nil(route), do: socket
  
    defp push_stack(socket, route, uri) do
      cond do
        get_uri_query(uri, "ignore") === "true" ->
          socket
  
        true ->
          LiveView.assign(socket, route_stack: List.insert_at(get_stack(socket), 0, route))
      end
    end
  
    defp pop_stack(socket) do
      LiveView.assign(socket, route_stack: List.delete_at(get_stack(socket), 0))
    end
  
    defp get_stack(socket, route \\ nil) do
      cond do
        route === nil ->
          Map.get(socket.assigns, :route_stack, [])
  
        PageRouter.root_route?(route) ->
          []
  
        true ->
          Map.get(socket.assigns, :route_stack, [])
      end
    end
  
    defp get_return_uri(_socket, previous_route) when is_nil(previous_route), do: nil
  
    defp get_return_uri(socket, previous_route) do
      current_route =
        Routes.url(socket)
        |> URI.merge(
          Keyword.get(previous_route, :uri) ||
            Routes.page_path(socket, previous_route[:live_action])
        )
  
      query =
        current_route
        |> Map.get(:query)
        |> Kernel.||("")
        |> Plug.Conn.Query.decode()
        # add replace = true so that it can pop the route stack
        |> Map.merge(%{"replace" => true})
        |> URI.encode_query()
  
      current_route
      |> URI.merge("?#{query}")
      |> URI.to_string()
      # remove the host from uri so that to RouteHelpers can work correctly
      |> String.replace_leading(Routes.url(socket), "")
    end
  
    defp get_uri_query(uri, key) do
      Map.get(URI.decode_query(URI.parse(uri).query || ""), key)
    end
  end
  