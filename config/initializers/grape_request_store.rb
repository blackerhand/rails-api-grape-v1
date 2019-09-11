class GrapeRequestStore
  def initialize(app)
    @app = app
  end

  def call(env)
    req = Reqs::GrapeRequest.create_by_request(env)
    status, headers, body = @app.call(env)
    req.update_response(status, headers, body)

    [status, headers, body]
  end
end

Rails.application.config.middleware.use GrapeRequestStore
