module Reqs
  class GrapeRequest < RestRequest
    def self.create_by_request(env)
      new.update_request(ActionDispatch::Request.new(env))
    end

    def update_request(request)
      self.data         = request.params.to_json if request.params.to_json.size < GRAPE_API::HTTP_FILE_SIZE_LIMIT
      self.headers      = request.headers.select { |k, _v| k.start_with? 'HTTP_' }.to_h.to_json
      self.query_params = request.query_parameters.to_json

      save(validate: false) && self
    end

    def update_response(status, headers, body)
      self.status_code      = status
      self.response         = body.to_json if body.to_json.size < GRAPE_API::HTTP_FILE_SIZE_LIMIT
      self.response_headers = headers.to_json

      save(validate: false) && self
    end
  end
end
