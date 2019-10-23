module Clients
  class Sign < BaseClient
    def set_request
      {
        query_params: {
          apiName:    'externalLogin',
          apiVersion: '1.0',
          saleSystem: 'WMS',
          clientType: '01',
          tradeWay:   '03',
          operator:   other_params.id,
          password:   other_params.passwd,
          graphCode:  '0000'
        },
        http_method:  'post',
        data_type:    :json,
        url:          ENV['PERMIT_URL']
      }
    end

    def response_valid?
      response.resultCode == 'SUCCESS'
    end

    def build_response_data
      if response_valid
        {
          id:    response.operator,
          roles: (response.body.try(:roleList) || []).map do |role|
            role['name'] if role['name'] =~ /vs/
          end
        }
      else
        response.message || '系统异常, 请稍后再试'
      end
    end

    def user
      User.build_with(response_data) if response_valid?
    end
  end
end
