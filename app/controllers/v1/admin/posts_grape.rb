module V1
  module Admin
    class PostsGrape < AdminGrape
      get '/' do
        # current_user.available_posts
      end
    end
  end
end
