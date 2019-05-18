module PersistedQueries
  module Operations
    class Store
      class << self
        attr_writer :path

        def path
          @path ||= "#{Dir.pwd}/graphql/operations"
        end
      end
    end
  end
end
