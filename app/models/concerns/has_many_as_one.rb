module HasManyAsOne
  extend ActiveSupport::Concern

  module ClassMethods
    def has_many_as_one(relation, opts = {})
      has_many relation, opts

      class_eval do
        define_method relation.to_s.singularize.to_sym do
          send(relation).enabled.order(id: :desc).first
        end
      end
    end
  end
end
