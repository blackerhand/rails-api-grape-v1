# rubocop:disable Lint/Void, Naming/UncommunicativeMethodParamName
module ErrorHelper
  def auth_error!(e, meta = {})
    meta[:status] ||= 401
    error!(error_message(e, meta), meta[:status])
  end

  def permit_error!(e, meta = {})
    meta[:status] ||= 403
    error!(error_message(e, meta), meta[:status])
  end

  def valid_error!(e, meta = {})
    meta[:status] ||= 406
    error!(error_message(e, meta), meta[:status])
  end

  def not_allow_error!(e, meta = {})
    meta[:status] ||= 409
    error!(error_message(e, meta), meta[:status])
  end

  def error_422!(message, meta = {})
    meta[:status] ||= 422
    error!(error_message(message, meta), meta[:status])
  end

  def not_found_error!(message, meta = {})
    meta[:status] ||= 404
    error!(error_message(message, meta), meta[:status])
  end

  private

  def error_desc(e)
    e.is_a?(Hash) ? {} : { type: e.class.to_s, message: e.message }
  end

  def error_meta(e)
    meta               = base_meta
    base_object        = e.instance_variable_get(:@base)
    meta[:base_object] = { type: base_object.class, id: base_object.id } if base_object
    meta[:message]     = meta_error_message(e)
    meta[:type]        = e.class.to_s
    meta
  end

  def meta_error_message(e)
    message =
      if e.is_a?(ActiveRecord::RecordNotFound)
        '该' + I18n.t("activerecord.models.#{e.model.underscore}") + '已被删除'
      elsif e.respond_to?(:full_messages)
        e.send(:full_messages)
      elsif e.respond_to?(:message)
        e.message
      else
        e
      end

    message.is_a?(Array) ? message.join(', ') : message
  end

  def error_message(e, meta)
    errors =
      case e
      when ActiveModel::Errors
        e.messages.map.each { |key, message| { field: key, message: message } }
      when ActiveRecord::RecordInvalid
        e.record.errors.messages.map.each { |key, message| { field: key, message: message } }
      when Grape::Exceptions::ValidationErrors
        e.errors.map.each { |field, messages| { field: field.first, message: messages.map(&:message).join(',') } }
      end

    { meta: error_meta(e).merge!(meta), errors: errors }
  end
end
# rubocop:enable Lint/Void, Naming/UncommunicativeMethodParamName
