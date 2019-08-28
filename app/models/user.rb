class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true

  def payload
    slice(:id)
  end

  def gen_code
    return code if code.present? && Time.current - updated_at < 60

    update!(code: rand(999_999))
    code
  end
end
