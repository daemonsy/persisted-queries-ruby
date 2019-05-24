require 'spec_helper'

require 'tmpdir'
require 'securerandom'

RSpec.describe PersistedQueries::Store do
  let(:github_schema) { json_fixture('schemas/github') }
  class TestStore < PersistedQueries::Store
  end

  describe '.add' do
    let(:temp_folder) { Dir.tmpdir }
    let(:hash) { SecureRandom.uuid }
    let(:query) do
      <<~QUERY
        query getRememberedRubyist {
          user(login: "jimweirich") {
            name
          }
        }
      QUERY
    end
    let(:operation) do
      {
        client: 'github-dashboard',
        query: query,
        hash: hash
      }
    end

    before do
      TestStore.schema = github_schema
      TestStore.path = temp_folder
    end

    it 'adds the operations as graphql files to the client folder' do
      TestStore.add(operation)
      expected_path = Pathname.new(temp_folder) + 'github_dashboard' + "get_remembered_rubyist_#{hash}.graphql"

      expect(Pathname.new(expected_path).exist?).to eq(true)
    end

    it 'validates the query against the schema' do
    end
  end
end
