defmodule QptTaxAgent.Repo do
  use Ecto.Repo,
    otp_app: :qpt_tax_agent,
    adapter: Ecto.Adapters.Postgres
end
