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
end
