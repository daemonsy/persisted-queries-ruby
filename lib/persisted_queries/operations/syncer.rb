module PersistedQueries
  module Operations
    class Syncer
      def initialize(queries:, client_name:)
        @queries = queries
        @client_name = client_name
      end

      def perform

      end

      private
      def client_path
      end
    end
  end
end
