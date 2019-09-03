# base for sign grapes
class SignGrape < BaseGrape
  helpers AuthHelper

  before { verify_jwt! if authenticate_required? }

  rescue_from(SignError) { |e| valid_error!(e) }
  rescue_from(Svc::JwtSignature::SignError) { |e| auth_error!(e) }

  # mounts
  mount V1::UsersGrape => '/v1/users'
  mount V1::AdminGrape => '/v1/admins'
end
