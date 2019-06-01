require "persisted_queries/endpoints/sync"

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  if Rails.env.development? # This stops Rails from mounting the endpoint at all
    mount PersistedQueries::Endpoints::Sync.new(
      # This returns 404 in production and it's a safety regression check.
      # active is false by default
      active: Rails.env.development?
    ), at: '/graphql/sync', as: :graphql_sync
  end
end
