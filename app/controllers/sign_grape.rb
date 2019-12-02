# base for sign grapes
class SignGrape < BaseGrape
  helpers AuthHelper
  helpers Pundit

  before do
    parse_jwt
    pundit_authorize
    set_papertrail_user(current_user.id)
  end

  # mounts
  mount V1::UsersGrape => '/v1/users'
end
