module V1
  module Admin
    class ResourcesGrape < AdminGrape
      get '/' do
        Resource.arrange.each do |root, sub|

        end
      end
    end
  end
end
