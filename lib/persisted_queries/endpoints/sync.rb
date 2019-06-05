
module PersistedQueries
  module Endpoints
    class Sync
      attr_reader :registry
      def initialize(active: false, registry: nil)
        @active = !!active
        @registry = registry
      end


      def call(env)
        return [404, {}, []] unless active?
        params = JSON.parse(env['rack.input'].read)

        client = params.fetch('client', 'default')
        operations = params.fetch('operations', [])
        return [200, {}, []] unless operations.size > 0
        response = make_response_template

        registry.clear!(client: client)

        operations.each do |operation|
          result = registry.add(client: client, query: operation.fetch('query'), key: operation.fetch('key'))
          type = result.success? ? :added : :failed
          response[type].push(result.operation.key)
        end

        response[:success] = !!response[:failed].size

        return [200, { 'Content-Type' => 'application/json' }, [JSON.dump(response)]]
      end

      private

      def active?
        @active
      end

      def make_response_template
        {
          added: [],
          failed: []
        }
      end
    end
  end
end
