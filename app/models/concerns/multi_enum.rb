module MultiEnum
  extend ActiveSupport::Concern

  module ClassMethods
    def multi_enum(definitions)
      field         = definitions.keys.first
      enums         = definitions.values.first
      check_method  = "check_#{field}".to_sym
      enums_methods = field.to_s.pluralize.to_sym

      serialize field.to_sym, Array
      validate check_method

      singleton_class.send :define_method, enums_methods do
        enums
      end

      define_method check_method do
        errors.add(field, "#{field} value is not valid") if (send(field) - enums.values).present?
      end

      class_eval do
        define_method "#{field}_name".to_sym do
          send(field.to_sym)

          enums.each.map do |k, v|
            k if send(field.to_sym).include?(v)
          end.compact
        end

        define_method "#{field}_index".to_sym do
          send field.to_sym
        end
      end
    end
  end
end
