module Graph
  class BaseObject < GraphQL::Schema::Object
  end

  class Post < BaseObject
    field :title, String, 'Title of the post', null: false
    field :body, String, 'Post body', null: false
  end

  class QueryType < BaseObject
    field :site_name, String, "Returns the site's name", null: false
    field :recent_posts, [Post], "Recent posts from the site", null: false

    def site_name
      'My Awesome Blog'
    end

    def recent_posts
      [{
        title: 'GraphQL Rocks',
        body: 'Hello Lorem Ipsum'
      }]
    end
  end
end
