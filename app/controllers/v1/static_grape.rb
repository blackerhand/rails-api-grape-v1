module V1
  class StaticGrape < PubGrape
    get '/about' do
      'pub page'
    end
  end
end
