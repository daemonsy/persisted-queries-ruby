require "bundler/setup"
require "persisted_queries"
require "support/fixtures_helpers"
require "support/schema_helpers"
require "support/graph/schema"
require "pry"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  include FixturesHelpers
  include SchemaHelpers
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
