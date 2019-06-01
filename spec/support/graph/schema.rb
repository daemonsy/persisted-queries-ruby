require_relative "./query_type"

module Graph
  class Schema < GraphQL::Schema
    query QueryType
  end
end
