require 'persisted_queries/add_operation'
require 'persisted_queries/static_validation/validator'

module PersistedQueries
  class Registry
    class << self
      attr_reader :path

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

      def add(client:, query:, key:)
        document = GraphQL.parse(query)
        validator = StaticValidation::Validator.new(schema: schema)

        errors = validator.validate(document).fetch(:errors)
        return { success: false, errors: errors } if errors.size > 0

        path = client_path(client.underscore)
        path.mkpath
        operation = AddOperation.new(path: path, document: document, key: key).perform!

        { success: true, operation: operation }
      end

      def client_path(client)
        path + client
      end
    end
  end
end
