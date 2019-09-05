class PubGrape < BaseGrape
  # mounts
  mount V1::StaticGrape => '/v1'
end
