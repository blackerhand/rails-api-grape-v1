class User < ApplicationRecord
  attr_accessor :limits

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

  def gen_code
    return code if code.present? && Time.current - updated_at < 60

    update!(code: rand(999_999))
    code
  end

  def self.build_with!(payload = {})
    payload = Hashie::Mash.new(payload) rescue Hashie::Mash.new
    raise SignError, '登录失败, 请重试' if payload.id.blank?

    payload.limits = payload.limits.map(&:to_s).select(&:present?).uniq
    raise SignError, '用户权限信息不存在, 请检查' if payload.limits.blank?

    user        = find(payload.id)
    user.limits = payload.limits
    user
  end

  def has_limits!(limit_name)
    raise PermissionDeniedError, '没有权限, 请与后台管理员联系' unless has_limits?(limit_name)
  end

  def has_limits?(limit_name)
    limits.include?(limit_name.to_s)
  end
end
