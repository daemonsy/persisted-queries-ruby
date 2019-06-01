module SchemaHelpers
  def get_test_registry(schema)
    Class.new(PersistedQueries::Registry).tap do |registry|
      registry.path = Dir.tmpdir
      registry.schema = schema
    end
  end
end
