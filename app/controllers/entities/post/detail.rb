module Entities
  module Post
    class Detail < Base
      expose :title, :desc, :created_at
    end
  end
end
