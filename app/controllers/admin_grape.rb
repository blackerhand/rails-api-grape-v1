class AdminGrape < SignGrape
  helpers AuthHelper
  helpers Pundit

  before do
    parse_jwt
    verify_admin!
    resource_authorize
    pundit_authorize
  end

  rescue_from(SignError) { |e| valid_error!(e) }
  rescue_from(Svc::JwtSignature::SignError) { |e| auth_error!(e) }
  rescue_from(Pundit::NotAuthorizedError) { |e| permit_error!(e) }
  rescue_from(PermissionDeniedError) { |e| permit_error!(e) }

  mount V1::Admin::UsersGrape => '/v1/admin/users'
  mount V1::Admin::PostsGrape => '/v1/admin/posts'
  mount V1::Admin::RolesGrape => '/v1/admin/roles'
  mount V1::Admin::ResourcesGrape => '/v1/admin/resources'
end
