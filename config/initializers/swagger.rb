if Rails.env.development?
  GrapeSwaggerRails.options.app_name = 'API Doc'
  GrapeSwaggerRails.options.url      = '/api/swagger'
  GrapeSwaggerRails.options.before_action do
    GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
  end

# GrapeSwaggerRails.options.api_auth     = 'basic'
# GrapeSwaggerRails.options.api_key_name = 'Authorization'
# GrapeSwaggerRails.options.api_key_type = 'header'
#
# GrapeSwaggerRails.options.before_action do |request|
#   authenticate_or_request_with_http_basic do |name, password|
#     name == 'ab' && password == 'ac'
#   end
# end
end
