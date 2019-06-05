require 'persisted_queries/add_operation_result'

module PersistedQueries
  class AddOperation
    def initialize(path:, document:, key:, validator:)
      @path = path
      @document = document
      @key = key
      @validator = validator
    end

    def perform!
      return result unless errors.empty?
      path.mkpath

      File.open(operation.file_path, "w") { |file| file.write(operation.query) }

      result
    end

    def errors
      @errors ||= validator.validate(document).fetch(:errors)
    end

    def operation
      @operation ||= Operation.new(document: document, client_path: path, key: key)
    end

    private
    attr_reader :path, :document, :key, :registry, :validator

    def result
      @result ||= AddOperationResult.new(errors: errors, operation: operation)
    end
  end
end
