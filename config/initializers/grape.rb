require 'grape-swagger/endpoint'

module Grape
  class Endpoint
    def model_name(m)
      m.to_s.gsub('::', '')
    end
  end
end

Grape.configure do |config|
  config.param_builder = Grape::Extensions::Hashie::Mash::ParamBuilder
end
