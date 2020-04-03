# all grape extend it
class BaseGrape < Grape::API
  include Grape::Rails::Cache

  content_type :json, 'application/json'
  default_format :json

  helpers ApplicationHelper, ErrorHelper, DataBuildHelper, CacheHelper

  # 401
  rescue_from(SignError) { |e| auth_error!(e) }
  rescue_from(Svc::JwtSignature::SignError) { |e| auth_error!(e) }
  rescue_from(PermissionDeniedError) { |e| auth_error!(e) }

  # 403
  rescue_from(Pundit::NotAuthorizedError) { |e| permit_error!(e) }

  # 404
  rescue_from(RecordAlreadyDisabled) { |e| not_found_error!(e) }
  rescue_from(ActiveRecord::RecordNotFound) { |_e| not_found_error!('该条数据状态已变更，请刷新列表重试') }

  # 406
  rescue_from(ActiveRecord::RecordInvalid) { |e| valid_error!(e) }
  rescue_from(Grape::Exceptions::ValidationErrors) { |e| valid_error!(e) }
  rescue_from(RecordCheckInvalid) { |e| valid_error!(e) }
  rescue_from(SearchError) { |e| valid_error!(e) }

  # 409
  rescue_from(AASM::InvalidTransition) { |_e| not_allow_error!('该条数据当前状态, 不允许变更为选定状态, 请检查') }
  rescue_from(RecordNotAllowDisabled) { |e| not_allow_error!(e) }
  rescue_from(RecordStateError) { |e| not_allow_error!(e) }

  # add the handle need before this code
  mount SignGrape
  mount AdminGrape
  mount PubGrape

  get '/' do
    { status: 'ok' }
  end

  add_swagger_documentation(
    mount_path:  '/api/swagger',
    doc_version: '0.1.0'
  )
end
