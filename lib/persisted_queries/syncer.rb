require 'fileutils'

module PersistedQueries
  module Operations
    class Syncer
      attr_reader :client_name, :queries
      def initialize(queries:, client_name:)
        @queries = queries
        @client_name = client_name
      end

      def perform
        FileUtils.mkdir(client_path) unless client_path.exist?
      end

      private
      def client_path
        @client_path ||= Pathname.new(Store.path) + client_name
      end
    end
  end
end
