module PersistedQueries
  class Operation
    attr_reader :name, :key, :document
    def initialize(document:, key:, client_path:)
      @client_path = client_path
      @key = key
      @document = document
    end

    def name
      document.definitions[0].name
    end

    def query
      document.to_query_string
    end

    def file_path
      @file_path ||= client_path + "#{StringUtilities.underscore(name)}_#{key}.graphql"
    end

    private
    attr_reader :client_path
  end
end
