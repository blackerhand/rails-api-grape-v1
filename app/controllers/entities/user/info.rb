module Entities
  module User
    class Info < Base
      expose :nickname, :email, :avatar_url, :disabled_at
    end
  end
end
