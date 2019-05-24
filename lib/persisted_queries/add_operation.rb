require 'digest'

module PersistedQueries
  class AddOperation
    def initialize(client:, query:, hash:, store:)
      @client = client
      @query = query
      @hash = hash
      @store = store
    end

    def perform
      document = GraphQL.parse(query)
      errors = store.schema.validate(document) # Use validation to assert that the document has only 1 valid operation
      # digest = Digest::MD5.hexdigest(document.to_query_string)
      name = document.definitions[0].name

      filename = store.client_path(client.underscore) + "#{name.underscore}_#{hash}.graphql"
      File.open(filename, "w") { |file| file.write(document.to_query_string) }
    end

    private
    attr_reader :client, :query, :hash, :store
  end
end
