class User < ApplicationRecord
  has_secure_password
  rolify

  has_one :files_avatar, :class_name => 'Files::Avatar', as: :fileable

  action_store :favorite, :post, counter_cache: true, user_counter_cache: true # 收藏
  action_store :like, :post, counter_cache: true, user_counter_cache: true # 点赞
  action_store :unlike, :post, counter_cache: true, user_counter_cache: true # 点踩

  validates :email, presence: true, uniqueness: true

  after_create :create_file_avatar

  def payload
    slice(:id)
  end

  def avatar_url
    files_avatar.file_url
  end

  def gen_code
    return code if code.present? && Time.current - updated_at < 60

    update!(code: rand(999_999))
    code
  end

  private

  def create_file_avatar
    Files::Avatar.create!(fileable: self)
  end
end
