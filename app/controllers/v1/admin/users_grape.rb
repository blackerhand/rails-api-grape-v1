module V1
  module Admin
    class UsersGrape < AdminGrape
      desc '用户列表' do
        summary '用户列表'
        detail '用户列表'
        tags ['admin_users']
      end
      get '/' do
        @users = User.all
        data_paginate! @users, Entities::User::Info
      end

      desc '新增用户' do
        summary '新增用户'
        detail '新增用户'
        tags ['admin_users']
      end
      params do
        requires :email, allow_blank: false, regexp: GRAPE_API::EMAIL_REGEX
        requires :nickname, :passwd, allow_blank: false, type: String
        requires :passwd, type: String
      end
      post '/' do
        @user = User.create!(type:     'User',
                             email:    params[:email],
                             nickname: params[:nickname],
                             password: params[:passwd])
        data_record!(@user, Entities::User::Info)
      end

      desc '新增管理员' do
        summary '新增管理员'
        detail '新增管理员'
        tags ['admin_users']
      end
      params do
        requires :email, allow_blank: false, regexp: GRAPE_API::EMAIL_REGEX
        requires :nickname, :passwd, allow_blank: false, type: String
        requires :passwd, type: String
        requires :is_admin, type: Boolean
      end
      post '/admin' do
        @user = User.create!(type:     'Admin',
                             email:    params[:email],
                             nickname: params[:nickname],
                             password: params[:passwd])
        @user.add_role(:super_admin) if params[:is_admin]

        data_record!(@user, Entities::User::Info)
      end

      route_param :id, requirements: { id: /[0-9]+/ } do
        desc '管理用户' do
          summary '管理用户'
          detail '管理用户'
          tags ['admin_users']
        end
        params do
          requires :passwd, type: String
          optional :is_disabled, type: Boolean
        end
        put '/' do
          current_record.update!(password: params[:passwd]) if params[:passwd]

          unless params[:is_disabled].nil?
            params[:is_disabled] ? current_record.disabled! : current_record.enabled!
          end

          data_record!(current_record.reload, Entities::User::Info)
        end
      end
    end
  end
end
