# all grape extend it
class BaseGrape < Grape::API
  content_type :json, 'application/json'
  default_format :json

  helpers ApplicationHelper, ErrorHelper, DataBuildHelper

  rescue_from(ActiveRecord::RecordInvalid) { |e| valid_error!(e) }
  rescue_from(Grape::Exceptions::ValidationErrors) { |e| valid_error!(e) }

  get '/' do
    { status: 'ok' }
  end
end
