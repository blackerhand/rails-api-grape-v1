module V1
  class AdminGrape < BaseGrape
    before do
      raise PermissionDeniedError, 'you can\'t access this page' if user.admin?
    end

    rescue_from(PermissionDeniedError) { |e| permit_error!(e) }

    get '/' do
      'admin index'
    end
  end
end
