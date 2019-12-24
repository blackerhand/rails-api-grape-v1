module Locationable
  extend ActiveSupport::Concern

  included do
    belongs_to :city, optional: true

    def province
      city.try(:province)
    end

    def province_id
      city.try(:province_id)
    end
  end
end
