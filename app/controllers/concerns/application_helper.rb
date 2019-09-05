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
    source.to_s.match(/v\d+\/(\w+\/)?\w+_grape/).to_s.classify
  end

  def action_name
    request.request_method.downcase + routes.first.origin.gsub(/((\/v\d+)\/|(\/:))|\//, '_')
  end

  def policy_class
    source.to_s.match(/v\d+\/(\w+\/)?\w+_grape/).to_s.sub('grape', 'policy').classify.constantize
  end

  def policy_method
    "#{action_name}?".to_sym
  end

  def record_class
    source.to_s.match(/(\w+)_grape/)[1].singularize.classify.safe_constantize
  end

  def current_record
    return if params.id.nil? || record_class.nil?

    @current_record ||= record_class.find(params.id)
  end
end
