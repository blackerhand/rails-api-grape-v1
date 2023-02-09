# == Schema Information
#
# Table name: users
#
#  id                   :bigint           not null, primary key
#  code                 :string(6)
#  disabled_at          :datetime
#  email                :string(100)
#  favorite_posts_count :integer          default(0)
#  like_posts_count     :integer          default(0)
#  nickname             :string(20)
#  password_digest      :string(255)
#  type                 :string(255)
#  unlike_posts_count   :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  created_user_id      :bigint
#  updated_user_id      :bigint
#

class User < ApplicationRecord
  include Disable
  has_secure_password
  rolify

  has_one :files_avatar, class_name: 'Files::Avatar', as: :fileable

  action_store :favorite, :post, counter_cache: true, user_counter_cache: true # 收藏
  action_store :like, :post, counter_cache: true, user_counter_cache: true # 点赞
  action_store :unlike, :post, counter_cache: true, user_counter_cache: true # 点踩

  validates :email, presence: true, uniqueness: true

  def resource_names
    @resource_names ||= Acl.where(role_id: roles.pure_roles.ids)
                           .joins(:resource)
                           .select("resources.name as resource_name")
                           .map(&:resource_name).uniq
  end

  # 超级管理员默认拥有所有权限，非超级管理员需要判断对于该资源是否有权限
  def has_resources?(resource_name)
    has_role?(:super_admin) || resource_names.include?(resource_name)
  end

  def payload
    slice(:id)
  end

  def gen_code!
    update!(code: rand(999_999).to_s.rjust(6, '0'))
    code
  end

  def self.build_with!(payload = {})
    payload = Hashie::Mash.new(payload) rescue Hashie::Mash.new
    raise SignError, '登录失败, 请重试' if payload.id.blank?

    user = find(payload.id)
    user
  end

  def avatar_url
    files_avatar.file_url
  end

  after_create :init_avatar

  def init_avatar
    return unless files_avatar.nil?

    avatar            = Files::Avatar.new
    avatar.file       = File.open(Rails.root.join("public/images/fallback/#{id % 10}.png"))
    self.files_avatar = avatar
  end
end
