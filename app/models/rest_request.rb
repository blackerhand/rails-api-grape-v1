# == Schema Information
#
# Table name: rest_requests
#
#  id               :integer          not null, primary key
#  http_method      :string(255)
#  url              :string(255)
#  headers          :text(65535)
#  query_params     :text(65535)
#  data_type        :string(255)
#  data             :text(65535)
#  status_code      :integer
#  response         :text(65535)
#  response_headers :text(65535)
#  response_status  :boolean
#  response_data    :text(65535)
#  type             :string(255)
#  requestable_id   :string(255)
#  requestable_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  request_data     :text(65535)
#  is_valid         :boolean
#

class RestRequest < ApplicationRecord
  attr_accessor :response_obj

  belongs_to :requestable, polymorphic: true, optional: false

  def self.execute(attrs, &block)
    req = new(attrs)
    req.build_request
    req.default_request
    req.is_valid = req.request_valid?
    req.save! # save request

    req.execute(&block) if req.is_valid
    req
  end

  def default_request
    @headers_hash                ||= { charset: 'UTF-8' } # accept: :json
    @query_params_hash           ||= {}
    @data_hash                   ||= {}
    @headers_hash[:content_type] = :json if json_request?

    self.headers      = @headers_hash.to_json
    self.data         = @data_hash.to_json unless file_request?
    self.query_params = @query_params_hash.to_json
  end

  def http_get_execute
    RestClient.get("#{url}?#{query_params_hash.to_query}", headers_hash)
  rescue RestClient::ExceptionWithResponse => e
    # :nocov:
    e.response
    # :nocov:
  end

  def http_post_execute
    real_data = json_request? ? data_hash.to_json : data_hash.to_hash
    RestClient.post("#{url}?#{query_params_hash.to_query}", real_data, headers_hash.to_hash.symbolize_keys)
  rescue RestClient::ExceptionWithResponse => e
    # :nocov:
    e.response
    # :nocov:
  end

  def result
    response_data_hash.data.presence || response_data_hash.error.presence
  end

  def execute
    self.response_obj = get? ? http_get_execute : http_post_execute
    raise RestRequestError, 'response_obj is nil' unless response_obj

    save_response
    save_response_result

    yield self if block_given?

    self
  end

  def save_response
    self.status_code      = response_obj.code
    self.response         = response_obj.body if response_obj.body.size < GRAPE_API::HTTP_FILE_SIZE_LIMIT && !file_response?
    self.response_headers = response_obj.headers.to_json
    save!
  end

  def save_response_result
    self.response_status = !!response_status_check
    @response_data_hash  = response_status ? { data: rsp_success_data } : { error: rsp_error_msg }
    raise RestRequestError, '三方请求异常, 请与管理员联系' if result.blank?

    self.response_data = @response_data_hash.to_json
    save!
  end

  def request_valid?
    true
  end

  def build_request
    # callback
  end

  def after_request
    # callback
  end

  def after_request_save
    # callback
  end

  # 判断请求是否到达第三方接口, 并处理. 若为 true 不再重复调用
  def response_status_check
    status_code == 200
  end

  # 业务预期操作成功时返回的 data
  def rsp_success_data
    'success'
  end

  # 业务失败时返回的错误信息
  def rsp_error_msg
  end

  def get?
    http_method.to_s.casecmp('get').zero?
  end

  def post?
    http_method.to_s.casecmp('post').zero?
  end

  def json_request?
    data_type.to_s.casecmp('json').zero?
  end

  def file_request?
    @data_hash.to_json.size > GRAPE_API::HTTP_FILE_SIZE_LIMIT
  end

  def json_response?
    response_headers_hash['content_type'].to_s =~ /json/
  end

  def file_response?
    response_headers_hash['content_type'].to_s =~ /(stream|file)/
  end

  %i[query_params_hash data_hash headers_hash request_data_hash
     response_hash response_data_hash response_headers_hash].each do |hash_key|
    define_method hash_key do
      iv_key = "@#{hash_key}".to_sym

      result =
        if instance_variable_get(iv_key).present?
          instance_variable_get(iv_key)
        else
          json_field = hash_key.to_s.gsub(/_hash/, '').to_sym
          instance_variable_set iv_key, (JSON.parse(send(json_field)) rescue {})
        end

      Hashie::Mash.new(result) rescue Hashie::Mash.new({})
    end
  end
end
