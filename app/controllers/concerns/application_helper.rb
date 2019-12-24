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

  def page_per
    params[:per] || GRAPE_API::PER_PAGE
  end

  def declared_params
    declared(params, include_missing: false)
  end

  def full_params
    declared(params, include_missing: true)
  end

  # 解决 full_params Array[JSON] 对象为空时, 参数不为数组的 BUG
  def map_array_json(array_params)
    return [] unless array_params.is_a?(Array)

    array_params.map(&:to_hash)
  end

  def upload_file(file_type, params_file)
    file_class = file_type.safe_constantize
    valid_error!('文件类型不正确') if file_class.nil?
    valid_error!('同一种类型的文件只能上传一个, 请删除后重试') if file_class.enabled.exists?(fileable: current_record)

    @file_object = file_class.create!(fileable: current_record, file: params_file)
  end
end
