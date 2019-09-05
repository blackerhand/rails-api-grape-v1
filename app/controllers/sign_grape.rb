# base for sign grapes
class SignGrape < BaseGrape
  helpers AuthHelper
  helpers Pundit

  before do
    verify_jwt! if authenticate_required?

    policy_class = policy_name.constantize
    record_class.redefine_singleton_method(:policy_class) { policy_class }
    authorize(record_class, policy_method) if policy_class.instance_methods.include?(policy_method)
  end

  rescue_from(SignError) { |e| valid_error!(e) }
  rescue_from(Svc::JwtSignature::SignError) { |e| auth_error!(e) }
  rescue_from(Pundit::NotAuthorizedError) { |e| permit_error!(e) }

  # mounts
  mount V1::UsersGrape => '/v1/users'
  mount V1::AdminGrape => '/v1/admins'
end
