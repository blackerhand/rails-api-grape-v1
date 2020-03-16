module ResourceHelper
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

  def policy_name
    "PATH_#{action_name.upcase}"
  end

  def record_class
    source.to_s.match(/(\w+)_grape/)[1].singularize.classify.safe_constantize
  end
end
