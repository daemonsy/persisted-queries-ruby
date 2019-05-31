# Persisted::Queries::Ruby

Simple expression of persisted queries (read: poor man's version), that stores the most current version of the query on disk.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'persisted-queries'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install persisted-queries

## Usage

### Define a Registry.

```ruby
class Registry < PersistedQueries::Registry
  schema MyGraphQLSchema # A GraphQL Schema defined using graphql-ruby
  path 'app/queries/registry'
end
```

This serves as the root folder where queries for different clients will be stored.

### Add development syncing endpoint

`PersistedQueries::Rack::Endpoint` is a rack endpoint that can be mounted on any rack app. You should only expose this endpoint for syncing queries in development.

```ruby
if Rails.env.development?
  mount PersistedQueries::Rack::Endpoint => 'graphql/persisted_queries'
end
```

### Setup JS syncing
If you're using Webpack, this library comes with a plugin that scans for `*.graphql` files and synchronises them with the server with every build.

```javascript
const PersistedQueries = require('persisted-queries-ruby');

plugins = [
  new PersistedQueries({
    client: 'my-webpack-app', // Queries will be stored at app/queries/registry/my_webpack_app on your Ruby server
    url: 'http://localhost:3000/graphql/persisted_queries',
    moduleName: 'persisted-queries-registry' // <= Optional. Default name of the virtual module that you can import
    manifest: null, // When given an absolute path, generates a JSON manifest of the query. Check this is for debugging and to use with CI
  })
]
```

####


### Write a GraphQL query

```graphql
# Example: In src/queries/github/get-user.graphql
query getUser {
  # Unique operation name is required
  user(login: "jimweirich") {
    name
  }
}
```


### Consume away!

```javascript
import Registry from 'persisted-queries-ruby' // This is a virtual module.

// Use with Apollo

// Use with Relay

// Vanilla JS
```

### Endpoint Setup

**TBD description**

```ruby
class GraphQLController < ApplicationController
  def execute
    operation = PersistedQueries::Registry.find(params[:extensions][:operationId])
    head :bad_request unless operation

    render json: operation.execute(variables: variables, context: {})   # Delegates to your GraphQL schema
  end
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/daemonsy/persisted-queries-ruby.
