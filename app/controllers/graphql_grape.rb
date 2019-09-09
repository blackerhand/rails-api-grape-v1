# all grape extend it
class GraphqlGrape < Grape::API
  content_type :json, 'application/json'
  default_format :json

  helpers do
    # Handle form data, JSON body, or a blank value
    def ensure_hash(ambiguous_param)
      case ambiguous_param
      when String
        if ambiguous_param.present?
          ensure_hash(JSON.parse(ambiguous_param))
        else
          {}
        end
      when Hash, ActionController::Parameters
        ambiguous_param
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
      end
    end
  end

  post '/' do
    GrapeApiSchema.execute(params[:query],
                           variables: ensure_hash(params[:variables]),
                           operation_name: params[:operationName],
                           context: {
                             # Query context goes here, for example:
                             # current_user: current_user,
                           })
  end
end
