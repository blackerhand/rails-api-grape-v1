module Entities
  # all entities base
  class Base < Grape::Entity
    expose :id

    format_with(:time_format) { |dt| dt&.strftime('%F') }
    format_with(:thousand_yuan) { |num| ActiveSupport::NumberHelper.number_to_currency(num * 1000, unit: '', precision: 2, format: '%u%n') if num }

    with_options(format_with: :time_format) { expose :created_at, :updated_at }
  end
end
