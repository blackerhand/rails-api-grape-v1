module V1
  # user apis
  class UsersGrape < SignGrape
    params do
      requires :email, allow_blank: false, regexp: GRAPE_API::EMAIL_REGEX
      requires :passwd, type: String
    end
    post '/sign_in' do
      @user = User.find_by(email: params[:email])

      auth_error!('The email not exists') if @user.nil?
      auth_error!('The password is incorrect') unless @user.authenticate(params[:passwd])

      @payload = @user.payload
      data!(token: Svc::JwtSignature.sign(@payload))
    end

    params do
      requires :email, allow_blank: false, regexp: RANK::EMAIL_REGEX
      requires :nickname, :passwd, allow_blank: false, type: String
    end
    post '/sign_up' do
      @payload = User.create!(email: params[:email], nickname: params[:nickname], password: params[:passwd]).payload
      data!(token: Svc::JwtSignature.sign(@payload))
    end

    params do
      requires :email, allow_blank: false, regexp: RANK::EMAIL_REGEX
    end
    post '/send_mail' do
      @user = User.find_by(email: params[:email])
      auth_error!('The email not exists') if @user.nil?
      UserMailer.reset_email(@user).deliver_now
      data!('Success')
    end

    params do
      requires :email, allow_blank: false, regexp: RANK::EMAIL_REGEX
      requires :code, regexp: /^\d{6}$/
      requires :passwd, type: String
    end
    post '/reset' do
      @user = User.find_by(email: params[:email])
      auth_error!('The email not exists') if @user.nil?
      auth_error!('The code is invalid') unless @user.code == params[:code]
      @user.update!(password: params[:passwd], code: nil)
      data!('Success')
    end
  end
end
