module PersistedQueries
  class AddOperation
    def initialize(path:, document:, key:)
      @path = path
      @document = document
      @key = key
    end

    def perform!
      name = document.definitions[0].name
      file_path = path + "#{name.underscore}_#{key}.graphql"
      File.open(file_path, "w") { |file| file.write(document.to_query_string) }

      Operation.new(name: name, document: document, file_path: file_path, key: key)
    end

    private
    attr_reader :path, :document, :key, :registry
  end
end
