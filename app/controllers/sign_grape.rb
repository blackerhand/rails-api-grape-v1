# base for sign grapes
class SignGrape < BaseGrape
  helpers AuthHelper

  before { verify_jwt! if authenticate_required? }

  rescue_from(SignError) { |e| valid_error!(e) }
  rescue_from(Svc::JwtSignature::SignError) { |e| auth_error!(e) }
  rescue_from(PermissionDeniedError) { |e| permit_error!(e) }

  # mounts
  mount V1::UsersGrape => '/v1/users'
end
