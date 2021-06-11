defmodule QptTaxAgentWeb.PageRouter do
    alias Client25plusWeb.PrinterHelpers, as: Printer
    def routes do
        [
          ### HOME PAGE ###
          [
            component: QptTaxAgentWeb.HomeLive.Index,
            id: "home-page",
            title: "Home",
            live_action: :home_index
          ],
          [
            component: QptTaxAgentWeb.Introduction.Index,
            id: "gioi-thieu",
            title: "Gioi Thieu",
            live_action: :gioi_thieu
          ],
          [
            component: QptTaxAgentWeb.HomeLive.Index,
            id: "dich-vu",
            title: "Dich Vu",
            live_action: :dich_vu
          ],
          [
            component: QptTaxAgentWeb.HomeLive.Index,
            id: "tin-tuc",
            title: "Tin Tuc",
            live_action: :tin_tuc
          ],
          [
            component: QptTaxAgentWeb.HomeLive.Index,
            id: "tuyen-dung",
            title: "Tuyen dung",
            live_action: :tuyen_dung
          ],
          [
            component: QptTaxAgentWeb.HomeLive.Index,
            id: "lien-he",
            title: "Lien He",
            live_action: :lien_he
          ],
        ]
    end

    def find_route(live_action, default \\ home_route(), args \\ []) when is_atom(live_action) do
        stack = Keyword.get(args, :route_stack, routes())
        Enum.find(stack, default, fn route -> route[:live_action] === live_action end)
    end
    
    def find_parent(route, default \\ nil)
    def find_parent(route, default) when is_nil(route), do: default

    def find_parent(live_action, default) when is_atom(live_action) do
    find_parent(find_route(live_action), default)
    end

    def find_parent(route, default) do
    parent_action = Keyword.get(route, :parent)

    case parent_action do
        nil ->
        default

        _ ->
        find_route(parent_action)
    end
    end

    def find_root(route, default \\ home_route())
    def find_root(route, default) when is_nil(route), do: default

    def find_root(route, default) do
    cond do
        root_route?(route) ->
        route

        Keyword.get(route, :parent) === nil ->
        default

        true ->
        find_root(find_route(Keyword.get(route, :parent), default))
    end
    end

    def home_route(), do: List.first(routes())

    @type route :: Keyword
    def root_route?(route) do
    Keyword.get(route, :as, :page) === :page
    end
end