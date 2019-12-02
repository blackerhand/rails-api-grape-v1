module PreEnum
  extend ActiveSupport::Concern

  module ClassMethods
    def pre_enum(definitions)
      enum definitions
      enum_name = definitions.keys.first

      class_eval do
        define_singleton_method "#{enum_name}_zh_for_index".to_sym do |index|
          definitions.values.first.select { |_k, v| v.to_s == index.to_s }.keys.first
        end

        define_method "#{enum_name}_name".to_sym do
          send enum_name.to_sym
        end

        define_method "#{enum_name}_index".to_sym do
          send "#{enum_name}_before_type_cast".to_sym
        end
      end
    end
  end
end
