require 'spec_helper'

require 'tmpdir'
require 'securerandom'

RSpec.describe PersistedQueries::Registry do
  class GithubRegistry < PersistedQueries::Registry
    schema json_fixture('schemas/github')
  end

  describe '.get_operation' do
    # it 'finds an operation by key' do
    #   pending
    # end
  end

  describe '.add_operation' do
    let(:temp_folder) { Dir.tmpdir }
    let(:per_test_uuid) { SecureRandom.uuid }
    let(:query) do
      <<~QUERY
        query getRememberedRubyist {
          user(login: "jimweirich") {
            name
          }
        }
      QUERY
    end

    let(:syntax_correct_bad_field_query) do
      <<~QUERY
        query badGithubQuery {
          # Typo in field
          usar(login: "daemonsy") {
            name
          }
        }
      QUERY
    end

    before { GithubRegistry.path(temp_folder) }

    it 'adds the operations as graphql files to the client folder' do
      operation = GithubRegistry.add(client: 'github-dashboard', query: query, key: per_test_uuid).fetch(:operation)
      expected_path = Pathname.new(temp_folder) + 'github_dashboard' + "get_remembered_rubyist_#{per_test_uuid}.graphql"

      expect(operation.file_path).to eq(expected_path)
      expect(Pathname.new(expected_path).exist?).to eq(true)
    end

    it 'validates the query against the schema' do
      result = GithubRegistry.add(client: 'github', query: syntax_correct_bad_field_query, key: SecureRandom.uuid)

      expect(result.fetch(:success)).to eq(false)
      expect(result.fetch(:errors).length).to eq(1)
      expect(result.fetch(:errors).first).to be_a(GraphQL::StaticValidation::FieldsAreDefinedOnTypeError)
    end

    context 'query validation' do
      let(:query_with_multiple_operations) do
        <<~QUERY
          query getUser {
            user(login: "daemonsy") {
              name
            }
          }

          query getRepoInfo {
            user(login: "daemonsy") {
              name
            }
            repository(owner: "daemonsy", name:"persisted-queries-ruby") {
              name
            }
          }
        QUERY
      end

      it 'returns an error if there is more than one operation per document' do
        result = GithubRegistry
        .add(client: 'github', query: query_with_multiple_operations, key: SecureRandom.uuid)

        expect(result.fetch(:success)).to eq(false)
        expect(result.fetch(:errors).size).to eq(1)

        operation_error = result.dig(:errors, 0)
        expect(operation_error).to be_a(PersistedQueries::StaticValidation::OneOperationPerDocumentError)
        expect(operation_error.message).to match('getRepoInfo')
        expect(operation_error.message).to match('getUser')
      end

      it 'enforces unique operation names across a client'
    end
  end
end
