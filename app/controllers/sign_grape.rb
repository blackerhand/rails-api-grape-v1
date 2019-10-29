# base for sign grapes
class SignGrape < BaseGrape
  helpers AuthHelper
  helpers Pundit

  before do
    parse_jwt
    pundit_authorize
  end

  rescue_from(SignError) { |e| auth_error!(e) }
  rescue_from(Svc::JwtSignature::SignError) { |e| auth_error!(e) }
  rescue_from(Pundit::NotAuthorizedError) { |e| permit_error!(e) }

  # mounts
  mount V1::UsersGrape => '/v1/users'
end
