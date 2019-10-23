class User < ApplicationRecord
  attr_accessor :roles

  rolify

  action_store :favorite, :post, counter_cache: true, user_counter_cache: true # 收藏
  action_store :like, :post, counter_cache: true, user_counter_cache: true # 点赞
  action_store :unlike, :post, counter_cache: true, user_counter_cache: true # 点踩

  def payload
    {
      id:        id,
      openid:    openid,
      roles:     roles,
      resources: resources
    }
  end

  def avatar_url
    files_avatar.file_url
  end

  def gen_code
    return code if code.present? && Time.current - updated_at < 60

    update!(code: rand(999_999))
    code
  end

  def self.build_with(payload)
    return unless payload.is_a?(Hash)

    payload = Hashie::Mash.new(payload)
    return if payload.id.blank?

    payload.roles = [payload.roles] unless payload.roles.is_a?(Array)
    payload.roles = payload.roles.select(&:present?).uniq.map(&:to_sym)
    user          = find_or_create_by!(openid: payload.id)
    user.roles    = payload.roles
    user
  end

  def resources
    @roles.map { |role| GRAPE_API::RESOURCES_MAP[role] || [] }.flatten.uniq
  end

  def has_resources!(resource_name)
    raise PermissionDeniedError, '没有权限, 请与后台管理员联系' unless has_resources?(resource_name)
  end

  def has_resources?(resource_name)
    resources.include?(resource_name)
  end
end
