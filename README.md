How to deploy project with gigalixir
1. Add dependency.
{:distillery, "~> 2.1"},

2. Config prod.exs

3. cd "assets" run "npm run deploy"

4. Run "mix phx.digest"

5. Set enviroment
  SET MIX_ENV=prod

  SET SECRET_KEY_BASE="$(mix phx.gen.secret)"

  SET DATABASE_URL="postgresql://fc99d275-5a64-4773-b976-e92bd6c97f0d-user:pw-1d273718-087a-4671-b1f7-8b57f5d1d25a@postgres-free-tier-v2020.gigalixir.com:5432/fc99d275-5a64-4773-b976-e92bd6c97f0d"

  SET APP_NAME=qpt-tax-agent

  mix distillery.release --env=prod
  
  git push gigalixir