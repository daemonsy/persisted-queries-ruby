require "persisted_queries/static_validation/one_operation_per_document_error"

module PersistedQueries
  module StaticValidation
    module OneOperationPerDocument
      attr_reader :found_operation_definitions
      def initialize(*)
        super
        @found_operation_definitions = []
      end

      def on_document(node, parent)
        super
        node.definitions.each do |definition|
          if definition.is_a? GraphQL::Language::Nodes::OperationDefinition
            found_operation_definitions.push(definition)
          end
        end
        add_error(
          PersistedQueries::StaticValidation::OneOperationPerDocumentError.new("Found more than 1 operation in query (#{found_operation_definitions.map(&:name).join(', ')})")
        ) if found_operation_definitions.size > 1
      end
    end
  end
end
