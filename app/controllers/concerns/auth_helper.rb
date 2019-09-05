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

  # 执行 pundit 验证, authorize(record, policy_method)
  # 新加一个api 以后, 需要新建一个对应的 policy 文件, 然后定义相应的授权方法
  # 例如: /v1/posts_grape.rb => get '/v1/posts/:id'
  #      需要新建 /v1/posts_policy.rb#get_posts_id?
  #      方法中可以使用 record, user 变量, 允许返回 true, 不允许返回 false
  def pundit_authorize
    policy_class  = policy_name.constantize
    policy_record = current_record || record_class
    policy_record.redefine_singleton_method(:policy_class) { policy_class }
    authorize(policy_record, policy_method) # if policy_class.instance_methods.include?(policy_method)
  end
end
