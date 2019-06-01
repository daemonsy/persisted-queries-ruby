require 'spec_helper'
require 'rack/mock'

require 'persisted_queries/endpoints/sync'

RSpec.describe PersistedQueries::Endpoints::Sync do
  let(:per_test_uuid) { SecureRandom.uuid }
  let(:registry) { get_test_registry(Graph::Schema) }
  let(:app) { described_class.new(active: active, registry: registry) }

  context 'when the endpoint is active' do
    let(:active) { true }
    let(:operation) do
      GraphQL.parse <<~GQL
        query getRecentPosts {
          recentPosts {
            title
            body
          }
        }
      GQL
    end

    let(:payload) do
      {
        client: 'github-app',
        operations: [{
          query: operation.to_query_string,
          key: per_test_uuid
        }]
      }
    end

    it 'syncs operations' do
      response = Rack::MockRequest.new(app).post('/graphql/sync', params: JSON.dump(payload))
      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(body.fetch('success')).to eql(true)
    end
  end

  context 'when the endpoint is not active' do
    let(:active) { false}

    it 'returns 404' do
      response = Rack::MockRequest.new(app).post('/graphql/sync', { operations: [] })

      expect(response.status).to eql(404)
      expect(response.body).to eq('')
    end
  end

end
