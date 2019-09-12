module Entities
  module User
    class Info < Base
      expose :nickname, :email, :avatar_url
    end
  end
end
