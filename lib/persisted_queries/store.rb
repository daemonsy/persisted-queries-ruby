require 'persisted_queries/add_operation'

module PersistedQueries
  class Store
    class << self
      attr_accessor :schema
      attr_reader :path

      def schema=(value)
        @schema = if value.class == Hash
          GraphQL::Schema.from_introspection(value)
        elsif value.ancestors.any? { |ancestor| ancestor == GraphQL::Schema }
          value
        end
      end

      def path=(value)
        @path = Pathname.new(value)
      end

      def add(client:, query:, hash:)
        path = client_path(client.underscore).mkpath
        AddOperation.new(client: client, query: query, hash: hash, store: self).perform
      end

      def client_path(client)
        path + client.to_s
      end
    end
  end
end
