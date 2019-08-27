module V1
  # user apis
  class UsersGrape < SignGrape
    params do
      requires :email, allow_blank: false
      requires :passwd, type: String
    end

    get '/sign_in' do
      'this is a demo'
    end
  end
end
