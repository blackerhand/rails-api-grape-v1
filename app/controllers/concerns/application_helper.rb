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

  def controller_name
    self.source.to_s.match(/v\d+\/\w+_grape/).to_s.classify
  end

  def record_class
    self.source.to_s.match(/(\w+)_grape/)[1].singularize.classify.constantize
  end

  def current_record
    return if params.id.blank?
    @record ||= record_class.find(params.id)
  end
end
