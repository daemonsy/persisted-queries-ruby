module PersistedQueries
  class AddOperationResult
    attr_accessor :operation, :errors
    def initialize(operation: nil, errors: [])
      @operation = operation
      @errors = errors
    end

    def success?
      operation && errors.empty?
    end

    def to_h
      { success: success?, operation: operation }
    end
  end
end
