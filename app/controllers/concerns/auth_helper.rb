# helpers for sign grape
module AuthHelper
  def verify_jwt!
    payload       = Svc::JwtSignature.verify!(request.headers['Authorization']).first
    @current_user = User.find(payload['id'])
    raise SignError, '校验失败, 请退出重新登录' if @current_user.nil?

    @payload = @current_user.payload
  end

  def authenticate_required?
    !GRAPE_API::AUTH_UN_REQUIRED.include?(request.path)
  end

  def current_user
    return if @payload.blank?
    @current_user ||= User.find_by(@payload)
  end

  def current_user_id
    current_user.try(:id)
  end
end
