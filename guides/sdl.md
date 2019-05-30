# Using SDL

Instead of building a schema based using the macro syntax, it is also possible
to use the GraphQL Schema Definition Language (SDL).

Here's a schema that supports looking up an item by ID:

```graphql
# filename: myapp/schema.graphql
    type Query {
      "A list of posts"
      posts(filter: PostFilter, reverse: Boolean): [Post]
      admin: User!
      droppedField: String
    }

```
```elixir
# filename: myapp/schema.ex
defmodule MyAppWeb.Schema do

  use Absinthe.Schema

import_sdl path: "schema.graphql"

end
```