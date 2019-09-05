# helpers for sign grape
module AuthHelper
  def parse_jwt
    return unless request.headers['Authorization']

    payload       = Svc::JwtSignature.verify!(request.headers['Authorization']).first
    @current_user = User.find(payload['id'])
    raise SignError, '校验失败, 请退出重新登录' if @current_user.nil?

    @payload = @current_user.payload
  end

  # 执行 pundit 验证, authorize(record, policy_method)
  # mode-require:
  # 新加一个api 以后, 需要新建一个对应的 policy 文件, 然后定义相应的授权方法
  # 例如: /v1/posts_grape.rb => get '/v1/posts/:id'
  #      需要新建 /v1/posts_policy.rb#get_posts_id?
  #      方法中可以使用 record, user 变量, 允许返回 true, 不允许返回 false
  # mode-optional:
  # 只会校验定义了 policy 的 api, 取消注释 if 即可, 不推荐
  def pundit_authorize
    policy_class_tmp = policy_class # 临时解决
    policy_record    = current_record || record_class

    policy_record.define_singleton_method(:policy_class) { policy_class_tmp }
    authorize(policy_record, policy_method) # if policy_class.instance_methods.include?(policy_method)
  end

  def verify_admin!
    raise PermissionDeniedError, 'you can\'t access this page' unless current_user.is_a?(Admin)
  end
end
