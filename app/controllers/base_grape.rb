# all grape extend it
class BaseGrape < Grape::API
  content_type :json, 'application/json'
  default_format :json

  helpers ApplicationHelper, ErrorHelper, DataBuildHelper

  rescue_from(ActiveRecord::RecordInvalid) { |e| valid_error!(e) }
  rescue_from(Grape::Exceptions::ValidationErrors) { |e| valid_error!(e) }

  # add the handle need before this code
  mount SignGrape

  get '/' do
    { status: 'ok' }
  end

  add_swagger_documentation(
    mount_path:  '/api/swagger',
    doc_version: '0.1.0'
  )
end
