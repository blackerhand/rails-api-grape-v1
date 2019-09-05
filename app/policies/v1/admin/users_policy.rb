module V1
  module Admin
    class UsersPolicy < ApplicationPolicy
      def get_admin_users?
        login_required
      end
    end
  end
end
