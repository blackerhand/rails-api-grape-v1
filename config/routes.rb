Rails.application.routes.draw do
  mount BaseGrape => '/'
  mount GraphqlGrape => '/graphql'

  if Rails.env.development?
    mount GrapeSwaggerRails::Engine => '/swagger'
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
end
