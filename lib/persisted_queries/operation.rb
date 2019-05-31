module PersistedQueries
  class Operation
    attr_reader :name, :file_path, :key, :document
    def initialize(name:, document:, key:, file_path:)
      @name = name
      @key = key
      @document = document
      @file_path = file_path
    end
  end
end
