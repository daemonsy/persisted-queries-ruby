require 'persisted_queries/add_operation'
require 'persisted_queries/static_validation/validator'

module PersistedQueries
  class Registry
    class << self
      def schema(value = nil)
        self.schema = value if value
        @schema
      end

      def path(value = nil)
        self.path = value if value
        @path
      end

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

      def clear!(client:)
        client_path(client).children.each(&:rmtree)
        true
      end

      def add(client:, query:, key:)
        document = GraphQL.parse(query)
        validator = StaticValidation::Validator.new(schema: schema)
        path = client_path(client)

        AddOperation.new(path: path, document: document, key: key, validator: validator).perform!
      end

      def client_path(name)
        path + StringUtilities.underscore(name)
      end
    end
  end
end
