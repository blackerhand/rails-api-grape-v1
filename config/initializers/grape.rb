require 'grape-swagger/endpoint'

module Grape
  class Endpoint
    def model_name(m)
      m.to_s.gsub('::', '')
    end
  end

  # i18n rewrite
  module Exceptions
    class Base
      def translate_key(key)
        key.delete(']').split('[')[-2..-1].map(&:singularize).join('.')
      end

      protected

      def translate_attribute(key, **options)
        if key.include?('[')
          translate("activerecord.attributes.#{translate_key(key)}", default: key, **options)
        else
          translate("activerecord.models.#{key}", default: key, **options)
        end
      end

      def translate_attributes(keys, **options)
        keys.map do |key|
          translate_attribute(key, default: key, **options)
        end.join(', ')
      end
    end
  end
end

Grape.configure do |config|
  config.param_builder = Grape::Extensions::Hashie::Mash::ParamBuilder
end
