module PersistedQueries
  module StaticValidation
    class OneOperationPerDocumentError < GraphQL::StaticValidation::Error
      def code
        "oneOperationPerDocument"
      end
    end
  end
end
