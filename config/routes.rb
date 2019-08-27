Rails.application.routes.draw do
  mount BaseGrape => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'
end
