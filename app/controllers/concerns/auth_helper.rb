# helpers for sign grape
module AuthHelper
  def verify_jwt!
    payload       = Svc::JwtSignature.verify!(request.headers['Authorization']).first
    @current_user = User.find(payload['id'])
    raise SignError, '校验失败, 请退出重新登录' if @current_user.nil?

    @payload = @current_user.payload
  end

  def authenticate_required?
    !GRAPE_API::AUTH_UN_REQUIRED.include?(resource_name)
  end

  def owner_required?
    GRAPE_API::OWNER_REQUIRED.include?(resource_name)
  end

  def verify_owner!
    raise OwnerDeniedError, 'You is not the owner' if current_user.nil? || current_user_id != current_record.owner
  end
end
