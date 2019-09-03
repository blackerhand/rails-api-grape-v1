# global helpers
module ApplicationHelper
  def current_user
    return if @payload.blank?
    @current_user ||= User.find_by(@payload)
  end

  def current_user_id
    current_user.try(:id)
  end

  def resource_name
    request.request_method + routes.first.origin
  end
end
