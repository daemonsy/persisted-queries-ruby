require 'persisted_queries/static_validation/one_operation_per_document'

module PersistedQueries
  module StaticValidation
    class Validator
      attr_reader :schema, :rules
      def initialize(schema:, rules: nil)
        @schema = schema
        @rules = rules || GraphQL::StaticValidation::ALL_RULES + [OneOperationPerDocument]
      end

      def validate(document)
        query = GraphQL::Query.new(schema, document: document, context: nil)

        GraphQL::StaticValidation::Validator.new(schema: schema, rules: rules)
          .validate(query)
      end
    end
  end
end
