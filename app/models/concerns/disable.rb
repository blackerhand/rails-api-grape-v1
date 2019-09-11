module Disable
  extend ActiveSupport::Concern

  included do
    scope :disabled, -> { where.not(disabled_at: nil) }
    scope :enabled, -> { where(disabled_at: nil) }
  end

  def enabled?
    disabled_at.blank?
  end

  def disabled?
    disabled_at.present?
  end

  def disabled!
    update!(disabled_at: Time.current)
  end

  def enabled!
    update!(disabled_at: nil)
  end
end
