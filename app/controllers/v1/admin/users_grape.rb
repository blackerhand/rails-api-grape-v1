module V1
  module Admin
    class UsersGrape < AdminGrape
      get '/' do
        'user index'
      end
    end
  end
end
